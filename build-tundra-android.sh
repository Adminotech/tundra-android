
echo -e "${COLOR_GREEN}Building and packaging tundra for android${COLOR_END}"

TUNDRA_ANDROID_SOURCE_DIR=build-android

pushd "${TUNDRA_ANDROID_SOURCE_DIR}" >> /dev/null

# Set clean path for only NDK/SDK
PATH_OLD=$PATH
export PATH=${NDK_ROOT}:${SDK_ROOT}/tools:${SDK_ROOT}/platform-tools:$PATH_OLD

echo
echo -e "${COLOR_BLUE}Building${COLOR_END}"
ndk-build -B NDK_DEBUG=1

if [ $? != 0 ] ; then
    echo -e "${COLOR_RED}ERROR: NDK build failed${COLOR_END}"
    exit 1
fi

if [ ! -f local.properties ] ; then
    echo
    echo -e "${COLOR_BLUE}Updating projects local.properties${COLOR_END}"
    android update project -p ./
fi

echo
echo -e "${COLOR_BLUE}Packaging${COLOR_END}"
ant debug

echo
echo -e "${COLOR_BLUE}Uninstalling org.realxtend.tundra from active device/emulator${COLOR_END}"
adb uninstall org.realxtend.tundra # Explicit uninstall as 'adb install -r' won't update the assets?

echo
echo -e "${COLOR_BLUE}Installing to active device/emulator via adb${COLOR_END}"
adb install bin/Tundra-debug.apk

# Restore old path
export PATH=${PATH_OLD}

popd >> /dev/null
echo

