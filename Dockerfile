FROM debian:bookworm

ARG DEBIAN_FRONTEND="noninteractive"

# Install dependencies
RUN apt-get clean && apt-get update && apt-get install -y \
    sudo \
    whois \
    usbutils \
    cups \
    cups-client \
    cups-bsd \
    cups-filters \
    foomatic-db-compressed-ppds \
    printer-driver-all \
    openprinting-ppds \
    hpijs-ppds \
    hp-ppd \
    hplip \
    smbclient \
    printer-driver-cups-pdf \
    printer-driver-dymo \
    git \
    libcups2-dev \
    libcupsimage2-dev \
    gcc\
    g++ \
    automake \
    avahi-daemon \
    avahi-utils \
    libnss-mdns \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# Install Dymo CUPS Drivers
RUN wget http://download.dymo.com/dymo/Software/Download%20Drivers/Linux/Download/dymo-cups-drivers-1.4.0.tar.gz &&\
    tar -xzf dymo-cups-drivers-1.4.0.tar.gz &&\
    mkdir -p /usr/share/cups/model &&\
    cp dymo-cups-drivers-1.4.0.5/ppd/*.ppd /usr/share/cups/model/

# Install Dymo SDK Patch
RUN cd ~/ &&\
    git clone https://github.com/ScottGibb/DYMO-SDK-for-Linux.git &&\
    cd DYMO-SDK-for-Linux &&\
    aclocal &&\
    automake --add-missing &&\
    autoconf &&\
    ./configure &&\
    make &&\
    make install

# Expose port 631 for CUPS web interface
EXPOSE 631

# Add user and disable sudo password checking
RUN useradd \
    --groups=sudo,lp,lpadmin \
    --create-home \
    --home-dir=/home/print \
    --shell=/bin/bash \
    --password=$(mkpasswd print) \
    print \
    && sed -i '/%sudo[[:space:]]/ s/ALL[[:space:]]*$/NOPASSWD:ALL/' /etc/sudoers

# Copy the default configuration file
COPY --chown=root:lp cupsd.conf /etc/cups/cupsd.conf

COPY . .

ENV PRINTER_MODEL=lp450 \
    PRINTER_CUPS_DEVICE_URI=""

RUN echo "Updating avahi config for dns-sd printer discovery..." \
    sed -i 's/#enable-dbus=yes/enable-dbus=no/g' /etc/avahi/avahi-daemon.conf

RUN chmod +x /setup.sh

# Run CUPS in the foreground
CMD ["./setup.sh"]
