#import "ChattyViewController.h"
#import "ChattyAppDelegate.h"
#import "LocalRoom.h"
#import "RemoteRoom.h"
#import "AppConfig.h"


// Private properties
@interface ChattyViewController ()
@property(nonatomic,retain) ServerBrowser* serverBrowser;
@end


@implementation ChattyViewController

@synthesize serverBrowser;

// View loaded
- (void)viewDidLoad {
    serverBrowser = [[ServerBrowser alloc] init];
    serverBrowser.delegate = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"Yep");
    if(![defaults objectForKey:@"isFirstRun"])
    {
        NSLog(@"nil");
        [self getNewName];
        [defaults setObject:FALSE forKey:@"isFirstRun"];
    }
    //NSLog([defaults objectForKey:@"name"]);
}

-(void) getNewName
{
    if([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.0)//This works!
    {
        UIAlertView *getName = [[UIAlertView alloc] initWithTitle:nil message:@"What is your name?" delegate:self cancelButtonTitle:@"Enter" otherButtonTitles: nil];
        [getName setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [getName textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeWords;
        [getName show];
        [getName release];
    }
    else//This does not!
    {
        NSLog(@"Need to show settings");
        SettingsViewController *settings = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
        settings.delegate = self;
        settings.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:settings animated:YES];
        [settings release];
    }      
}

-(void) settingsViewControllerDidFinish:(SettingsViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

// Cleanup
- (void)dealloc {
    self.serverBrowser = nil;
    [super dealloc];
}


// View became active, start your engines
- (void)activate {
    // Start browsing for services
    [serverBrowser start];
}

-(IBAction)showSettings:(id)sender
{
    SettingsViewController *settings = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    settings.delegate = self;
    settings.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:settings animated:YES];
    [settings release];
}


// User is asking to create new game room
- (IBAction)createNewChatRoom:(id)sender {
    // Stop browsing for servers
    [serverBrowser stop];
    
    // Create local chat room and go
    LocalRoom* room = [[[LocalRoom alloc] init] autorelease];
    [[ChattyAppDelegate getInstance] showChatRoom:room];
}


// User is asking to join an existing game room
- (IBAction)joinChatRoom:(id)sender {
    // Figure out which server is selected
    NSIndexPath* currentRow = [serverList indexPathForSelectedRow];
    if ( currentRow == nil ) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Which game room?" message:@"Please select which game room you want to join from the list above" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    NSNetService* selectedServer = [serverBrowser.servers objectAtIndex:currentRow.row];
    
    // Create chat room that will connect to that game server
    RemoteRoom* room = [[[RemoteRoom alloc] initWithNetService:selectedServer] autorelease];
    
    // Stop browsing and switch over to game room
    [serverBrowser stop];
    [[ChattyAppDelegate getInstance] showChatRoom:room];
}

-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[alertView textFieldAtIndex:0].text forKey:@"name"];
    [defaults synchronize];
    [AppConfig getInstance].name = [defaults objectForKey:@"name"];
}




#pragma mark -
#pragma mark ServerBrowserDelegate Method Implementations

- (void)updateServerList {
    [serverList reloadData];
}


#pragma mark -
#pragma mark UITableViewDataSource Method Implementations

// Number of rows in each section. One section by default.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [serverBrowser.servers count];
}


// Table view is requesting a cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* serverListIdentifier = @"serverListIdentifier";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:serverListIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:serverListIdentifier] autorelease];
	}
    
    // Set cell's text to server's name
    NSNetService* server = [serverBrowser.servers objectAtIndex:indexPath.row];
    cell.text = [server name];
    
    return cell;
}

@end
