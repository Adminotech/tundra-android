#!/bin/bash
set -e

# Copyright (c) 2010, Pierre-Olivier Latour
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * The name of Pierre-Olivier Latour may not be used to endorse or
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

echo -e "${COLOR_GREEN}Building bzip2${COLOR_END}"

# Download source
if [ ! -e "bzip2-1.0.6.tar.gz" ] ; then
    curl -O "http://bzip.org/1.0.6/bzip2-1.0.6.tar.gz"

    # Extract source
    rm -rf "bzip2-1.0.6"
    tar xvf "bzip2-1.0.6.tar.gz"
    cp ${PREFAB}/Makefile.bzip2 bzip2-1.0.6/Makefile
else
    echo "-- Already downloaded sources, skipping."
fi

# Build
DETECTION_LIB=${PREFIX}/lib/libbz2.a
if [ ! -f ${DETECTION_LIB} ] ; then
    pushd "bzip2-1.0.6"
    BIGFILES=-D_FILE_OFFSET_BITS=64
    export CC=${DROIDTOOLS}-gcc
    export LD=${DROIDTOOLS}-ld
    export CPP=${DROIDTOOLS}-cpp
    export CXX=${DROIDTOOLS}-g++
    export AR=${DROIDTOOLS}-ar
    export AS=${DROIDTOOLS}-as
    export NM=${DROIDTOOLS}-nm
    export STRIP=${DROIDTOOLS}-strip
    export CXXCPP=${DROIDTOOLS}-cpp
    export RANLIB=${DROIDTOOLS}-ranlib
    export LDFLAGS="-Os -fpic -Wl,-rpath-link=${SYSROOT}/usr/lib -L${SYSROOT}/usr/lib -L${ROOTDIR}/lib"
    export CFLAGS="-Os -D_FILE_OFFSET_BITS=64 -pipe -isysroot ${SYSROOT} -I${ROOTDIR}/include -g ${BIGFILES}"
    export CXXFLAGS="-Os -D_FILE_OFFSET_BITS=64 -pipe -isysroot ${SYSROOT} -I${ROOTDIR}/include"

    make CC="${CC}" AR="${AR}" RANLIB="${RANLIB}" CFLAGS="${CFLAGS}"
    make install PREFIX=${PREFIX}  # Ignore errors due to share libraries missing

    popd >> /dev/null
else
    echo "-- Already built, remove ${DETECTION_LIB} to trigger a rebuild."
fi

echo

