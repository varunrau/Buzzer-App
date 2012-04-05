//
//  PacketViewController.m
//  Chatty
//
//  Created by Varun Rau on 12/4/11.
//  Copyright (c) 2011 UC Berkeley. All rights reserved.
//

#import "PacketViewController.h"

@implementation PacketViewController

@synthesize dataSource;
@synthesize table;
@synthesize selection;
@synthesize delegate;
@synthesize doneButton;

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    objects = [[NSArray alloc] initWithObjects:@"acffall", @"acffall2008", @"acfnat2004", @"acfnat2006", @"acfreg2003", nil];
    keys = [[NSArray alloc] initWithObjects:@"ACF Fall 2009",@"ACF Fall 2008", @"ACF Nationals 2006", @"ACF Nationals 2004", @"ACF Standard 2003" , nil];
    dataSource = [NSDictionary dictionaryWithObjects:objects forKeys:keys];//The object will be the actual name of the text file. The key will be the name that the user will see. Genius? I know!
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [keys count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    
    // Set up the cell...
    
    NSString *cellValue = [keys objectAtIndex:indexPath.row];//[keys objectAtIndex:indexPath.row];
    [cell setText:cellValue];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selection = indexPath.row;
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

-(IBAction)done:(id)sender
{
    [self.delegate packetViewControllerDidFinish:self];
    [self.delegate setSelection:selection withObjects:objects];
}

@end
