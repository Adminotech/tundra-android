
//BEGIN_INCLUDE(all)

#include <jni.h>
#include <errno.h>

#include <android/sensor.h>
#include <android/log.h>
#include <android_native_app_glue.h>

#include "Framework.h"
#include "Application.h"
#include "CoreStringUtils.h"
#include "QtUtils.h"
#include "Color.h"
#include "Transform.h"

#include "AssetAPI.h"
#include "ConsoleAPI.h"
#include "SceneAPI.h"
#include "InputAPI.h"
#include "UiAPI.h"

#include <QVariant>
#include <QVariantList>
#include <QList>
#include <QStringList>
#include <QByteArray>
#include <QVarLengthArray>
#include <QDir>
#include <QFile>

#include "FunctionInvoker.h"
#include "LoggingFunctions.h"

struct engine 
{
    struct android_app* app;
    Framework *framework;
};

// Process the next input event.
static int32_t engine_handle_input(struct android_app* app, AInputEvent* event)
{
    /*
    struct engine* engine = (struct engine*)app->userData;
    if (AInputEvent_getType(event) == AINPUT_EVENT_TYPE_MOTION) {
        engine->animating = 1;
        engine->state.x = AMotionEvent_getX(event, 0);
        engine->state.y = AMotionEvent_getY(event, 0);
        return 1;
    }
    */
    return 0;
}

// Process the next main command.
static void engine_handle_cmd(struct android_app* app, int32_t cmd) 
{
    struct engine* engine = (struct engine*)app->userData;
    
    switch (cmd) 
    {
        case APP_CMD_SAVE_STATE:
        {
            LogInfo("APP_CMD_SAVE_STATE");
            break;
        }
        case APP_CMD_INIT_WINDOW:
        {
            LogInfo("APP_CMD_INIT_WINDOW");
            break;
        }
        case APP_CMD_TERM_WINDOW:
        {
            LogInfo("APP_CMD_TERM_WINDOW");
            break;
        }
        case APP_CMD_GAINED_FOCUS:
        {
            LogInfo("APP_CMD_GAINED_FOCUS");
            break;
        }
        case APP_CMD_LOST_FOCUS:
        {
            LogInfo("APP_CMD_LOST_FOCUS");
            break;
        }
        case APP_CMD_START:
        {
            LogInfo("APP_CMD_START");
            break;
        }
        case APP_CMD_RESUME:
        {
            LogInfo("APP_CMD_RESUME");
            break;
        }
        case APP_CMD_DESTROY:
        {
            LogInfo("APP_CMD_DESTROY");
            break;
        }
    }
}

/** The NDK strips static libraries very aggressively
    to save disk etc. on the mobile devices.
    This leads it stripping some parts away that are
    actually needed in the linking step. This  can be
    avoided by calling these functions to 'mark' them
    down, so they wont get stripped.
    
    This looks like a hack, and it is. But it seems to
    be common practive here as Android shipped 
    android_native_app_glue also uses this same trick. 
*/
void tundra_dummy(Framework *framework)
{
    // android_native_app_glue
    app_dummy();
       
    // Static framework functions
    ParseBool(QString(""));
    DirectorySearch("./",false, QDir::Files);

    // Framework classes/functions
    Color c; c.SerializeToString();
    Transform t; t.SerializeToString();
        
    AssetAPI::RecursiveFindFile("./", "");
    FunctionInvoker::NumArgsForFunction(framework, "dummy_function()");
}

/** This is the main entry point of a native application that is using
    android_native_app_glue.  It runs in its own thread, with its own
    event loop for receiving input events and doing other things. 
*/
void android_main(struct android_app* state) 
{
    struct engine engine;

    LogInfo("Initializing native activity.");

    memset(&engine, 0, sizeof(engine));
    state->userData = &engine;
    state->onAppCmd = engine_handle_cmd;
    state->onInputEvent = engine_handle_input;
    engine.app = state;
    
    QString configFile;
    
    // List data files
    QDir dataDir(engine.app->activity->internalDataPath);
    LogInfo("Data files in " + dataDir.absolutePath());
    foreach(QString filePath, DirectorySearch(dataDir.absolutePath(), true, QDir::Files))
    {
        if (filePath.endsWith("viewer-android.xml"))
            configFile = filePath;
        LogInfo("-- " + filePath);
    }
    
    // Framework expects first param to be the executable name.
    QList<QByteArray> args;
    args << "tundra"
         << "--headless"
         << "--debuglevel" << "debug";
    
    // Find config file and pass it
    if (!configFile.isEmpty())
        args << "--config" << configFile.toAscii();
    else
        LogError("Config file not found from data path!");

    /// Convert the arguments into a proper form
    QVarLengthArray<char*, 64> tundraArgs(args.size());
    for (int i = 0; i < args.size(); ++i)
        tundraArgs[i] = args[i].data();

    engine.framework = new Framework(tundraArgs.size(), tundraArgs.data());
    tundra_dummy(engine.framework);
    
    engine.framework->Go();
    
    LogInfo("Deleting Framework.");
    delete engine.framework;
    
    LogInfo("Exiting native activity.");
}

//END_INCLUDE(all)

