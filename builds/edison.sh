#!/bin/bash

topdir=$1
shift

relpath=$(/bin/dirname $0)
abspath=$(/bin/realpath ${relpath})

if [ ! -d "${topdir}" ]; then
  echo "usage: $0 <topdir>" >/dev/stderr
  exit 1
fi

# this script should be two levels down from the root
projectroot=$(/bin/realpath ${relpath}/../../)

if [ ! -f "${topdir}/.pancreato" ]; then
  echo "defining new build in ${topdir}"
  /bin/mkdir -p ${topdir}/conf

  /bin/cat > ${topdir}/init.sh <<EOINIT
source ${projectroot}/poky/oe-init-build-env ${topdir}
EOINIT

  /bin/cat > ${topdir}/conf/local.conf <<EOLOCAL
EOLOCAL

  /bin/cat > ${topdir}/conf/initramfs.conf <<EOIRFS
EOIRFS

  /bin/cat > ${topdir}/conf/u-boot.conf <<EOUBOOT
EOUBOOT

  /bin/cat > ${topdir}/conf/bblayers.conf <<EOBBLAYERS
EOBBLAYERS

fi
