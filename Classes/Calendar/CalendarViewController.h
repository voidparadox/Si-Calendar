//
//  CalendarViewController.h
//  Calendar
//
//  Created by Lloyd Bottomley on 29/04/10.
//  Copyright Savage Media Pty Ltd 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CalendarLogicDelegate.h"
#import "CalendarViewControllerDelegate.h"

@class CalendarLogic;
@class CalendarMonth;

@interface CalendarViewController : UIViewController <CalendarLogicDelegate> {
	id <CalendarViewControllerDelegate> calendarViewControllerDelegate;
	
	CalendarLogic *calendarLogic;
	CalendarMonth *calendarView;
	CalendarMonth *calendarViewNew;
	NSDate *selectedDate;

	UIButton *leftButton;
	UIButton *rightButton;
}

@property (nonatomic, assign) id <CalendarViewControllerDelegate> calendarViewControllerDelegate;

@property (nonatomic, retain) CalendarLogic *calendarLogic;
@property (nonatomic, retain) CalendarMonth *calendarView;
@property (nonatomic, retain) CalendarMonth *calendarViewNew;
@property (nonatomic, retain) NSDate *selectedDate;

@property (nonatomic, retain) UIButton *leftButton;
@property (nonatomic, retain) UIButton *rightButton;

- (void)animationMonthSlideComplete;

@end

