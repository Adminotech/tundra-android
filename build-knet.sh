
echo -e "${COLOR_GREEN}Building knet${COLOR_END}"

KNET_SOURCE_DIR=knet
if [ ! -d ${KNET_SOURCE_DIR} ] ; then
    echo "-- Cloning repository, this might take a while."
    git clone git://github.com/juj/kNet.git ${KNET_SOURCE_DIR}
else
    echo "-- Repository already cloned, skipping."
fi

DETECTION_LIB=${PREFIX}/lib/libkNet.a
if [ ! -f ${DETECTION_LIB} ] ; then
    pushd "${KNET_SOURCE_DIR}"
    
    export BOOST_ROOT=${PREFIX}

    mkdir -p build-android
    cd build-android

    ${CMAKE_ANDROID} ..

    make -j4

    # Manual install, no make install for knet
    echo "-- Installing libs and headers to ${PREFIX}"
    cd ..
    cp -u lib/libkNet.a ${PREFIX}/lib/
    cp -u -r include/* ${PREFIX}/include/
    
    popd >> /dev/null
else
    echo "-- Already built, remove ${DETECTION_LIB} to trigger a rebuild."
fi

echo

