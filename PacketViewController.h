//
//  PacketViewController.h
//  Chatty
//
//  Created by Varun Rau on 12/4/11.
//  Copyright (c) 2011 UC Berkeley. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PacketViewController;

@protocol PacketViewControllerDelegate

-(void) packetViewControllerDidFinish:(PacketViewController *) packetViewController;
-(void) setSelection:(int)theSelection withObjects:(NSArray *) objectsArray;

@end

@interface PacketViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *table;
    NSDictionary *dataSource;
    int selection;
    NSArray *keys;
    NSArray *objects;
}

@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSDictionary *dataSource;
@property (nonatomic) int selection;
@property (nonatomic, retain) IBOutlet UIBarItem *doneButton;

@property (nonatomic, assign) id <PacketViewControllerDelegate> delegate;

-(IBAction)done:(id)sender;

@end
