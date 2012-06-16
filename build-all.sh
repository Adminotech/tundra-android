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

# Additional script implementation by Jonne Nauha

print_help()
{
cat << EOF
Usage: $0 OPTIONS

Options:
  --ndk        Android NDK root path
  --sdk        Android SDK root path
  --help, -h   Print this help

EOF
}

INPUT_NDK=""
INPUT_SDK=""

while [[ $1 = -* ]]; do
    arg=$1; 
    shift

    case $arg in
        --ndk)
            INPUT_NDK="$1"
            shift
            ;;
        --sdk)
            INPUT_SDK="$1"
            shift
            ;;
        --help|-h)
            print_help
            exit 0
            ;;
    esac
done

if [ "${INPUT_NDK}" == "" ] || [ ! -e ${INPUT_NDK}/build/tools/make-standalone-toolchain.sh ]; then
	print_help
	exit 0
fi
if [ "${INPUT_SDK}" == "" ] || [ ! -e ${INPUT_SDK}/tools/android ]; then
	print_help
	exit 0
fi

export NDK_ROOT="${INPUT_NDK}"
export SDK_ROOT="${INPUT_SDK}"

BUILDDIR=$(pwd)

# Toolchain defines
export ANDROID_API_LEVEL="14"
export ARM_TARGET="armv7"
export TOOLCHAIN_VERSION="4.4.3"
export PLATFORM="arm-linux-androideabi"

# Dir structure
export TOPDIR=$BUILDDIR
export PREFIX=$BUILDDIR/install
export PREFAB=$BUILDDIR/prefab
export PREBUILT=$BUILDDIR/prebuilt
export SRCDIR=$BUILDDIR/src
export TOOLCHAIN_DIR=$BUILDDIR/toolchain

# Color print helpers
export COLOR_GREEN="\e[1;32m"
export COLOR_BLUE="\e[1;34m"
export COLOR_RED="\e[1;31m"
export COLOR_END="\e[00m"

# Create working dirctories
mkdir -p ${PREFIX}
mkdir -p ${SRCDIR}

echo
if [ ! -d "${TOOLCHAIN_DIR}" ]; then
	echo -e "${COLOR_GREEN}Creating toolchain for platform to ${TOOLCHAIN_DIR}${COLOR_END}"
	$NDK_ROOT/build/tools/make-standalone-toolchain.sh \
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

echo "-- Architecture    = ${ARCH}"
echo "-- SDK API level   = android-${ANDROID_API_LEVEL}"
echo "-- Android NDK     = ${NDK_ROOT}"
echo "-- Android SDK     = ${SDK_ROOT}"
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

${TOPDIR}/build-knet.sh

${TOPDIR}/build-qt.sh

${TOPDIR}/build-tundra.sh

popd
echo

${TOPDIR}/build-tundra-android.sh

echo
echo -e "${COLOR_GREEN}Tundra for Android build completed${COLOR_END}"
echo

