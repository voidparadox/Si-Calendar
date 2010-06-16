//
//  CalendarAppDelegate.m
//  Calendar
//
//  Created by Lloyd Bottomley on 29/04/10.
//  Copyright Savage Media Pty Ltd 2010. All rights reserved.
//

#import "CalendarAppDelegate.h"
#import "CalendarViewController.h"

@implementation CalendarAppDelegate

@synthesize window;
@synthesize calendarController;
@synthesize navigationController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	CalendarViewController *controller = [[CalendarViewController alloc] initWithNibName:nil bundle:nil];
	UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:controller];
	controller.calendarViewControllerDelegate = self;
	
	[window addSubview:navigation.view];
    [window makeKeyAndVisible];
	
	self.calendarController = [controller autorelease];
	self.navigationController = [navigation autorelease];
	
	return YES;
}

- (void)calendarViewController:(CalendarViewController *)aCalendarViewController dateDidChange:(NSDate *)aDate {
	
	// Pop calendar off the navigation stack
	
	// Use date deleted. Nil returned for cleared date.
	
}

- (void)dealloc {
	self.calendarController = nil;
	self.navigationController = nil;
	
    [window release];
    [super dealloc];
}


@end
