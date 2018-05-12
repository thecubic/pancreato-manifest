#!/bin/bash

topdir=$1
shift

relpath=$(/bin/dirname $0)
abspath=$(/bin/realpath ${relpath})

if [ ! -d "${topdir}" ]; then
  echo "usage: $0 <topdir>" >/dev/stderr
  exit 1
fi
abstopdir=$(/bin/realpath ${topdir})


# this script should be two levels down from the root
projectroot=$(/bin/realpath ${relpath}/../../)


if [ ! -f "${topdir}/.pancreato" ]; then
  echo "defining new build in ${abstopdir}"
  /bin/mkdir -p ${topdir}/conf
  /bin/mkdir -p ${projectroot}/bbcache{-sstate,-downloads}
  /bin/cat > ${topdir}/init.sh <<EOINIT
source ${projectroot}/poky/oe-init-build-env ${abstopdir}
EOINIT

  /bin/cat > ${topdir}/conf/local.conf <<EOLOCAL
base_libdir = "/lib64"
BB_NUMBER_THREADS = "4"
PARALLEL_MAKE = "-j8"
MACHINE = "edison"
DISTRO = "poky-edison"
USER_CLASSES ?= "buildstats image-mklibs image-prelink"
PATCHRESOLVE = "noop"
CONF_VERSION = "1"
EDISONREPO_TOP_DIR = "${projectroot}"
DL_DIR ?= "${projectroot}/bbcache-downloads"
SSTATE_DIR ?= "${projectroot}/bbcache-sstate"
BUILDNAME = "pancreato-edison"
LICENSE_FLAGS_WHITELIST += "commercial"
COPY_LIC_MANIFEST = "1"
COPY_LIC_DIRS = "1"
FILESYSTEM_PERMS_TABLES = "${projectroot}/meta-intel-edison-distro/files/fs-perms.txt"
PACKAGE_CLASSES ?= "package_rpm"
CORE_IMAGE_EXTRA_INSTALL = " \\
  python-core \\
  python-pip \\
  tmux \\
  screen \\
  curl \\
  wget \\
  git \\
  python3-pip \\
  python3-requests \\
  npm \\
  watchdog \\
  strace \\
  tcpdump \\
  acpid \\
  vim \\
  locate \\
  jq \\
  lm-sensors \\
  python-requests \\
  python-asn1crypto \\
  python3-crypt \\
  python3-bcrypt \\
  python-pyusb \\
  python3-pyusb \\
  mosh \\
  links \\
  btrfs-tools \\
"
EOLOCAL

  /bin/cat > ${topdir}/conf/initramfs.conf <<EOIRFS
INITRAMFS_IMAGE = "core-image-minimal-initramfs"
INITRAMFS_IMAGE_BUNDLE = "1"
INITRAMFS_MAXSIZE ="15728640"

IMAGE_FSTYPES = "cpio.gz"
IMAGE_INSTALL+="kernel-modules"
EOIRFS

  /bin/cat > ${topdir}/conf/u-boot.conf <<EOUBOOT
require conf/multilib.conf
MULTILIBS = "multilib:lib32"
DEFAULTTUNE_virtclass-multilib-lib32 = "core2-32"
IMAGE_INSTALL_append = " lib32-libgcc"
EOUBOOT

  /bin/cat > ${topdir}/conf/bblayers.conf <<EOBBLAYERS
LCONF_VERSION = "6"
BBPATH = "\${TOPDIR}"
BBFILES ?= ""
BBLAYERS ?= " \\
  ${projectroot}/poky/meta \\
  ${projectroot}/poky/meta-poky \\
  ${projectroot}/poky/meta-yocto-bsp \\
  ${projectroot}/meta-openembedded/meta-filesystems \\
  ${projectroot}/meta-openembedded/meta-gnome \\
  ${projectroot}/meta-openembedded/meta-initramfs \\
  ${projectroot}/meta-openembedded/meta-multimedia \\
  ${projectroot}/meta-openembedded/meta-networking \\
  ${projectroot}/meta-openembedded/meta-oe \\
  ${projectroot}/meta-openembedded/meta-perl \\
  ${projectroot}/meta-openembedded/meta-python \\
  ${projectroot}/meta-openembedded/meta-webserver \\
  ${projectroot}/meta-openembedded/meta-xfce \\
  ${projectroot}/meta-golang \\
  ${projectroot}/meta-nodejs \\
  ${projectroot}/meta-intel-edison-distro \\
  ${projectroot}/meta-intel-edison-bsp \\
  ${projectroot}/meta-intel-iot-middleware \\
  "
EOBBLAYERS

fi
