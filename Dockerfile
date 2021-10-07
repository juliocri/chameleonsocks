#
# Copyright (C) 2016 Intel Corporation
#
# Author: Todor Minchev <todor.minchev@linux.intel.com>
#
# This program is free software; you can redistribute it and/or modify it
# under the terms and conditions of the GNU General Public License,
# version 2, or (at your option) any later version, as published by
# the Free Software Foundation.
#
# This program is distributed in the hope it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.
#

# This file describes the standard way to build a redsocks image for
# generic firewalls
#
# Usage:
#
# docker build -t juliocri/chameleonsocks -f Dockerfile .

FROM debian:bullseye
MAINTAINER Julio C Rivera <julio.c.rivera.gonzalez@intel.com>
ENV CHAMELEONSOCKS_VERSION v1.5

# Install dependencies
RUN apt-get update && apt-get install -y \
	redsocks \
	curl \
	python \
	python3-pip \
	iptables && pip install iptools

# https://wiki.debian.org/iptables
# NOTE: Debian Buster uses the nftables framework by default.
# Switching to the legacy version:
RUN update-alternatives --set iptables /usr/sbin/iptables-legacy
RUN update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

RUN mkdir -p /tmp/chameleonsocks/confs/
COPY confs /tmp/chameleonsocks/confs/
RUN chmod 755 /tmp/chameleonsocks/confs/redsocks && \
chmod 755 /tmp/chameleonsocks/confs/chameleonsocks && \
mv /tmp/chameleonsocks/confs/redsocks /etc/init.d/ && \
mv /tmp/chameleonsocks/confs/redsocks.conf /etc/  && \
mv /tmp/chameleonsocks/confs/pac.py /etc/  && \
mv /tmp/chameleonsocks/confs/chameleonsocks /bin/ && \
echo ${CHAMELEONSOCKS_VERSION} > /etc/chameleonsocks-version

ENTRYPOINT ["chameleonsocks"]
