//
//  CalendarMonth.h
//  Calendar
//
//  Created by Lloyd Bottomley on 29/04/10.
//  Copyright 2010 Savage Media Pty Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CalendarLogic;

@interface CalendarMonth : UIView {
	CalendarLogic *calendarLogic;
	NSArray *datesIndex;
	NSArray *buttonsIndex;
	
	NSInteger numberOfDaysInWeek;
	NSInteger selectedButton;
	NSDate *selectedDate;
}

@property (nonatomic, retain) CalendarLogic *calendarLogic;
@property (nonatomic, retain) NSArray *datesIndex;
@property (nonatomic, retain) NSArray *buttonsIndex;

@property (nonatomic) NSInteger numberOfDaysInWeek;
@property (nonatomic) NSInteger selectedButton;
@property (nonatomic, retain) NSDate *selectedDate;


- (id)initWithFrame:(CGRect)frame logic:(CalendarLogic *)aLogic;

- (void)selectButtonForDate:(NSDate *)aDate;

@end
