echo "Building qt"

QT_SOURCE_DIR=qt
if [ ! -d ${QT_SOURCE_DIR} ] ; then
    echo "-- Cloning repository, this might take a while."
    git clone git://anongit.kde.org/android-qt.git ${QT_SOURCE_DIR}
else
    echo "-- Repository already cloned, skipping."
fi

pushd "${QT_SOURCE_DIR}"

QT_CONF_ARG="0"
if [ ! -f android/tundra.qt.configured ] ; then
    echo "done" >> android/tundra.qt.configured
    QT_CONF_ARG="1"
else
    echo "-- Qt already configured, only building and installing."
    echo "   If you want to retrigged configure remove"
    echo "   $(pwd)/android/tundra.qt.configured"
fi

QT_BUILD_STATIC="0"
QT_BUILD_SHARED="1"

QT_CPU_ARCH="armeabi"
if [ "${ARCH}" == "armv7" ] ; then
    QT_CPU_ARCH="armeabi-v7a"
fi

# Only build qt if not installed. This will go to a infinite loop if already built due to the android-qt script implementation!
if [ ! -d "${PREFIX}/include/Qt" ] ; then
    ./android/androidconfigbuild.sh -q "${QT_CONF_ARG}" -h "${QT_BUILD_STATIC}" -n "${SDK}" -f "${PLATFORM}" -v "${TOOLCHAIN_VERSION}" -a "${QT_CPU_ARCH}" -i "${PREFIX}" -l "${ANDROID_API_LEVEL}" -w 1 -b 1 -k 1
else
    echo "-- Already built, skipping due to android-qt script infinite loop (!)"
    echo "   To retrigged build: cd src/qt/ && git clean -fdx && git checkout ./"
fi

popd
echo
