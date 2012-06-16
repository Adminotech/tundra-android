
LOCAL_PATH         := $(call my-dir)
DEPS_LIB_PATH      := ../../install/lib
DEPS_INCLUDE_PATH  := ../../install/include

#### Static deps

# Ogre needed?
#include $(CLEAR_VARS)
#LOCAL_MODULE := ogre-main
#LOCAL_SRC_FILES := $(DEPS_LIB_PATH)/libOgreMainStatic.a
#include $(PREBUILT_STATIC_LIBRARY)

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

#### Tundra plugin deps (needed ?)

#include $(CLEAR_VARS)
#LOCAL_MODULE := tundra-ogrerenderingmodule
#LOCAL_SRC_FILES := $(DEPS_LIB_PATH)/OgreRenderingModule.so
#include $(PREBUILT_SHARED_LIBRARY)

#### Tundra static deps

include $(CLEAR_VARS)
LOCAL_MODULE := tundra-framework
LOCAL_SRC_FILES := $(DEPS_LIB_PATH)/Framework.a
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/../../install/include/tundra/Framework
include $(PREBUILT_STATIC_LIBRARY)
   
#### Tundra

include $(CLEAR_VARS)

LOCAL_MODULE      := tundra
LOCAL_SRC_FILES   := main.cpp
LOCAL_C_INCLUDES  := $(LOCAL_PATH)/../../install/include
LOCAL_LDLIBS      := -landroid -llog -lz -lm -ldl -lc -lgcc

LOCAL_STATIC_LIBRARIES := android_native_app_glue tundra-framework
LOCAL_STATIC_LIBRARIES += qt-core qt-gui 
#qt-declarative qt-script qt-scripttools qt-network qt-svg qt-xml qt-xmlpatterns qt-sql 

include $(BUILD_SHARED_LIBRARY)

$(call import-module,android/native_app_glue)


