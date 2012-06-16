
echo -e "${COLOR_GREEN}Building and packaging tundra for android${COLOR_END}"

TUNDRA_ANDROID_SOURCE_DIR=build-android

pushd "${TUNDRA_ANDROID_SOURCE_DIR}"

# Set clean path for only NDK/SDK
PATH_OLD=$PATH
export PATH=${NDK_ROOT}:${SDK_ROOT}/tools:${SDK_ROOT}/platform-tools:$PATH_OLD

echo
echo -e "${COLOR_BLUE}Building${COLOR_END}"
ndk-build -B NDK_DEBUG=0

if [ $? != 0 ] ; then
    echo -e "${COLOR_RED}ERROR: NDK build failed${COLOR_END}"
    exit 1
fi

#echo
#echo -e "${COLOR_BLUE}Packaging${COLOR_END}"
#ant -q debug

#echo
#echo -e "${COLOR_BLUE}Installing to device via adb${COLOR_END}"
#adb install -r bin/Tundra-debug.apk

# Restore old path
export PATH=${PATH_OLD}

popd
echo

