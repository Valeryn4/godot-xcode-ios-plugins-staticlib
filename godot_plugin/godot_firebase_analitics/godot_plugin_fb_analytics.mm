
#import <Foundation/Foundation.h>
#import "godot_plugin_fb_analytics.h"
#import "godot_plugin_fb_analytics_class.h"
#import "core/engine.h"

FirebaseAnalytics *fb_analytics_plugin = NULL;

void firebase_analytics_init() {
    fb_analytics_plugin = memnew(FirebaseAnalytics);
    Engine::get_singleton()->add_singleton(Engine::Singleton("TFirebaseAnalytics", fb_analytics_plugin));
}

void firebase_analytics_deinit() {
   if (fb_analytics_plugin) {
       memdelete(fb_analytics_plugin);
   }
}
