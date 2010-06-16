//
//  CalendarLogicDelegate.h
//  Calendar
//
//  Created by Lloyd Bottomley on 29/04/10.
//  Copyright 2010 Savage Media Pty Ltd. All rights reserved.
//

@class CalendarLogic;

@protocol CalendarLogicDelegate

- (void)calendarLogic:(CalendarLogic *)aLogic dateSelected:(NSDate *)aDate;
- (void)calendarLogic:(CalendarLogic *)aLogic monthChangeDirection:(NSInteger)aDirection;

@end
