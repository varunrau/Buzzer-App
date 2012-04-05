#import <UIKit/UIKit.h>
#import "ServerBrowserDelegate.h"
#import "ServerBrowser.h"
#import "SettingsViewController.h"


@interface ChattyViewController : UIViewController <UITableViewDataSource, SettingsViewControllerDelegate, ServerBrowserDelegate, UITextFieldDelegate> {
  ServerBrowser* serverBrowser;
  IBOutlet UITableView* serverList;
}


- (IBAction)createNewChatRoom:(id)sender;
- (IBAction)joinChatRoom:(id)sender;
-(IBAction)showSettings:(id)sender;

// View is active, start everything up
- (void)activate;

@end

