
LOCAL_PATH         := $(call my-dir)
DEPS_LIB_PATH      := ../../install/lib
DEPS_INCLUDE_PATH  := ../../install/include

#### Ogre

include $(CLEAR_VARS)
LOCAL_MODULE := ogre-main
LOCAL_SRC_FILES := $(DEPS_LIB_PATH)/libOgreMainStatic.a
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/../../install/include/OGRE
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := ogre-scenemanager
LOCAL_SRC_FILES := $(DEPS_LIB_PATH)/OGRE/libPlugin_OctreeSceneManagerStatic.a
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := ogre-particlefx
LOCAL_SRC_FILES := $(DEPS_LIB_PATH)/OGRE/libPlugin_ParticleFXStatic.a
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := ogre-gles2
LOCAL_SRC_FILES := $(DEPS_LIB_PATH)/OGRE/libRenderSystem_GLES2Static.a
include $(PREBUILT_STATIC_LIBRARY)

#### Qt

include $(CLEAR_VARS)
LOCAL_MODULE := qt-core
LOCAL_SRC_FILES := $(DEPS_LIB_PATH)/libQtCore.a
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/../../install/include/Qt $(LOCAL_PATH)/../../install/include/QtCore
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := qt-gui
LOCAL_SRC_FILES := $(DEPS_LIB_PATH)/libQtGui.a
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/../../install/include/QtGui
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := qt-declarative
LOCAL_SRC_FILES := $(DEPS_LIB_PATH)/libQtDeclarative.a
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/../../install/include/QtDeclarative
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := qt-script
LOCAL_SRC_FILES := $(DEPS_LIB_PATH)/libQtScript.a
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/../../install/include/QtScript
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := qt-scripttools
LOCAL_SRC_FILES := $(DEPS_LIB_PATH)/libQtScriptTools.a
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/../../install/include/QtScriptTools
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := qt-network
LOCAL_SRC_FILES := $(DEPS_LIB_PATH)/libQtNetwork.a
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/../../install/include/QtNetwork
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := qt-svg
LOCAL_SRC_FILES := $(DEPS_LIB_PATH)/libQtSvg.a
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/../../install/include/QtSvg
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := qt-xml
LOCAL_SRC_FILES := $(DEPS_LIB_PATH)/libQtXml.a
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/../../install/include/QtXml
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := qt-xmlpatterns
LOCAL_SRC_FILES := $(DEPS_LIB_PATH)/libQtXmlPatterns.a
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/../../install/include/QtXmlPatterns
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := qt-sql
LOCAL_SRC_FILES := $(DEPS_LIB_PATH)/libQtSql.a
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/../../install/include/QtSql
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := qt-uitools
LOCAL_SRC_FILES := $(DEPS_LIB_PATH)/libQtUiTools.a
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/../../install/include/QtUiTools
include $(PREBUILT_STATIC_LIBRARY)

#### Boost

include $(CLEAR_VARS)
LOCAL_MODULE := boost-thread
LOCAL_SRC_FILES := $(DEPS_LIB_PATH)/libboost_thread.a
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := boost-regex
LOCAL_SRC_FILES := $(DEPS_LIB_PATH)/libboost_regex.a
include $(PREBUILT_STATIC_LIBRARY)

#### kNet

include $(CLEAR_VARS)
LOCAL_MODULE := knet
LOCAL_SRC_FILES := $(DEPS_LIB_PATH)/libkNet.a
include $(PREBUILT_STATIC_LIBRARY)

#### Tundra framework

include $(CLEAR_VARS)
LOCAL_MODULE := tundra-framework
LOCAL_SRC_FILES := $(DEPS_LIB_PATH)/Framework.a
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/../../install/include/tundra $(LOCAL_PATH)/../../install/include/tundra/Framework
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := tundra-math
LOCAL_SRC_FILES := $(DEPS_LIB_PATH)/Math.a
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/../../install/include/tundra/Math
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := tundra-sceneapi
LOCAL_SRC_FILES := $(DEPS_LIB_PATH)/Scene.a
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/../../install/include/tundra/Scene
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := tundra-assetapi
LOCAL_SRC_FILES := $(DEPS_LIB_PATH)/Asset.a
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/../../install/include/tundra/Asset
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := tundra-uiapi
LOCAL_SRC_FILES := $(DEPS_LIB_PATH)/Ui.a
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/../../install/include/tundra/Ui
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := tundra-audioapi
LOCAL_SRC_FILES := $(DEPS_LIB_PATH)/Audio.a
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/../../install/include/tundra/Audio
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := tundra-inputapi
LOCAL_SRC_FILES := $(DEPS_LIB_PATH)/Input.a
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/../../install/include/tundra/Input
include $(PREBUILT_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := tundra-consoleapi
LOCAL_SRC_FILES := $(DEPS_LIB_PATH)/Console.a
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/../../install/include/tundra/Console
include $(PREBUILT_STATIC_LIBRARY)

#### Tundra

include $(CLEAR_VARS)

LOCAL_MODULE       := tundra
LOCAL_SRC_FILES    := main.cpp
LOCAL_LDLIBS       := -landroid -llog -lz -lm -ldl -lc -lgcc

LOCAL_CPP_FEATURES := rtti exceptions
LOCAL_C_INCLUDES   := $(LOCAL_PATH)/../../install/include
LOCAL_CFLAGS       := $(LOCAL_CFLAGS) -DANDROID -DMATH_TUNDRA_INTEROP -DMATH_ENABLE_STL_SUPPORT -DMATH_TUNDRA_INTEROP
LOCAL_CFLAGS       += -DQT_DECLARATIVE_LIB -DQT_SCRIPT_LIB -DQT_UITOOLS_LIB -DQT_SCRIPTTOOLS_LIB -DQT_GUI_LIB -DQT_XML_LIB -DQT_NETWORK_LIB -DQT_CORE_LIB

LOCAL_STATIC_LIBRARIES := android_native_app_glue tundra-framework 
LOCAL_STATIC_LIBRARIES += tundra-assetapi tundra-uiapi tundra-audioapi tundra-inputapi tundra-consoleapi tundra-sceneapi tundra-math  knet
LOCAL_STATIC_LIBRARIES += boost-thread boost-regex 
LOCAL_STATIC_LIBRARIES += ogre-main ogre-scenemanager ogre-particlefx ogre-gles2
LOCAL_STATIC_LIBRARIES += qt-declarative qt-script qt-scripttools qt-network qt-svg qt-xml qt-xmlpatterns qt-sql qt-uitools qt-gui qt-core

include $(BUILD_SHARED_LIBRARY)

$(call import-module,android/native_app_glue)


