#!/bin/bash
# Launch cupds in the foreground
echo "Starting Cups Demon"
/usr/sbin/cupsd

echo "Cups Information:"
#Print Cups Info
lpinfo -v

if [ -z "${PRINTER_CUPS_DEVICE_URI}" ]; then
    echo "Set environment variable PRINTER_CUPS_DEVICE_URI to the correct device URI from the above output before restarting the container."
    exit
fi

echo "Adding Printer to Cups"
# Add the printer
lpadmin -p dymo -v ${PRINTER_CUPS_DEVICE_URI} -P /usr/share/cups/model/${PRINTER_MODEL}.ppd

echo "Print Cups Stats"
# Stats
lpstat -v

echo "Start Dymo Printer and accept new Jobs"
# Start and Accept Jobs
cupsenable dymo
cupsaccept dymo

echo "Setting Default Printer"
# Set Default Printer
lpoptions -d dymo

echo "Finished Setup! XD"

# Test Print
lp -d dymo test.txt

# Keep the container running
/usr/sbin/cupsd -f
