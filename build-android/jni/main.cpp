
//BEGIN_INCLUDE(all)

#include <jni.h>
#include <errno.h>

#include <android/sensor.h>
#include <android/log.h>
#include <android_native_app_glue.h>

#include "Framework.h"

#define AndroidLogInfo(...) ((void)__android_log_print(ANDROID_LOG_INFO, "tundra", __VA_ARGS__))
#define AndroidLogWarning(...) ((void)__android_log_print(ANDROID_LOG_WARN, "tundra", __VA_ARGS__))

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
            AndroidLogInfo("APP_CMD_SAVE_STATE");
            break;
        }
        case APP_CMD_INIT_WINDOW:
        {
            AndroidLogInfo("APP_CMD_INIT_WINDOW");
            break;
        }
        case APP_CMD_TERM_WINDOW:
        {
            AndroidLogInfo("APP_CMD_TERM_WINDOW");
            break;
        }
        case APP_CMD_GAINED_FOCUS:
        {
            AndroidLogInfo("APP_CMD_GAINED_FOCUS");
            break;
        }
        case APP_CMD_LOST_FOCUS:
        {
            AndroidLogInfo("APP_CMD_LOST_FOCUS");
            break;
        }
    }
}

/**
 * This is the main entry point of a native application that is using
 * android_native_app_glue.  It runs in its own thread, with its own
 * event loop for receiving input events and doing other things.
 */
void android_main(struct android_app* state) 
{
    struct engine engine;

    // Make sure glue isn't stripped.
    app_dummy();

    AndroidLogInfo("android_main() Start");
    
    memset(&engine, 0, sizeof(engine));
    state->userData = &engine;
    state->onAppCmd = engine_handle_cmd;
    state->onInputEvent = engine_handle_input;

    engine.app = state;
    //engine.framework = new Framework(0, 0);
    
    while (1) 
    {
        // Read all pending events.
        int ident; int events; struct android_poll_source* source;

        // If not animating, we will block forever waiting for events.
        // If animating, we loop until all events are read, then continue
        // to draw the next frame of animation.
        while ((ident = ALooper_pollAll(-1 /*0*/, NULL, &events, (void**)&source)) >= 0)
        {
            // Process this event.
            if (source != NULL)
                source->process(state, source);

            // If a sensor has data, process it now.
            if (ident == LOOPER_ID_USER) 
            {

            }

            if (state->destroyRequested != 0) 
                break;
        }

        // Check if we are exiting.        
        if (state->destroyRequested != 0) 
            break;
        
        // Update framework
    }
    
    //delete engine.framework;
    
    AndroidLogInfo("android_main() Exit");
}

//END_INCLUDE(all)


