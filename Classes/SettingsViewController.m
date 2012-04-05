//
//  SettingsViewController.m
//  Chatty
//
//  Created by Varun Rau on 11/9/11.
//  Copyright (c) 2011 UC Berkeley. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppConfig.h"

@implementation SettingsViewController

@synthesize delegate;
@synthesize input;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void) dealloc
{
    [super dealloc];
    [input release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    input.delegate = self;
    // Do any additional setup after loading the view from its nib.
    
    UIAlertView *nameChange = [[UIAlertView alloc] initWithTitle:@"Name Change?" 
                                                             message:@"Would you like to change your name?" 
                                                            delegate:self 
                                                   cancelButtonTitle:@"No Way!" 
                                                   otherButtonTitles:@"Yes, please", nil];
    [nameChange show];
    [nameChange release];
    
    
    if([[[UIDevice currentDevice] systemVersion] doubleValue] < 5.0)
    {
        input.hidden = FALSE;
        [input becomeFirstResponder];
    }
    else
        input.hidden = TRUE;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up: YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![input.text isEqualToString:nil]) {
		// processs input
        
        // clear input
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:input.text forKey:@"name"];
        [AppConfig getInstance].name = [defaults objectForKey:@"name"];
        [input resignFirstResponder];
        [input setText:@""];
        [self.delegate settingsViewControllerDidFinish:self];
        
	}
    else
    {
        UIAlertView *supplyText = [[UIAlertView alloc] initWithTitle:@"Name" message:@"Please supply a name" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [supplyText show];
        [supplyText release];
    }
    [self.delegate settingsViewControllerDidFinish:self];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 203; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    int movement = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    textField.frame = CGRectOffset(textField.frame, 0, movement);
    [UIView commitAnimations];
}


-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex 
{
    if([alertView.title isEqualToString:@"Name Change?"] && buttonIndex == 0)
        [self.delegate settingsViewControllerDidFinish:self];
    else if([alertView.title isEqualToString:@"Name Change?"] && buttonIndex == 1)
    {
        if([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.0)
        {
            UIAlertView *changeName = [[UIAlertView alloc] initWithTitle:nil message:@"What is your name?" delegate:self cancelButtonTitle:@"Enter" otherButtonTitles: nil];
            [changeName setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [changeName textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeWords;
            [changeName show];
            [changeName release];
        }
        else
        {
            [input becomeFirstResponder];
        }
    }
    else if([alertView.message isEqualToString:@"What is your name?"])
    {
        NSLog(@"it is nil");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[alertView textFieldAtIndex:0].text forKey:@"name"];
        [defaults synchronize];
        [AppConfig getInstance].name = [defaults objectForKey:@"name"];
        [self.delegate settingsViewControllerDidFinish:self];
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
	if (![input.text isEqualToString:nil])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:input.text forKey:@"name"];
        [AppConfig getInstance].name = [defaults objectForKey:@"name"];
        [input resignFirstResponder];
        [input setText:@""];        
	}
    else
    {
        UIAlertView *supplyText = [[UIAlertView alloc] initWithTitle:@"Name" message:@"Please supply a name" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [supplyText show];
        [supplyText release];
        return false;
    }
	return YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction) done:(id)sender
{
    [self.delegate settingsViewControllerDidFinish:self];
}

@end
