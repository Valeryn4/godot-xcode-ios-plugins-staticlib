
#include "godot_apple_event.h"


GodotAppleEvent *GodotAppleEvent::instance = NULL;
GodotAppleEvent *GodotAppleEvent::get_singleton() {
	return instance;
}

GodotAppleEvent::GodotAppleEvent() {
	ERR_FAIL_COND(instance != NULL);
	instance = this;
}

GodotAppleEvent::~GodotAppleEvent() {}

void GodotAppleEvent::_bind_methods() {
	ADD_SIGNAL(MethodInfo("event_open_url", PropertyInfo(Variant::STRING, "url")));
}

void GodotAppleEvent::open_url(String url) {
	emit_signal("event_open_url", url);
}
