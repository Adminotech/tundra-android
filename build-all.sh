#!/bin/bash
set -e

# Copyright (c) 2011, Mevan Samaratunga
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * The name of Mevan Samaratunga may not be used to endorse or
#       promote products derived from this software without specific prior
#       written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL PIERRE-OLIVIER LATOUR BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Additional script modifications by Jonne Nauha

if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    echo "${0} /path/to/android-ndk"
    echo "  Changing the script defined variables like android api level,"
    echo "  toolchain version, architecture etc. is experimental. Use at"
    echo "  your own risk. Additionally all folders needs to be nuked"
    echo "  of the previous build if decide to try it."
    exit 1
fi

# Retrieve NDK path to use
NDK=$1
if [ "${NDK}" == "" ] || [ ! -e ${NDK}/build/tools/make-standalone-toolchain.sh ]; then
  echo "Try --help for usage instructions."
  exit 1
fi

export SDK="${NDK}"
export PROXY=""

export BZIP2_VERSION="1.0.6"
export BOOST_VERSION="1.49.0"

# Toolchain defines
export ANDROID_API_LEVEL="14"
export ARM_TARGET="armv7"
export TOOLCHAIN_VERSION="4.4.3"
export PLATFORM="arm-linux-androideabi"

# Create dist folder
BUILDDIR=$(pwd)

export TOPDIR=$BUILDDIR
export PREFIX=$BUILDDIR/install
export PREFAB=$BUILDDIR/prefab
export PREBUILT=$BUILDDIR/prebuilt
export SRCDIR=$BUILDDIR/src
export TOOLCHAIN_DIR=$BUILDDIR/toolchain

export COLOR_GREEN="\e[1;32m"
export COLOR_END="\e[00m"

mkdir -p ${PREFIX}
mkdir -p ${SRCDIR}

echo
if [ ! -d "${TOOLCHAIN_DIR}" ]; then
	echo -e "${COLOR_GREEN}Creating toolchain for platform to ${TOOLCHAIN_DIR}${COLOR_END}"
	$NDK/build/tools/make-standalone-toolchain.sh \
		--platform=android-${ANDROID_API_LEVEL} \
		--toolchain=${PLATFORM}-${TOOLCHAIN_VERSION} \
		--install-dir=${TOOLCHAIN_DIR}
	echo
else
    echo -e "${COLOR_GREEN}Using existing toolchain from ${TOOLCHAIN_DIR}${COLOR_END}"
fi

export ARCH=${ARM_TARGET}
export ROOTDIR=${SRCDIR}
export DROIDTOOLS=${TOOLCHAIN_DIR}/bin/${PLATFORM}
export SYSROOT=${TOOLCHAIN_DIR}/sysroot

export ANDROID_STANDALONE_TOOLCHAIN=${TOOLCHAIN_DIR}
export CMAKE_INSTALL_PREFIX=${PREFIX}
export CMAKE_ANDROID="cmake -DCMAKE_TOOLCHAIN_FILE=$PREFAB/android.toolchain.cmake "

echo "-- Arch            = ${ARCH}"
echo "-- Api             = android-${ANDROID_API_LEVEL}"
echo "-- Sysroot         = ${SYSROOT}"
echo "-- Install prefix  = ${PREFIX}"
echo "-- CMake toolchain = $PREFAB/android.toolchain.cmake"
echo

pushd $SRCDIR
echo

${TOPDIR}/build-bzip2.sh

${TOPDIR}/build-boost.sh

${TOPDIR}/build-ogre.sh

${TOPDIR}/build-bullet.sh

${TOPDIR}/build-qt.sh

${TOPDIR}/build-knet.sh

${TOPDIR}/build-tundra.sh

popd

echo
echo -e "${COLOR_GREEN}Tundra for Android build completed${COLOR_END}"
echo

