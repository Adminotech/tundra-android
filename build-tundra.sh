
echo -e "${COLOR_GREEN}Building tundra${COLOR_END}"

TUNDRA_SOURCE_DIR=tundra
if [ ! -d ${TUNDRA_SOURCE_DIR} ] ; then
    echo -e "${COLOR_BLUE}-- Cloning repository, this might take a while.${COLOR_END}"
    git clone git://github.com/Adminotech/tundra.git ${TUNDRA_SOURCE_DIR}

    echo -e "${COLOR_BLUE}-- Checking out admino_android branch${COLOR_END}"
    cd ${TUNDRA_SOURCE_DIR}
    git checkout -b admino_android origin/admino_android
    cd ..
    
    echo -e "${COLOR_BLUE}-- Copying prefab CMakeBuildConfigTemplate.txt${COLOR_END}"
    rm ${TUNDRA_SOURCE_DIR}/CMakeBuildConfigTemplate.txt
    cp ${PREFAB}/tundra-CMakeBuildConfigTemplate.txt ${TUNDRA_SOURCE_DIR}/CMakeBuildConfigTemplate.txt
else
    echo -e "${COLOR_BLUE}-- Repository already cloned, skipping.${COLOR_END}"
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


if [ ! -f CMakeCache.txt ] ; then
    echo
    echo -e "-- ${COLOR_BLUE}Running cmake${COLOR_END}"
    ${CMAKE_ANDROID} -DTUNDRA_PLATFORM_ANDROID=TRUE -DTUNDRA_OGRE_STATIC=TRUE -DTUNDRA_NO_EDITORS=TRUE -DTUNDRA_NO_AUDIO=TRUE -DTUNDRA_NO_QTWEBKIT=TRUE .
    
    echo
    echo -e "${COLOR_BLUE}Removing incorrect linker flags '-lrt' and '-lpthread'${COLOR_END}"
    for TARGET_FILENAME in "link.txt" "relink.txt" ; do
        for TARGET in $(find $(pwd)/src -name ${TARGET_FILENAME}) ; do
             echo "  -- $TARGET"
             sed -i 's/-lrt//g' $TARGET
             sed -i 's/-lpthread//g' $TARGET
        done
    done
else
    echo -e "${COLOR_BLUE}-- CMake already done, remove CMakeCache.txt to reconfigure.${COLOR_END}"
fi

echo
echo -e "${COLOR_BLUE}-- Running make${COLOR_END}"
make -j4

popd
echo

