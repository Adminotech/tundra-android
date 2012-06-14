Tundra on Android
=================

This repository aims to provide automated scripts to build [Tundra] and its dependencies for Android with the NDK.

I'm open for pull requests. Send them up my way!

Disclaimer
----------

This is very much work in progress. If you decide to use the scripts here remember that they can change at will. Once we get to building Tundra dependencies might get changed from static to dynamic etc. Additionally if new Android NDK/SDK releases are made this will affect the scripts.

As you might notice from my .sh scripts, I'm no linux expert. Try to cope with them or send pull requests!

What you need to get started
----------------------------

The following are the tools that have been tested/used while developing the scripts. The build OS used is ubuntu 12.04 desktop i386. At this moment I cannot give guarantees for other systems outside of this.

* Android NDK r8 http://developer.android.com/sdk/ndk
* CMake 2.8.x
* Git
* Svn
* Mercurial/Hg

Ubuntu users can run this to get most `sudo apt-get install cmake cmake-data git subversion mercurial`

Details
-------

The scripts use various techniques I've picked up from looking at other repos around and combined them here. Special thanks to the folks maintainig these projects!

* Android Ogre fork that I use from https://bitbucket.org/wolfmanfx/ogre Additionally his prebuilt ogre deps are currently used (this might change later).
* CMake android toolchain from http://code.google.com/p/android-cmake/ `Modified further by me`
* Boost and bzip2 automation from https://github.com/mevansam/cmoss `Modified further by me`

Usage
-----

<pre>
cd tundra-android
./build-all.sh /path/to/ndk
</pre>

Sit back and enjoy, this will take a while. When you are done `install` folder has the build results.


[Tundra]: https://github.com/realXtend/naali/tree/tundra2 "Tundra"
