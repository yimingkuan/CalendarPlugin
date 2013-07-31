#import "CDVCalendar.h"
#import <EventKitUI/EventKitUI.h>
#import <EventKit/EventKit.h>

@implementation CDVCalendar
@synthesize eventStore;

- (CDVPlugin*) initWithWebView:(UIWebView*)theWebView
{
    self = (CDVCalendar*)[super initWithWebView:theWebView];
    if (self) {
        [self setup];
    }
    return self;
}

//Check iOS permissions and grant calendar access (needed for iOS 6+)
- (void)setup {
    __block BOOL accessGranted = NO;
    eventStore= [[EKEventStore alloc] init];
    if([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    } else {
        accessGranted = YES;
    }
    
    if (accessGranted) {
        self.eventStore = eventStore;
    }
}

- (void)addEvent:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult = nil;
    NSString* title = [command.arguments objectAtIndex:0];
    NSString* location = [command.arguments objectAtIndex:1];
    NSString* description = [command.arguments objectAtIndex:2];
    NSTimeInterval startTimeMillis = [[command.arguments objectAtIndex:3] doubleValue] / 1000;
    NSTimeInterval endTimeMillis = [[command.arguments objectAtIndex:4] doubleValue] / 1000;
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startTimeMillis];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endTimeMillis];
    EKEvent *myEvent = [EKEvent eventWithEventStore: self.eventStore];
    myEvent.title = title;
    myEvent.location = location;
    myEvent.notes = description;
    myEvent.startDate = startDate;
    myEvent.endDate = endDate;
    myEvent.calendar = self.eventStore.defaultCalendarForNewEvents;
    
    EKAlarm *reminder = [EKAlarm alarmWithRelativeOffset:-2*60*60];
    
    [myEvent addAlarm:reminder];
    
    NSError *error = nil;
    [self.eventStore saveEvent:myEvent span:EKSpanThisEvent error:&error];

    if (error) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.userInfo.description];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end