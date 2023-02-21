/*************************************************************************/
/*  godot_apn_delegate.mm                                                */
/*************************************************************************/
/*                       This file is part of:                           */
/*                           GODOT ENGINE                                */
/*                      https://godotengine.org                          */
/*************************************************************************/
/* Copyright (c) 2007-2022 Juan Linietsky, Ariel Manzur.                 */
/* Copyright (c) 2014-2022 Godot Engine contributors (cf. AUTHORS.md).   */
/*                                                                       */
/* Permission is hereby granted, free of charge, to any person obtaining */
/* a copy of this software and associated documentation files (the       */
/* "Software"), to deal in the Software without restriction, including   */
/* without limitation the rights to use, copy, modify, merge, publish,   */
/* distribute, sublicense, and/or sell copies of the Software, and to    */
/* permit persons to whom the Software is furnished to do so, subject to */
/* the following conditions:                                             */
/*                                                                       */
/* The above copyright notice and this permission notice shall be        */
/* included in all copies or substantial portions of the Software.       */
/*                                                                       */
/* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,       */
/* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF    */
/* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.*/
/* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY  */
/* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,  */
/* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE     */
/* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                */
/*************************************************************************/

#import "godot_apple_event_delegate.h"
#import "godot_apple_event.h"

#import "platform/iphone/godot_app_delegate.h"

struct AppleEventInitializer {

	AppleEventInitializer() {
		[GodotApplicalitionDelegate addService:[GodotAppleEventDelegate shared]];
	}
};
static AppleEventInitializer initializer;

@interface GodotAppleEventDelegate ()

@end

@implementation GodotAppleEventDelegate

- (instancetype)init {
	self = [super init];
	return self;
}

+ (instancetype)shared {
	static GodotAppleEventDelegate *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[GodotAppleEventDelegate alloc] init];
	});
	return sharedInstance;
}

- (BOOL)application:(UIApplication *)application 
		continueUserActivity:(NSUserActivity *)userActivity 
		restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> *restorableObjects))restorationHandler {
		
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSURLComponents *URLComponents = [NSURLComponents componentsWithURL:userActivity.webpageURL resolvingAgainstBaseURL:YES];
        NSLog(@"APPLE_EVENT: open URL:%@", URLComponents.path);
		
		GodotAppleEvent* apple_event = GodotAppleEvent::get_singleton();
		if (apple_event) {
			apple_event->open_url(String::utf8([URLComponents.path UTF8String]));
		}
    }
    return YES;
}


@end


