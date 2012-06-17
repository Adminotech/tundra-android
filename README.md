Tundra on Android
=================

This repository aims to provide automated scripts to build [Tundra] and its dependencies for Android with the NDK.

I'm open for pull requests. Send them up my way!

What you need to get started
----------------------------

The following are the tools that have been tested/used while developing the scripts. The build OS used is ubuntu 12.04 desktop i386. At this moment I cannot give guarantees for other systems outside of this.

* **NDK:** Android NDK r8 http://developer.android.com/sdk/ndk
* **SDK:** Android SDK r18 http://developer.android.com/sdk
* **ADT:** Android ADT r19/r20preview http://tools.android.com/download
* **Build systems:** cmake (2.8.x)
* **DVCS:** git, svn, mercurial
* **Utils:** curl, wget, g++, 7za

<pre>
# Ubuntu users can run the following for everything except Android tools
sudo apt-get install cmake cmake-data git subversion mercurial curl wget g++ p7zip-full
</pre>

What you will get
-----------------

* Boost 1.49.0
* Bzip2 1.0.6 (for boost)
* Ogre 1.8.0 unstable
* Bullet 2.78
* kNet stable branch
* Necessitas Qt 4.8.0
* Tundra
* Tundra for Android apk package

As a bonus you get a prepared standalone NDK toolchain for your target arch (default armv7a) and CMake NDK toolchain script that can be used to easily build cmake based c/c++ projects.

_**Note:** Necessitas Qt does not build properly with the r8 or r7 NDK. Necessitas provided r6b is used instead. It is an open issue if this will affect the packaged Tundra app. We will cross that bridge when we get there._

_**Note:** Currently prebuilt ogre deps are used from wolfmanfx. This will change in the future._

Usage
-----

<pre>
cd tundra-android
./build-all.sh OPTIONS

Options:
  -n,  --ndk <i>path</i>      Android NDK root path
  -s,  --sdk <i>path</i>      Android SDK root path

  -od, --only-deps     Only build dependencies
  -ot, --only-tundra   Only build Tundra
  -oa, --only-android  Only build/package/install Tundra for Android 

  -sd, --skip-deps     Skip Tundra dependencies
  -st, --skip-tundra   Skip Tundra
  -sa, --skip-android  Skip Tundra for Android build/package/install

  -h, --help           Print this help

Note: Params cannot be combined (eg. -odh).
</pre>

Sit back and enjoy, this will take a while. When you are done `install` folder has the deps and tundra build results. `build-android/bin` and `build-android/libs` will have the Android build results.

_**Note:** Do not run any of the other build-*.sh scripts directly, they wont work like that. The main script will call all of them in the correct order. The individual scripts have checks so that nothing is downloaded/cloned/built/installed unnessesarily multiple times. Only tundras make will be ran every time. The script will give info what files you need to remove to trigger rebuilds._

Implementation Details
----------------------

The scripts use various techniques I've picked up from looking at other repos around and combined them here. Special thanks to the folks maintainig these projects!

* Android Ogre fork that I use from https://bitbucket.org/wolfmanfx/ogre Additionally his prebuilt ogre deps are currently used (this might change later).
* CMake android toolchain from http://code.google.com/p/android-cmake/ `Modified further by me`
* Boost and bzip2 automation from https://github.com/mevansam/cmoss `Modified further by me`

[Tundra]: https://github.com/realXtend/naali/tree/tundra2 "Tundra"
