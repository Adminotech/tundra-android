
echo -e "${COLOR_GREEN}Building ogre${COLOR_END}"

OGRE_DIR=ogre
if [ ! -d ${OGRE_DIR} ] ; then
    echo "-- Cloning repository, this might take a while."
    hg clone https://bitbucket.org/wolfmanfx/ogre ${OGRE_DIR}
    
    # NOTE: Remove this ugly hack when the above repo merged 1.8 as its fixed there!
    # This looks ugly as im bad with sed and wanna double check everything, the rm/mv in between are prolly not needed.
    echo "-- Applying sed fixes for missing ';'"
    mv ogre/OgreMain/include/Threading/OgreThreadDefinesBoost.h ogre/OgreMain/include/Threading/OgreThreadDefinesBoost.h.old
    sed 's/#define OGRE_RW_MUTEX(name) mutable boost::shared_mutex name/#define OGRE_RW_MUTEX(name) mutable boost::shared_mutex name;/g' <ogre/OgreMain/include/Threading/OgreThreadDefinesBoost.h.old >ogre/OgreMain/include/Threading/OgreThreadDefinesBoost.h
    rm ogre/OgreMain/include/Threading/OgreThreadDefinesBoost.h.old
    mv ogre/OgreMain/include/Threading/OgreThreadDefinesBoost.h ogre/OgreMain/include/Threading/OgreThreadDefinesBoost.h.old
    sed 's/#define OGRE_LOCK_RW_MUTEX_READ(name) boost::shared_lock<boost::shared_mutex> ogrenameLock(name)/#define OGRE_LOCK_RW_MUTEX_READ(name) boost::shared_lock<boost::shared_mutex> ogrenameLock(name);/g' <ogre/OgreMain/include/Threading/OgreThreadDefinesBoost.h.old >ogre/OgreMain/include/Threading/OgreThreadDefinesBoost.h
    rm ogre/OgreMain/include/Threading/OgreThreadDefinesBoost.h.old
    mv ogre/OgreMain/include/Threading/OgreThreadDefinesBoost.h ogre/OgreMain/include/Threading/OgreThreadDefinesBoost.h.old
    sed 's/#define OGRE_LOCK_RW_MUTEX_WRITE(name) boost::unique_lock<boost::shared_mutex> ogrenameLock(name)/#define OGRE_LOCK_RW_MUTEX_WRITE(name) boost::unique_lock<boost::shared_mutex> ogrenameLock(name);/g' <ogre/OgreMain/include/Threading/OgreThreadDefinesBoost.h.old >ogre/OgreMain/include/Threading/OgreThreadDefinesBoost.h
else
    echo "-- Repository already cloned, skipping."
fi

DETECTION_LIB=${PREFIX}/lib/libOgreMainStatic.a
if [ ! -f ${DETECTION_LIB} ] ; then
    pushd "${OGRE_DIR}"

    mkdir -p build-android
    cd build-android

    ${CMAKE_ANDROID} -DOGRE_STATIC=TRUE -DOGRE_DEPENDENCIES_DIR=${PREBUILT} \
        -DTargetPlatform="Android" -DANDROID_NATIVE_API_LEVEL=14 \
        -DOGRE_BUILD_RENDERSYSTEM_GLES2=TRUE DOGRE_BUILD_COMPONENT_RTSHADERSYSTEM=TRUE -DOGRE_BUILD_TOOLS=TRUE\
        -DOGRE_BUILD_COMPONENT_PAGING=FALSE -DOGRE_BUILD_COMPONENT_TERRAIN=FALSE - -DOGRE_BUILD_PLUGIN_BSP=FALSE -DOGRE_BUILD_PLUGIN_PCZ=FALSE \
        -DOGRE_BUILD_RENDERSYSTEM_GLES=FALSE -DOGRE_BUILD_TESTS=FALSE -DOGRE_BUILD_SAMPLES=FALSE ..

    make -j4
    make install

    popd
else
    echo "-- Already built, remove ${DETECTION_LIB} to trigger a rebuild."
fi

echo

