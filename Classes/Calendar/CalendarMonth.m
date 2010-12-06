//
//  CalendarMonth.m
//  Calendar
//
//  Created by Lloyd Bottomley on 29/04/10.
//  Copyright 2010 Savage Media Pty Ltd. All rights reserved.
//

#import "CalendarMonth.h"

#import "CalendarLogic.h"


#define kCalendarDayWidth	46.0f
#define kCalendarDayHeight	44.0f


@implementation CalendarMonth


#pragma mark -
#pragma mark Getters / setters

@synthesize calendarLogic;
@synthesize datesIndex;
@synthesize buttonsIndex;

@synthesize numberOfDaysInWeek;
@synthesize selectedButton;
@synthesize selectedDate;



#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	self.calendarLogic = nil;
	self.datesIndex = nil;
	self.buttonsIndex = nil;
	self.selectedDate = nil;
	
    [super dealloc];
}



#pragma mark -
#pragma mark Initialization

// Calendar object init
- (id)initWithFrame:(CGRect)frame logic:(CalendarLogic *)aLogic {
	
	// Size is static
	NSInteger numberOfWeeks = 5;
	frame.size.width = 320;
	frame.size.height = ((numberOfWeeks + 1) * kCalendarDayHeight) + 60;
	selectedButton = -1;
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[NSDate date]];	
	NSDate *todayDate = [calendar dateFromComponents:components];
	
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.backgroundColor = [UIColor redColor]; // Red should show up fails.
		self.opaque = YES;
		self.clipsToBounds = NO;
		self.clearsContextBeforeDrawing = NO;
		
		UIImageView *headerBackground = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CalendarBackground.png"]] autorelease];
		[headerBackground setFrame:CGRectMake(0, 0, 320, 60)];
		[self addSubview:headerBackground];
		
		UIImageView *calendarBackground = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CalendarBackground.png"]] autorelease];
		[calendarBackground setFrame:CGRectMake(0, 60, 320, (numberOfWeeks + 1) * kCalendarDayHeight)];
		[self addSubview:calendarBackground];
		
		
		
		NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
		NSArray *daySymbols = [formatter shortWeekdaySymbols];
		self.numberOfDaysInWeek = [daySymbols count];
		
		
		UILabel *aLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
		aLabel.backgroundColor = [UIColor clearColor];
		aLabel.textAlignment = UITextAlignmentCenter;
		aLabel.font = [UIFont boldSystemFontOfSize:20];
		aLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CalendarTitleColor.png"]];
		aLabel.shadowColor = [UIColor whiteColor];
		aLabel.shadowOffset = CGSizeMake(0, 1);
		
		[formatter setDateFormat:@"MMMM yyyy"];
		aLabel.text = [formatter stringFromDate:aLogic.referenceDate];
		[self addSubview:aLabel];
		
		
		UIView *lineView = [[[UIView alloc] initWithFrame:CGRectMake(0, 59, 320, 1)] autorelease];
		lineView.backgroundColor = [UIColor lightGrayColor];
		[self addSubview:lineView];
		
		
		// Setup weekday names
		NSInteger firstWeekday = [calendar firstWeekday] - 1;
		for (NSInteger aWeekday = 0; aWeekday < numberOfDaysInWeek; aWeekday ++) {
 			NSInteger symbolIndex = aWeekday + firstWeekday;
			if (symbolIndex >= numberOfDaysInWeek) {
				symbolIndex -= numberOfDaysInWeek;
			}
			
			NSString *symbol = [daySymbols objectAtIndex:symbolIndex];
			CGFloat positionX = (aWeekday * kCalendarDayWidth) - 1;
			CGRect aFrame = CGRectMake(positionX, 40, kCalendarDayWidth, 20);
			
			aLabel = [[[UILabel alloc] initWithFrame:aFrame] autorelease];
			aLabel.backgroundColor = [UIColor clearColor];
			aLabel.textAlignment = UITextAlignmentCenter;
			aLabel.text = symbol;
			aLabel.textColor = [UIColor darkGrayColor];
			aLabel.font = [UIFont systemFontOfSize:12];
			aLabel.shadowColor = [UIColor whiteColor];
			aLabel.shadowOffset = CGSizeMake(0, 1);
			[self addSubview:aLabel];
		}
		
		// Build calendar buttons (6 weeks of 7 days)
		NSMutableArray *aDatesIndex = [[[NSMutableArray alloc] init] autorelease];
		NSMutableArray *aButtonsIndex = [[[NSMutableArray alloc] init] autorelease];
		
		for (NSInteger aWeek = 0; aWeek <= numberOfWeeks; aWeek ++) {
			CGFloat positionY = (aWeek * kCalendarDayHeight) + 60;
			
			for (NSInteger aWeekday = 1; aWeekday <= numberOfDaysInWeek; aWeekday ++) {
				CGFloat positionX = ((aWeekday - 1) * kCalendarDayWidth) - 1;
				CGRect dayFrame = CGRectMake(positionX, positionY, kCalendarDayWidth, kCalendarDayHeight);
				NSDate *dayDate = [CalendarLogic dateForWeekday:aWeekday 
														 onWeek:aWeek 
												  referenceDate:[aLogic referenceDate]];
				NSDateComponents *dayComponents = [calendar 
												   components:NSDayCalendarUnit fromDate:dayDate];
				
				UIColor *titleColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CalendarTitleColor.png"]];
				if ([aLogic distanceOfDateFromCurrentMonth:dayDate] != 0) {
					titleColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"CalendarTitleDimColor.png"]];
				}
				
				UIButton *dayButton = [UIButton buttonWithType:UIButtonTypeCustom];
				dayButton.opaque = YES;
				dayButton.clipsToBounds = NO;
				dayButton.clearsContextBeforeDrawing = NO;
				dayButton.frame = dayFrame;
				dayButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
				dayButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
				dayButton.tag = [aDatesIndex count];
				dayButton.adjustsImageWhenHighlighted = NO;
				dayButton.adjustsImageWhenDisabled = NO;
				dayButton.showsTouchWhenHighlighted = YES;
				
				
				// Normal
				[dayButton setTitle:[NSString stringWithFormat:@"%d", [dayComponents day]] 
						   forState:UIControlStateNormal];
				
				// Selected
				[dayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
				[dayButton setTitleShadowColor:[UIColor grayColor] forState:UIControlStateSelected];
				
				if ([dayDate compare:todayDate] != NSOrderedSame) {
					// Normal
					[dayButton setTitleColor:titleColor forState:UIControlStateNormal];
					[dayButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
					[dayButton setBackgroundImage:[UIImage imageNamed:@"CalendarDayTile.png"] forState:UIControlStateNormal];
					
					// Selected
					[dayButton setBackgroundImage:[UIImage imageNamed:@"CalendarDaySelected.png"] forState:UIControlStateSelected];
					
				} else {
					// Normal
					[dayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
					[dayButton setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
					[dayButton setBackgroundImage:[UIImage imageNamed:@"CalendarDayToday.png"] forState:UIControlStateNormal];
					
					// Selected
					[dayButton setBackgroundImage:[UIImage imageNamed:@"CalendarDayTodaySelected.png"] forState:UIControlStateSelected];
				}

				
				[dayButton addTarget:self action:@selector(dayButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
				[self addSubview:dayButton];
				
				// Save
				[aDatesIndex addObject:dayDate];
				[aButtonsIndex addObject:dayButton];
			}
		}
		
		// save
		self.calendarLogic = aLogic;
		self.datesIndex = [[aDatesIndex copy] autorelease];
		self.buttonsIndex = [[aButtonsIndex copy] autorelease];
    }
    return self;
}



#pragma mark -
#pragma mark UI Controls

- (void)dayButtonPressed:(id)sender {
	[calendarLogic setReferenceDate:[datesIndex objectAtIndex:[sender tag]]];
}
- (void)selectButtonForDate:(NSDate *)aDate {
	if (selectedButton >= 0) {
		NSDate *todayDate = [CalendarLogic dateForToday];
		UIButton *button = [buttonsIndex objectAtIndex:selectedButton];
		
		CGRect selectedFrame = button.frame;
		if ([selectedDate compare:todayDate] != NSOrderedSame) {
			selectedFrame.origin.y = selectedFrame.origin.y + 1;
			selectedFrame.size.width = kCalendarDayWidth;
			selectedFrame.size.height = kCalendarDayHeight;
		}
		
		button.selected = NO;
		button.frame = selectedFrame;
		
		self.selectedButton = -1;
		self.selectedDate = nil;
	}
	
	if (aDate != nil) {
		// Save
		self.selectedButton = [calendarLogic indexOfCalendarDate:aDate];
		self.selectedDate = aDate;
		
		NSDate *todayDate = [CalendarLogic dateForToday];
		UIButton *button = [buttonsIndex objectAtIndex:selectedButton];
		
		CGRect selectedFrame = button.frame;
		if ([aDate compare:todayDate] != NSOrderedSame) {
			selectedFrame.origin.y = selectedFrame.origin.y - 1;
			selectedFrame.size.width = kCalendarDayWidth + 1;
			selectedFrame.size.height = kCalendarDayHeight + 1;
		}
		
		button.selected = YES;
		button.frame = selectedFrame;
		[self bringSubviewToFront:button];	
	}
}


@end
