
echo -e "${COLOR_GREEN}Building tundra${COLOR_END}"

TUNDRA_SOURCE_DIR=tundra
if [ ! -d ${TUNDRA_SOURCE_DIR} ] ; then
    echo "-- Cloning repository, this might take a while."
    git clone git://github.com/Adminotech/tundra.git ${TUNDRA_SOURCE_DIR}

    echo "-- Checking out admino_android branch"
    cd ${TUNDRA_SOURCE_DIR}
    git checkout -b admino_android origin/admino_android
    cd ..
    
    echo "-- Copying prefab CMakeBuildConfigTemplate.txt"
    rm ${TUNDRA_SOURCE_DIR}/CMakeBuildConfigTemplate.txt
    cp ${PREFAB}/tundra-CMakeBuildConfigTemplate.txt ${TUNDRA_SOURCE_DIR}/CMakeBuildConfigTemplate.txt
else
    echo "-- Repository already cloned, skipping."
fi

pushd "${TUNDRA_SOURCE_DIR}"

export TUNDRA_DEP_PATH=${PREFIX}
export QTDIR=${PREFIX}
export QMAKESPEC="android-g++"
export BOOST_ROOT=${PREFIX}
export KNET_DIR=${PREFIX}
export BULLET_DIR=${PREFIX}
export OGRE_HOME=${PREFIX}
export TUNDRA_PYTHON_ENABLED="FALSE"

echo "-- Running cmake"
${CMAKE_ANDROID} -DTUNDRA_PLATFORM_ANDROID=TRUE -DTUNDRA_OGRE_STATIC=TRUE -DTUNDRA_NO_EDITORS=TRUE -DTUNDRA_NO_AUDIO=TRUE .

make

popd
echo

