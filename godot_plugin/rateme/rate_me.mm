//
//  rate_me.cpp
//  godot_plugin
//
//  Created by Denis Belov on 3/11/22.
//  Copyright © 2022 Godot. All rights reserved.
//

#import "rate_me.h"
#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#include "core/project_settings.h"
#include "core/class_db.h"


/*
 * Bind plugin's public interface
 */
void RateMe::_bind_methods() {
    ClassDB::bind_method(D_METHOD("showRateMe"), &RateMe::showRateMe);
    ADD_SIGNAL(MethodInfo("finished"));
}

RateMe::RateMe() {
    NSLog(@"Initialize RateMe");
}

RateMe::~RateMe() {
    NSLog(@"Deinitialize RateMe");
}

void RateMe::showRateMe() {
    if (@available(iOS 14.0, *)) {
        UIWindowScene *sc = nil;
        for(UIWindowScene *s in UIApplication.sharedApplication.connectedScenes) {
            if(s.activationState == UISceneActivationStateForegroundActive) {
                sc = s;
            }
        }
        if(sc != nil) {
            [SKStoreReviewController requestReviewInScene:sc];
        }
    } else if (@available(iOS 10.3, *)) {
        [SKStoreReviewController requestReview];
    } else {
        // Fallback on earlier versions
    }
}
