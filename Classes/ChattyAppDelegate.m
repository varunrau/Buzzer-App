#import "ChattyAppDelegate.h"
#import "ChattyViewController.h"
#import "ChatRoomViewController.h"
#import "WelcomeViewController.h"
#import "AppConfig.h"

static ChattyAppDelegate* _instance;

@implementation ChattyAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize chatRoomViewController;
@synthesize welcomeViewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    // Allow other classes to use us
    _instance = self;
    
    // Override point for customization after app launch
    [window addSubview:chatRoomViewController.view];
    [window addSubview:viewController.view];  
    [window bringSubviewToFront:viewController.view];
    [window makeKeyAndVisible];
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];  
    //double systemVersion = [[[UIDevice currentDevice] systemVersion] doubleValue];
}

- (void)dealloc {
    [viewController release];
    [chatRoomViewController release];
    [welcomeViewController release];
    [window release];
    [super dealloc];
}


+ (ChattyAppDelegate *)getInstance {
  return _instance;
}


// Show chat room
- (void)showChatRoom:(Room*)room {
  chatRoomViewController.chatRoom = room;
  [chatRoomViewController activate];
  
  [window bringSubviewToFront:chatRoomViewController.view];
}


// Show screen with room selection
- (void)showRoomSelection {
  [viewController activate];
    [window bringSubviewToFront:viewController.view];  
}

-(void) applicationWillTerminate:(UIApplication *)application  
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
}

-(void) applicationWillResignActive:(UIApplication *)application
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
}



@end
