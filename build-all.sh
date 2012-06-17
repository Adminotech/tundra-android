#!/bin/bash
set -e

print_help()
{
cat << EOF
Usage: $0 OPTIONS

Options:
  -n,  --ndk <path>    Android NDK root path
  -s,  --sdk <path>    Android SDK root path

  -od, --only-deps     Only build dependencies
  -ot, --only-tundra   Only build Tundra
  -oa, --only-android  Only build/package/install Tundra for Android 

  -sd, --skip-deps     Skip Tundra dependencies
  -st, --skip-tundra   Skip Tundra
  -sa, --skip-android  Skip Tundra for Android build/package/install

  -h, --help           Print this help

Note: Params cannot be combined (eg. -odh).

EOF
}

# Color print helpers
export COLOR_GREEN="\e[1;32m"
export COLOR_BLUE="\e[1;34m"
export COLOR_RED="\e[1;31m"
export COLOR_END="\e[00m"

# Input params
INPUT_NDK=""
INPUT_SDK=""
INPUT_SKIP_DEPS="FALSE"
INPUT_ONLY_DEPS="FALSE"
INPUT_SKIP_TUNDRA="FALSE"
INPUT_ONLY_TUNDRA="FALSE"
INPUT_SKIP_ANDROID="FALSE"
INPUT_ONLY_ANDROID="FALSE"

# Parse command line args
while [[ $1 = -* ]]; do
    arg=$1; 
    shift

    case $arg in
        --ndk|-n)
            INPUT_NDK="$1"
            shift
            ;;
        --sdk|-s)
            INPUT_SDK="$1"
            shift
            ;;
        --skip-deps|-sd)
            INPUT_SKIP_DEPS="TRUE"
            ;;
        --skip-tundra|-st)
            INPUT_SKIP_TUNDRA="TRUE"
            ;;
        --skip-android|-sa)
            INPUT_SKIP_ANDROID="TRUE"
            ;;
        --only-deps|-od)
            if [ "${INPUT_ONLY_TUNDRA}" == "TRUE" ] || [ "${INPUT_ONLY_ANDROID}" == "TRUE" ] ; then
                echo -e "${COLOR_RED}Error: Passing multiple --only-<step> parameters is not allowed!${COLOR_END}"
                exit 1
            fi
            INPUT_ONLY_DEPS="TRUE"
            ;;
        --only-tundra|-ot)
            if [ "${INPUT_ONLY_DEPS}" == "TRUE" ] || [ "${INPUT_ONLY_ANDROID}" == "TRUE" ] ; then
                echo -e "${COLOR_RED}Error: Passing multiple --only-<step> parameters is not allowed!${COLOR_END}"
                exit 1
            fi
            INPUT_ONLY_TUNDRA="TRUE"
            ;;
        --only-android|-oa)
            if [ "${INPUT_ONLY_DEPS}" == "TRUE" ] || [ "${INPUT_ONLY_TUNDRA}" == "TRUE" ] ; then
                echo -e "${COLOR_RED}Error: Passing multiple --only-<step> parameters is not allowed!${COLOR_END}"
                exit 1
            fi
            INPUT_ONLY_ANDROID="TRUE"
            ;;
        --help|-h)
            print_help
            exit 0
            ;;
    esac
done

if [ "${INPUT_NDK}" == "" ] || [ ! -e ${INPUT_NDK}/build/tools/make-standalone-toolchain.sh ] ; then
    echo -e "${COLOR_RED}Error: --ndk not passed or invalid. See $0 --help${COLOR_END}"
	exit 1
fi
if [ "${INPUT_SDK}" == "" ] || [ ! -e ${INPUT_SDK}/tools/android ] ; then
    echo -e "${COLOR_RED}Error: --sdk not passed or invalid. See $0 --help${COLOR_END}"
	exit 1
fi
if [ "${INPUT_ONLY_DEPS}" == "TRUE" ] ; then
    INPUT_SKIP_DEPS="FALSE"    
    INPUT_SKIP_TUNDRA="TRUE"
    INPUT_SKIP_ANDROID="TRUE"
fi
if [ "${INPUT_ONLY_TUNDRA}" == "TRUE" ] ; then
    INPUT_SKIP_DEPS="TRUE"    
    INPUT_SKIP_TUNDRA="FALSE"
    INPUT_SKIP_ANDROID="TRUE"
fi
if [ "${INPUT_ONLY_ANDROID}" == "TRUE" ] ; then
    INPUT_SKIP_DEPS="TRUE"    
    INPUT_SKIP_TUNDRA="TRUE"
    INPUT_SKIP_ANDROID="FALSE"
fi

# Set root paths
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

pushd $SRCDIR >> /dev/null

if [ "${INPUT_SKIP_DEPS}" == "FALSE" ] ; then
    ${TOPDIR}/build-bzip2.sh
    ${TOPDIR}/build-boost.sh
    ${TOPDIR}/build-ogre.sh
    ${TOPDIR}/build-bullet.sh
    ${TOPDIR}/build-knet.sh
    ${TOPDIR}/build-qt.sh
else
    echo -e "${COLOR_BLUE}Skipping Tundra dependecies build by request${COLOR_END}"
fi

if [ "${INPUT_SKIP_TUNDRA}" == "FALSE" ] ; then
    ${TOPDIR}/build-tundra.sh
else
    echo -e "${COLOR_BLUE}Skipping Tundra build by request${COLOR_END}"
fi

popd >> /dev/null

if [ "${INPUT_SKIP_ANDROID}" == "FALSE" ] ; then
    ${TOPDIR}/build-tundra-android.sh
else
    echo -e "${COLOR_BLUE}Skipping Tundra for Android build by request${COLOR_END}"
fi

echo
echo -e "${COLOR_GREEN}Tundra for Android build completed${COLOR_END}"
echo

