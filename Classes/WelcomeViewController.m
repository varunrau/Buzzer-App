

#import "WelcomeViewController.h"
#import "AppConfig.h"
#import "ChattyAppDelegate.h"


@implementation WelcomeViewController

// App delegate will call this whenever this view becomes active
- (void)activate {
  // Display keyboard
  [input becomeFirstResponder];
}


// This is called whenever "Return" is touched on iPhone's keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
  if ( theTextField.text == nil || [theTextField.text length] < 1 ) {
    return NO;
  }

  // Save user's name
  [AppConfig getInstance].name = theTextField.text;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:theTextField.text forKey:@"name"];
    [defaults synchronize];

  // Dismiss keyboard
  [theTextField resignFirstResponder];

  // Move on to the next screen
  [[ChattyAppDelegate getInstance] showRoomSelection];

	return YES;
}

@end
