
echo "Building bullet"

BULLET_DIR=bullet
if [ ! -d ${BULLET_DIR} ] ; then
    echo "-- Cloning repository, this might take a while."
    svn checkout http://bullet.googlecode.com/svn/tags/bullet-2.78 ${BULLET_DIR}
else
    echo "-- Repository already cloned, skipping."
fi

pushd "${BULLET_DIR}"

mkdir -p build-android
cd build-android

${CMAKE_ANDROID} -DBUILD_DEMOS=OFF -DBUILD_EXTRAS=OFF -DBUILD_UNIT_TESTS=OFF -DINSTALL_LIBS=ON -DCMAKE_INSTALL_PREFIX=${PREFIX} ..

make -j4
make install

echo
popd

