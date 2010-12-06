//
//  CalendarViewController.m
//  Calendar
//
//  Created by Lloyd Bottomley on 29/04/10.
//  Copyright Savage Media Pty Ltd 2010. All rights reserved.
//

#import "CalendarViewController.h"

#import "CalendarLogic.h"
#import "CalendarMonth.h"


@implementation CalendarViewController


#pragma mark -
#pragma mark Getters / setters

@synthesize calendarViewControllerDelegate;

@synthesize calendarLogic;
@synthesize calendarView;
@synthesize calendarViewNew;
@synthesize selectedDate;
- (void)setSelectedDate:(NSDate *)aDate {
	[selectedDate autorelease];
	selectedDate = [aDate retain];
	
	[calendarLogic setReferenceDate:aDate];
	[calendarView selectButtonForDate:aDate];
}

@synthesize leftButton;
@synthesize rightButton;



#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	self.calendarViewControllerDelegate = nil;
	
	self.calendarLogic.calendarLogicDelegate = nil;
	self.calendarLogic = nil;
	
	self.calendarView = nil;
	self.calendarViewNew = nil;
	
	self.selectedDate = nil;
	
	self.leftButton = nil;
	self.rightButton = nil;
	
    [super dealloc];
}



#pragma mark -
#pragma mark Controller initialisation

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		// Init
    }
    return self;
}



#pragma mark -
#pragma mark View delegate

- (void)viewDidLoad {
    [super viewDidLoad];	
	
	self.title = NSLocalizedString(@"Calendar", @"");
	self.view.bounds = CGRectMake(0, 0, 320, 324);
	self.view.clearsContextBeforeDrawing = NO;
	self.view.opaque = YES;
	self.view.clipsToBounds = NO;
	
	NSDate *aDate = selectedDate;
	if (aDate == nil) {
		aDate = [CalendarLogic dateForToday];
	}
	
	CalendarLogic *aCalendarLogic = [[CalendarLogic alloc] initWithDelegate:self referenceDate:aDate];
	self.calendarLogic = aCalendarLogic;
	[aCalendarLogic release];
	
	UIBarButtonItem *aClearButton = [[UIBarButtonItem alloc] 
									 initWithTitle:NSLocalizedString(@"Clear", @"") style:UIBarButtonItemStylePlain
									 target:self action:@selector(actionClearDate:)];
	self.navigationItem.rightBarButtonItem = aClearButton;
	[aClearButton release];
		
	
	CalendarMonth *aCalendarView = [[CalendarMonth alloc] initWithFrame:CGRectMake(0, 0, 320, 324) logic:calendarLogic];
	[aCalendarView selectButtonForDate:selectedDate];
	[self.view addSubview:aCalendarView];
	
	self.calendarView = aCalendarView;
	[aCalendarView release];
	
	
	
	UIButton *aLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
	aLeftButton.frame = CGRectMake(0, 0, 60, 60);
	aLeftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 20, 20);
	[aLeftButton setImage:[UIImage imageNamed:@"CalendarArrowLeft.png"] forState:UIControlStateNormal];
	[aLeftButton addTarget:calendarLogic 
					action:@selector(selectPreviousMonth) 
		  forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:aLeftButton];
	self.leftButton = aLeftButton;
	
	UIButton *aRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
	aRightButton.frame = CGRectMake(260, 0, 60, 60);
	aRightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 20, 0);
	[aRightButton setImage:[UIImage imageNamed:@"CalendarArrowRight.png"] forState:UIControlStateNormal];
	[aRightButton addTarget:calendarLogic 
					 action:@selector(selectNextMonth) 
		   forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:aRightButton];
	self.rightButton = aRightButton;
}
- (void)viewDidUnload {
	self.calendarLogic.calendarLogicDelegate = nil;
	self.calendarLogic = nil;
	
	self.calendarView = nil;
	self.calendarViewNew = nil;
	
	self.selectedDate = nil;
	
	self.leftButton = nil;
	self.rightButton = nil;
}

- (CGSize)contentSizeForViewInPopoverView {
	return CGSizeMake(320, 324);
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad || interfaceOrientation == UIInterfaceOrientationPortrait;
}



#pragma mark -
#pragma mark UI events

- (void)actionClearDate:(id)sender {
	self.selectedDate = nil;
	[calendarView selectButtonForDate:nil];
	
	// Delegate called later.
	//[calendarViewControllerDelegate calendarViewController:self dateDidChange:nil];
}



#pragma mark -
#pragma mark CalendarLogic delegate

- (void)calendarLogic:(CalendarLogic *)aLogic dateSelected:(NSDate *)aDate {
	[selectedDate autorelease];
	selectedDate = [aDate retain];
	
	if ([calendarLogic distanceOfDateFromCurrentMonth:selectedDate] == 0) {
		[calendarView selectButtonForDate:selectedDate];
	}
	
	[calendarViewControllerDelegate calendarViewController:self dateDidChange:aDate];
}
- (void)calendarLogic:(CalendarLogic *)aLogic monthChangeDirection:(NSInteger)aDirection {
	BOOL animate = self.isViewLoaded;
	
	CGFloat distance = 320;
	if (aDirection < 0) {
		distance = -distance;
	}
	
	leftButton.userInteractionEnabled = NO;
	rightButton.userInteractionEnabled = NO;
	
	CalendarMonth *aCalendarView = [[CalendarMonth alloc] initWithFrame:CGRectMake(distance, 0, 320, 308) logic:aLogic];
	aCalendarView.userInteractionEnabled = NO;
	if ([calendarLogic distanceOfDateFromCurrentMonth:selectedDate] == 0) {
		[aCalendarView selectButtonForDate:selectedDate];
	}
	[self.view insertSubview:aCalendarView belowSubview:calendarView];
	
	self.calendarViewNew = aCalendarView;
	[aCalendarView release];
	
	if (animate) {
		[UIView beginAnimations:NULL context:nil];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationMonthSlideComplete)];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	}
	
	calendarView.frame = CGRectOffset(calendarView.frame, -distance, 0);
	aCalendarView.frame = CGRectOffset(aCalendarView.frame, -distance, 0);
	
	if (animate) {
		[UIView commitAnimations];
		
	} else {
		[self animationMonthSlideComplete];
	}
}

- (void)animationMonthSlideComplete {
	// Get rid of the old one.
	[calendarView removeFromSuperview];
	
	// replace
	self.calendarView = calendarViewNew;
	self.calendarViewNew = nil;

	leftButton.userInteractionEnabled = YES;
	rightButton.userInteractionEnabled = YES;
	calendarView.userInteractionEnabled = YES;
}

@end
