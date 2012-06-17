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

echo -e "${COLOR_GREEN}Building boost${COLOR_END}"

BOOST_SOURCE_NAME="boost_1_49_0"
if [ ! -e "${BOOST_SOURCE_NAME}.tar.gz" ] ; then
    # Download source
    echo "-- Downloading sources"
    curl -O "http://surfnet.dl.sourceforge.net/project/boost/boost/1.49.0/${BOOST_SOURCE_NAME}.tar.gz"

    # Extract source
    echo "-- Extracting sources"
    rm -rf "${BOOST_SOURCE_NAME}"
    tar xvf "${BOOST_SOURCE_NAME}.tar.gz"
else
    echo "-- ${BOOST_SOURCE_NAME}.tar.gz already downloaded and extracted, skipping."
fi

pushd "${BOOST_SOURCE_NAME}" >> /dev/null

# Make the initial bootstrap
if [ ! -f ./b2 ] ; then
    echo "-- Performing boost boostrap"
    ./bootstrap.sh
    if [ $? != 0 ] ; then
        echo -e "${COLOR_RED}ERROR: Failed to perform boost bootstrap${COLOR_END}"
	    exit 1
    fi
    
    echo "-- Creating user-config.jam for android arm"
    echo "   ${DROIDTOOLS}-g++"

    rm tools/build/v2/user-config.jam
    cat >> tools/build/v2/user-config.jam <<EOF

using android : arm : ${DROIDTOOLS}-g++ :
<compileflags>-Os
<compileflags>-O2
<compileflags>-g
<compileflags>-std=gnu++0x
<compileflags>-Wno-variadic-macros
<compileflags>-fexceptions
<compileflags>-fpic
<compileflags>-ffunction-sections
<compileflags>-funwind-tables
<compileflags>-march=armv5te
<compileflags>-mtune=xscale
<compileflags>-msoft-float
<compileflags>-mthumb
<compileflags>-fomit-frame-pointer
<compileflags>-fno-strict-aliasing
<compileflags>-finline-limit=64
<compileflags>-D__ARM_ARCH_5__
<compileflags>-D__ARM_ARCH_5T__
<compileflags>-D__ARM_ARCH_5E__
<compileflags>-D__ARM_ARCH_5TE__
<compileflags>-DANDROID
<compileflags>-D__ANDROID__
<compileflags>-DNDEBUG
<compileflags>-I${NDK_ROOT}/platforms/android-14/arch-arm/usr/include
<compileflags>-I${NDK_ROOT}/sources/cxx-stl/gnu-libstdc++/include
<compileflags>-I${NDK_ROOT}/sources/cxx-stl/gnu-libstdc++/libs/armeabi-v7a/include
<compileflags>-I${ROOTDIR}/include
<compileflags>-I${PREFIX}/include
<linkflags>-nostdlib
<linkflags>-lc
<linkflags>-Wl,-rpath-link=${SYSROOT}/usr/lib
<linkflags>-L${SYSROOT}/usr/lib
<linkflags>-L${NDK_ROOT}/sources/cxx-stl/gnu-libstdc++/libs/armeabi-v7a
<linkflags>-L${ROOTDIR}/lib
<linkflags>-L${PREFIX}/lib
# Flags above are for android
<architecture>arm
<compileflags>-fvisibility=hidden
<compileflags>-fvisibility-inlines-hidden
<compileflags>-fdata-sections
<cxxflags>-frtti
<cxxflags>-D__arm__
<cxxflags>-D_REENTRANT
<cxxflags>-D_GLIBCXX__PTHREADS
;
EOF

    echo "-- Creating project-config.jam"
    echo "   install prefix: ${PREFIX}"

    rm project-config.jam
    cat >> project-config.jam <<EOF
libraries = --with-date_time --with-filesystem --with-program_options --with-regex --with-signals --with-system --with-thread --with-iostreams ;

option.set prefix : ${PREFIX} ;
option.set exec-prefix : ${PREFIX}/bin ;
option.set libdir : ${PREFIX}/lib ;
option.set includedir : ${PREFIX}/include ;
EOF

else
    echo "-- Bootstrap already done, skipping."
fi

# Apply patches to boost if not done
PATCHES_DIR=droid-boost-patch
if [ ! -d "$PATCHES_DIR" ] ; then
    echo "-- Extracting patches"
    tar xvf "${PREFAB}/droid-boost-patch.tar.gz"

    PATCHES=`(cd $PATCHES_DIR && find . -name "*.patch" | sort) 2> /dev/null`
    if [ -z "$PATCHES" ] ; then
        echo "No patches files in $PATCHES_DIR"
    else
        PATCHES=`echo $PATCHES | sed -e s%^\./%%g`
        SRC_DIR=${TMPDIR}/${BOOST_SOURCE_NAME}
        for PATCH in $PATCHES; do
	        PATCHDIR=`dirname $PATCH`
	        PATCHNAME=`basename $PATCH`
	        echo "-- Applying $PATCHNAME into $SRC_DIR/$PATCHDIR"
	        patch -p1 < $PATCHES_DIR/$PATCH
	        if [ $? != 0 ] ; then
		        dump "ERROR: Patch failure !! Please check your patches directory! Try to perform a clean build using --clean"
		        exit 1
	        fi
        done
    fi
else
    echo "-- Patches already applied, skipping."
fi

DETECTION_LIB=${PREFIX}/lib/libboost_thread.a
if [ ! -f ${DETECTION_LIB} ] ; then
    ./b2 link=static threading=multi target-os=linux toolset=android-arm --layout=unversioned --without-python --without-mpi --without-locale --disable-filesystem3 define=BOOST_FILESYSTEM_VERSION=2 -d+2 install
else
    echo "-- Already built, remove ${DETECTION_LIB} to trigger a rebuild."
fi

popd >> /dev/null
echo

