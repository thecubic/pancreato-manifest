#!/bin/bash

machine=edison
relpath=$(/bin/dirname $0)
abspath=$(/bin/realpath ${relpath})
# this script should be two levels down from the root
projectroot=$(/bin/realpath ${abspath}/../..)
if [ -n "$1" ]; then
  topdir=$1
else
  topdir=$(/bin/realpath ${projectroot}/build/${machine})
fi
abstopdir=$(/bin/realpath ${topdir})
/bin/mkdir -p ${topdir}

bbdownloadsdir=${projectroot}/build/bbcache-downloads
bbsstatedir=${projectroot}/build/bbcache-sstate

if [ ! -f "${topdir}/.pancreato" ]; then
  echo "defining new build in ${abstopdir}"
  /bin/mkdir -p ${topdir}/conf
  /bin/mkdir -p ${projectroot}/build/bbcache{-sstate,-downloads}
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
DL_DIR ?= "${bbdownloadsdir}"
SSTATE_DIR ?= "${bbsstatedir}"
BUILDNAME = "pancreato-edison"
LICENSE_FLAGS_WHITELIST += "commercial"
COPY_LIC_MANIFEST = "1"
COPY_LIC_DIRS = "1"
FILESYSTEM_PERMS_TABLES = "${projectroot}/meta-intel-edison-distro/files/fs-perms.txt"
PACKAGE_CLASSES ?= "package_rpm"
CORE_IMAGE_EXTRA_INSTALL = ""
CORE_IMAGE_EXTRA_INSTALL += "python-core "
CORE_IMAGE_EXTRA_INSTALL += "python-pip "
CORE_IMAGE_EXTRA_INSTALL += "tmux "
CORE_IMAGE_EXTRA_INSTALL += "screen "
CORE_IMAGE_EXTRA_INSTALL += "curl "
CORE_IMAGE_EXTRA_INSTALL += "wget "
CORE_IMAGE_EXTRA_INSTALL += "git "
CORE_IMAGE_EXTRA_INSTALL += "python3-pip "
CORE_IMAGE_EXTRA_INSTALL += "python3-requests "
CORE_IMAGE_EXTRA_INSTALL += "npm "
CORE_IMAGE_EXTRA_INSTALL += "watchdog "
CORE_IMAGE_EXTRA_INSTALL += "strace "
CORE_IMAGE_EXTRA_INSTALL += "tcpdump "
CORE_IMAGE_EXTRA_INSTALL += "acpid "
CORE_IMAGE_EXTRA_INSTALL += "vim "
CORE_IMAGE_EXTRA_INSTALL += "locate "
CORE_IMAGE_EXTRA_INSTALL += "jq "
CORE_IMAGE_EXTRA_INSTALL += "lm-sensors "
CORE_IMAGE_EXTRA_INSTALL += "python-requests "
CORE_IMAGE_EXTRA_INSTALL += "python-asn1crypto "
CORE_IMAGE_EXTRA_INSTALL += "python3-crypt "
CORE_IMAGE_EXTRA_INSTALL += "python3-bcrypt "
CORE_IMAGE_EXTRA_INSTALL += "python-pyusb "
CORE_IMAGE_EXTRA_INSTALL += "python3-pyusb "
CORE_IMAGE_EXTRA_INSTALL += "mosh "
CORE_IMAGE_EXTRA_INSTALL += "links "
CORE_IMAGE_EXTRA_INSTALL += "btrfs-tools "
CORE_IMAGE_EXTRA_INSTALL += "cpio "
CORE_IMAGE_EXTRA_INSTALL += "e2fsprogs "
CORE_IMAGE_EXTRA_INSTALL += "grep "
CORE_IMAGE_EXTRA_INSTALL += "tar "
CORE_IMAGE_EXTRA_INSTALL += "gzip "
CORE_IMAGE_EXTRA_INSTALL += "sed "
CORE_IMAGE_EXTRA_INSTALL += "iputils "
CORE_IMAGE_EXTRA_INSTALL += "procps "
CORE_IMAGE_EXTRA_INSTALL += "p7zip "
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
BBLAYERS += "${projectroot}/poky/meta "
BBLAYERS += "${projectroot}/poky/meta-poky "
BBLAYERS += "${projectroot}/poky/meta-yocto-bsp "
BBLAYERS += "${projectroot}/meta-openembedded/meta-filesystems "
BBLAYERS += "${projectroot}/meta-openembedded/meta-gnome "
BBLAYERS += "${projectroot}/meta-openembedded/meta-initramfs "
BBLAYERS += "${projectroot}/meta-openembedded/meta-multimedia "
BBLAYERS += "${projectroot}/meta-openembedded/meta-networking "
BBLAYERS += "${projectroot}/meta-openembedded/meta-oe "
BBLAYERS += "${projectroot}/meta-openembedded/meta-perl "
BBLAYERS += "${projectroot}/meta-openembedded/meta-python "
BBLAYERS += "${projectroot}/meta-openembedded/meta-webserver "
BBLAYERS += "${projectroot}/meta-openembedded/meta-xfce "
BBLAYERS += "${projectroot}/meta-golang "
BBLAYERS += "${projectroot}/meta-nodejs "
BBLAYERS += "${projectroot}/meta-intel-edison-distro "
BBLAYERS += "${projectroot}/meta-intel-edison-bsp "
BBLAYERS += "${projectroot}/meta-intel-iot-middleware "
EOBBLAYERS

fi
