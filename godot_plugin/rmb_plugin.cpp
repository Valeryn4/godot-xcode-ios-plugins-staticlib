//
//  rmb_plugin.cpp
//  godot_plugin
//
//  Created by Denis Belov on 3/9/22.
//  Copyright © 2022 Godot. All rights reserved.
//

#include "core/engine.h"
#include "godot_firebase_cloudmessage/godot_plugin_fbcloud_class.h"
#include "godot_firebase_analitics/godot_plugin_fb_analytics_class.h"
#include "spotlight/spotlight.h"
#include "inappstore/in_app_store.h"
#include "appsharedialog/app_share_dialog.h"
#include "apple_event/godot_apple_event.h"
#include "apn/apn.h"
#include "rateme/rate_me.h"
#include "gamecenter/game_center.h"


static APNPlugin* plugin_apn = nullptr;
static InAppStore *plugin_in_app_store = nullptr;
static Spotlight *plugin_spotlight = nullptr;
static GodotAppleEvent *plugin_apple_event = nullptr;
static AppShareDialog *plugin_appshare_dialog = nullptr;
static FirebaseAnalytics *plugin_fb_analitics = nullptr;
static FirebaseCloudMessaging *plugin_fb_cloud_msg = nullptr;
static RateMe *plugin_rateme = nullptr;
static GameCenter *plugin_gamecenter = nullptr;

void _add_singelot(const StringName &p_name = StringName(), Object *p_ptr = nullptr)
{
    Engine::get_singleton()->add_singleton(Engine::Singleton(p_name, p_ptr));
}

extern "C" void rmb_plugin_init()
{
    plugin_apn = memnew(APNPlugin);
    _add_singelot("APN", plugin_apn);
    
    plugin_spotlight = memnew(Spotlight);
    _add_singelot("Spotlight", plugin_spotlight);
    
    plugin_apple_event = memnew(GodotAppleEvent);
    _add_singelot("AppleEvent", plugin_apple_event);
    
    plugin_appshare_dialog = memnew(AppShareDialog);
    _add_singelot("AppShareDialog", plugin_appshare_dialog);
    
    plugin_fb_analitics = memnew(FirebaseAnalytics);
    _add_singelot("FirebaseAnalytics", plugin_fb_analitics);
    
    plugin_fb_cloud_msg = memnew(FirebaseCloudMessaging);
    _add_singelot("FirebaseCloudMessaging", plugin_fb_cloud_msg);
    
    plugin_in_app_store = memnew(InAppStore);
    _add_singelot("InAppStore", plugin_in_app_store);
    
    plugin_rateme = memnew(RateMe);
    _add_singelot("RateMe", plugin_rateme);
    
    plugin_gamecenter = memnew(GameCenter);
    _add_singelot("GameCenter", plugin_gamecenter);
    
}

template<typename T>
void _free_singleton(T *ptr)
{
    if (ptr)
        memdelete(ptr);
}

extern "C" void rmb_plugin_deinit()
{
    _free_singleton(plugin_apn);
    _free_singleton(plugin_spotlight);
    _free_singleton(plugin_apple_event);
    _free_singleton(plugin_fb_analitics);
    _free_singleton(plugin_fb_cloud_msg);
    _free_singleton(plugin_appshare_dialog);
    _free_singleton(plugin_in_app_store);
    _free_singleton(plugin_rateme);
    _free_singleton(plugin_gamecenter);
}


