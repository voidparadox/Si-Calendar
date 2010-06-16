//
//  CalendarAppDelegate.h
//  Calendar
//
//  Created by Lloyd Bottomley on 29/04/10.
//  Copyright Savage Media Pty Ltd 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarViewControllerDelegate.h"

@class CalendarViewController;

@interface CalendarAppDelegate : NSObject <UIApplicationDelegate, CalendarViewControllerDelegate> {
    IBOutlet UIWindow *window;
	
	CalendarViewController *calendarController;
	UINavigationController *navigationController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) CalendarViewController *calendarController;
@property (nonatomic, retain) UINavigationController *navigationController;

@end

