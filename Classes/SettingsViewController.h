//
//  SettingsViewController.h
//  Chatty
//
//  Created by Varun Rau on 11/9/11.
//  Copyright (c) 2011 UC Berkeley. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SettingsViewController;

@protocol SettingsViewControllerDelegate
- (void) settingsViewControllerDidFinish:(SettingsViewController *)controller;
@end

@interface SettingsViewController : UIViewController<UITextFieldDelegate, UIAlertViewDelegate>
{
    UITextField *input;
    id<SettingsViewControllerDelegate> delegate;
}

@property (nonatomic, assign) IBOutlet id<SettingsViewControllerDelegate> delegate;
@property(nonatomic, retain) IBOutlet UITextField *input;

- (IBAction)done:(id)sender;
- (void) animateTextField: (UITextField*) textField up: (BOOL) up;

@end