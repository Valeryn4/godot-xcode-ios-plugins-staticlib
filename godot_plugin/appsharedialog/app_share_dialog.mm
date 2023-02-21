/*************************************************************************/
/*  in_app_store.mm                                                      */
/*************************************************************************/
/*                       This file is part of:                           */
/*                           GODOT ENGINE                                */
/*                      https://godotengine.org                          */
/*************************************************************************/
/* Copyright (c) 2007-2021 Juan Linietsky, Ariel Manzur.                 */
/* Copyright (c) 2014-2021 Godot Engine contributors (cf. AUTHORS.md).   */
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

#include "app_share_dialog.h"

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import <Photos/Photos.h>
#import "platform/iphone/godot_app_delegate.h"

AppShareDialog *AppShareDialog::instance = NULL;


void AppShareDialog::_bind_methods() {
	ClassDB::bind_method(D_METHOD("share_text"), &AppShareDialog::share_text);
	ClassDB::bind_method(D_METHOD("share_image"), &AppShareDialog::share_image);
}

AppShareDialog *AppShareDialog::get_singleton() {
	return instance;
}

AppShareDialog::AppShareDialog() {
	ERR_FAIL_COND(instance != NULL);
	instance = this;
}


AppShareDialog::~AppShareDialog() {
}

void AppShareDialog::share_text(String title, String subject, String text) {

	UIViewController *root_controller = (UIViewController*)[[(GodotApplicalitionDelegate*)[[UIApplication sharedApplication]delegate] window] rootViewController];
	//UIViewController *root_controller = [UIApplication sharedApplication].keyWindow.rootViewController;

	NSString * message = [NSString stringWithCString:text.utf8().get_data() encoding:NSUTF8StringEncoding];

	NSArray * shareItems = @[message];

	UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
	avc.excludedActivityTypes = @[UIActivityTypePostToTwitter,UIActivityTypePostToFacebook,UIActivityTypeMessage,UIActivityTypeSaveToCameraRoll];
	avc.popoverPresentationController.sourceRect = CGRectMake(
		root_controller.view.frame.size.width/4, 
		root_controller.view.frame.size.height/4, 
		root_controller.view.frame.size.height/2, 
		root_controller.view.frame.size.height/2
	);
	//if iPhone
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
    //if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		[root_controller presentViewController:avc animated:YES completion:nil];
	}
	//if iPad
	else {
	// Change Rect to position Popover
		
		avc.modalPresentationStyle                   = UIModalPresentationPopover;
		avc.popoverPresentationController.sourceView = root_controller.view;
		[root_controller presentViewController:avc animated:YES completion:nil];
		
	}
}

void AppShareDialog::_share_image(String path, String title, String subject, String text) {
    UIViewController *root_controller = (UIViewController*)[
        [(GodotApplicalitionDelegate*)[[UIApplication sharedApplication] delegate] window] rootViewController];
	NSLog(@"AppShareDialog: get root comtroller");
    
    NSString * message = [NSString stringWithCString:text.utf8().get_data() encoding:NSUTF8StringEncoding];
    NSLog(@"AppShareDialog: messedge '%@'", message);
    NSString * imagePath = [NSString stringWithCString:path.utf8().get_data() encoding:NSUTF8StringEncoding];
    NSLog(@"AppShareDialog: image path '%@'", imagePath);
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    if (image == nil) {
        NSLog(@"AppShareDialog: failed, image is null!");
        return;
    }

    NSArray * shareItems = @[message, image];
    NSLog(@"AppShareDialog: share items created [message, image]!");

    UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
    NSLog(@"AppShareDialog: avc inited!");

    if (avc == nil) {
        NSLog(@"AppShareDialog failed!, avc alloc failed!");
        return;
    }
     
     //if iPhone
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        NSLog(@"AppShareDialog: iphone save dialog");
        [root_controller presentViewController:avc animated:YES completion:nil];
    }
    //if iPad
    else {
        NSLog(@"AppShareDialog: ipad save dialog");
        avc.modalPresentationStyle = UIModalPresentationPopover; //UIModalPresentationOverFullScreen;//UIModalPresentationPopover;
        //avc.popoverPresentationController.arrowDirection = UIPopoverArrowDirectionUnknown;
        avc.preferredContentSize = CGSizeMake(
                                              root_controller.view.frame.size.width * 0.7,
                                              root_controller.view.frame.size.height * 0.6
                                            );
       // UIPopoverPresentationController *popover = avc.popoverPresentationController;
       // popover.sourceView = root_controller.view;
        avc.popoverPresentationController.sourceView = root_controller.view;
   
        avc.popoverPresentationController.sourceRect = CGRectMake(root_controller.view.frame.size.width * 0.5, 0, 1, 1);
        
        //CGRectMake(0, 0, 600, 600);
		[root_controller presentViewController:avc animated:YES completion:nil];
    }
}

void AppShareDialog::share_image(String path, String title, String subject, String text) {
    String text_print = String(path + ", " + title + ", " + subject + ", " + text);
    NSString* ns_text_print = [NSString stringWithCString:text_print.utf8().get_data() encoding:NSUTF8StringEncoding];
    NSLog(@"AppShareDialog: share image");
    NSLog(@"AppShareDialog: args [%@]", ns_text_print);

    if (@available(iOS 14, *)) {
        NSLog(@"AppShareDialog: ios 12+ avalible!");
        PHAuthorizationStatus prevStatus = [PHPhotoLibrary authorizationStatus];
        prevStatus = [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelAddOnly];

        if (prevStatus == PHAuthorizationStatusNotDetermined) {
            NSLog(@"AppShareDialog Status is 'Not Determined'");
            [PHPhotoLibrary requestAuthorizationForAccessLevel:(PHAccessLevelAddOnly) handler:^(PHAuthorizationStatus status) {
                
                NSLog(@"AppShareDialog: request access level!");
                if (status == PHAuthorizationStatusAuthorized) {
                    NSLog(@"AppShareDialog: success");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"AppShareDialog: share image");
                        _share_image(path, title, subject, text);
                    });
                }
                else {
                    
                    NSLog(@"AppShareDialog: denied! open without photo library");
                    _share_image(path, title, subject, text);
                }
            }];
            return;
        }
        else {
            NSLog(@"AppShareDialog: Status is 'Determined', open share");
            _share_image(path, title, subject, text);
        }
    }
    else {
        NSLog(@"AppShareDialog: ios < 12 version!");
        _share_image(path, title, subject, text);
    }
}

