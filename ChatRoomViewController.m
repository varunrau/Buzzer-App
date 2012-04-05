#import "ChatRoomViewController.h"
#import "ChattyAppDelegate.h"
#import "UITextView+Utils.h"
#import "AppConfig.h"
#import <AudioToolbox/AudioServices.h>

@implementation ChatRoomViewController //Clients of a Local Room are composed of connections!!! To get the name of a client you have to access the connection and get theat data somehow...


@synthesize chatRoom;
@synthesize button;
@synthesize bar;
@synthesize state;
@synthesize scroller;
@synthesize buttonBuzz;
@synthesize clearSound;


@synthesize questions;
@synthesize categories; 
@synthesize answers;

@synthesize timer;
@synthesize textFile;
@synthesize wordsInQuestion;

@synthesize whoBuzzedLabel;

- (void)dealloc {
    self.chatRoom = nil;
    [button release];
    [bar release];
    //[state release];
    [scroller release];
    [buttonBuzz release];
    [clearSound release];
    [super dealloc];
}

// After view shows up, start the room
- (void)activate {
  if ( chatRoom != nil ) {
    chatRoom.delegate = self;
    [chatRoom start];
  }    
    [chat addSubview:scroller];
    
    timerInUse = false;
  
    chatRoom.bar = bar;
    state = @"";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"beep-2" ofType:@"wav"];
    NSURL *URL = [[NSURL alloc] initFileURLWithPath:path];
    NSError *error = nil; 
    AVAudioPlayer* readySound = [[AVAudioPlayer alloc]initWithContentsOfURL:URL error:&error];
    self.buttonBuzz = readySound;
    [URL release];
    [readySound release];
    [buttonBuzz setDelegate:self];
    
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"beep-7" ofType:@"wav"];
    NSURL *URL1 = [[NSURL alloc] initFileURLWithPath:path1];
    NSError *error1 = nil; 
    AVAudioPlayer* readySound1 = [[AVAudioPlayer alloc]initWithContentsOfURL:URL1 error:&error1];
    self.clearSound = readySound1;
    [URL1 release];
    [readySound1 release];
    [clearSound setDelegate:self];
    isLocal = [chatRoom isMemberOfClass:[LocalRoom class]]; 
    if(isLocal)
    {
    UIAlertView *playWithBot = [[UIAlertView alloc] initWithTitle:@"Bot?" message:@"Would you like to play with a bot that will read questions for you?" delegate:self cancelButtonTitle:@"Sounds Fun" otherButtonTitles:@"No Thanks", nil];
    [playWithBot show];
    [playWithBot release];
    }
    
    whoBuzzedLabel.hidden = YES;
    
  //[input becomeFirstResponder];
    button.hidden = NO;
    answering = false;
    botPlaying = false;
}

-(void) loadTextFile: (NSString *) textFileName
{
    if([chat.text isEqualToString:@""])
        chat.text = @"Your bot is starting...";
    else
        [chat appendTextAfterLinebreak:@"Your bot is starting..."];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:textFileName ofType:@"txt"];
    if(filePath)
    {
        NSString *textFromFilePath = [NSString stringWithContentsOfFile:filePath];
        NSArray *questionsSets = [textFromFilePath componentsSeparatedByString:@"\n"];
        questions = [[NSMutableArray alloc] init];
        categories = [[NSMutableArray alloc] init];
        answers = [[NSMutableArray alloc] init];
        for(int c = 0; c < [questionsSets count]; c++)
        {
            NSArray *partsOfQuestion = [[questionsSets objectAtIndex:c] componentsSeparatedByString:@";;"];
            [categories addObject:[partsOfQuestion objectAtIndex:0]];
            @try {
                [questions addObject:[partsOfQuestion objectAtIndex:1]];
                [answers addObject:[partsOfQuestion objectAtIndex:2]];
            }
            @catch (NSException *exception) {
                NSLog(@"trollolololol");
            }
        }
    }
    questionIndex = 0;
    answerIndex = 0;
    categoryIndex = 0;
    wordInQuestion = 0;
    textFile = textFileName;
    NSString *question = [questions objectAtIndex:questionIndex];
    wordsInQuestion = [question componentsSeparatedByString:@" "];
    [wordsInQuestion retain];
    [self startBot];
}

-(void) startBot
{
    [wordsInQuestion release];
    NSString *question = [questions objectAtIndex:questionIndex];
    wordsInQuestion = [question componentsSeparatedByString:@" "];
    [wordsInQuestion retain];
    timer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(addWord:) userInfo:nil repeats:YES];
    timerInUse = true;
    [chat appendTextAfterLinebreak:[NSString stringWithFormat:@"Category: %@", [categories objectAtIndex:categoryIndex]]];
    [chat appendTextAfterLinebreak:@""];
}

-(void) addWord:(NSTimer *) aTimer
{
    if(wordInQuestion < [wordsInQuestion count]) // checks to see if this is not the last word
    {
        chat.text = [chat.text stringByAppendingFormat:[wordsInQuestion objectAtIndex:wordInQuestion]];
        chat.text = [chat.text stringByAppendingFormat:@" "];
        [chat scrollToBottom];
        wordInQuestion++;
        [chatRoom broadcastChatMessage:@"update" fromUser:[wordsInQuestion objectAtIndex:wordInQuestion]];        
    }
    else{
        [timer invalidate];
        timerInUse = false;
        //NSTimer *questionEndTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(showAnswer:) userInfo:nil repeats:NO];
    }
}

-(void) setSelection:(int)theSelection withObjects:(NSArray *)objectsArray
{
    [self loadTextFile:[objectsArray objectAtIndex:theSelection]];
}

-(void) packetViewControllerDidFinish:(PacketViewController *)packetViewController
{
    [packetViewController dismissModalViewControllerAnimated:YES];
}

-(IBAction)changePacket:(id)sender
{
    PacketViewController *packetViewController = [[PacketViewController alloc] initWithNibName:@"PacketViewController" bundle:nil];
    packetViewController.delegate = self;
    packetViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:packetViewController animated:YES];
    [packetViewController release];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    CGPoint loc = [touch locationInView:self.view];
    
    if(touch.phase == UITouchPhaseBegan) {
        if([chat pointInside:loc withEvent:event]){
            [input resignFirstResponder];
        }
    }
}

-(void) checkAnswer:(NSString *) userAnswer
{
    NSString *answer = [answers objectAtIndex:answerIndex];
        answer = [answer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];//OMG!!!!
    NSString *theString = [AppConfig getInstance].name;
    answer = [answer lowercaseString];
    userAnswer = [userAnswer lowercaseString];
        if([userAnswer isEqualToString:answer])
        {
            NSLog(@"CORRECT");
            [chat appendTextAfterLinebreak:[NSString stringWithFormat:@"%@ has answered correctly!", theString]];
            [self newQuestion];
        }
        else
        {
            NSLog(@"INCORRECT");
            whoBuzzedLabel.text = [NSString stringWithFormat:@"%@ has answered incorrectly.", theString];
            whoBuzzedLabel.hidden = NO;
            timer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(addWord:) userInfo:nil repeats:YES];
            timerInUse = true;
        }
    state = @"";
    [input resignFirstResponder];
}


-(void) newQuestion
{
    questionIndex++;
    answerIndex++;
    categoryIndex++;
    wordInQuestion = 0;
    [self startBot];
    whoBuzzedLabel.hidden = YES;
}

-(void) askForAnswer;
{
    [input becomeFirstResponder];
    input.placeholder = @"Enter your answer here";
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up: YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"ok");
    [self animateTextField:textField up: NO];
    if([textField.placeholder isEqualToString:@"Enter your answer here"])
    {
        NSLog(textField.text);
        NSLog(@"fdaj");
    }
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 203; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    input.frame = CGRectOffset(input.frame, 0, movement);
    [UIView commitAnimations];
}

-(IBAction) button:(id)sender
{
    if([state isEqualToString:@""])
    {
        [input setText: @"Buzz!"];
        [chatRoom broadcastChatMessage:input.text fromUser:[AppConfig getInstance].name];
    }
    [buttonBuzz play];
    [input setText:@""];
}

-(NSString *) allButFirstLetter:(NSString *) yourMessage
{
    NSString *toReturn = @"";
    for(int c = 0; c < [yourMessage length]; c++)
    {
        if(c != 0)
        {
            NSString *charStr = [NSString stringWithFormat:@"%c", [yourMessage characterAtIndex:c]];
            toReturn = [toReturn stringByAppendingString:charStr];
        }
    }
    return toReturn;
}

// We are being asked to display a chat message
- (void)displayChatMessage:(NSString*)message fromUser:(NSString*)userName {
    
    if([message isEqualToString:@"update"])
        chat.text = [chat.text stringByAppendingString:userName];
    
    if(isLocal && answering)
    {
        NSString *check = [NSString stringWithFormat:@"%c", [message characterAtIndex:0]];
        if([check isEqualToString:@"@"])
            [self checkAnswer:[self allButFirstLetter:message]]; 
    }
             
    
    if([message isEqualToString:@"Buzz!"])
    {
        if([state isEqualToString:@""])
        {
            button.hidden = TRUE;
            state = userName;
            answering = true;
            if([[[AppConfig getInstance] name] isEqualToString:userName])
            {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                [buttonBuzz play];
                [self askForAnswer];
            }
            if(timerInUse)
            {
                [timer invalidate];
                timerInUse = false;
            }
        }
        if([chatRoom isMemberOfClass:[LocalRoom class]] && [state isEqualToString:userName])
        {
            NSString *theBuzz = [NSString stringWithFormat:@"%@ has buzzed", state];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:userName message:theBuzz delegate:self cancelButtonTitle:@"Reset" otherButtonTitles:nil];
            [alert show];
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            [alert release];
        }
    }
    if([message isEqualToString:@"Clear"])
    {
        state = @"";
        button.hidden = NO;
        whoBuzzedLabel.hidden = TRUE;
    }
    if([chat.text isEqualToString:@""])
    {
       //chat.text = [NSString stringWithFormat:@"%@: %@", userName, message];
        whoBuzzedLabel.text = [NSString stringWithFormat:@"%@ has buzzed!", userName];
        whoBuzzedLabel.hidden = NO;
    }
    else
    {
        //[chat appendTextAfterLinebreak:[NSString stringWithFormat:@"%@: %@", userName, message]];
        whoBuzzedLabel.text = [NSString stringWithFormat:@"%@ has buzzed!", userName];
        whoBuzzedLabel.hidden = NO;
    }
        
    [chat scrollToBottom];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if([alertView.message isEqualToString:@"Would you like to play with a bot that will read questions for you?"])
    {
        if(buttonIndex == 0)
        {
            botPlaying = true;
            if([questions count] > 0)
                [self startBot];
            else
            {
                [self loadTextFile:@"acffall"];
            }
        }
    }
    else
    {
        [chatRoom broadcastChatMessage:@"Clear" fromUser:@"Moderator"];
        whoBuzzedLabel.hidden = TRUE;
        [clearSound play];
    }
}

// Room closed from outside
- (void)roomTerminated:(id)room reason:(NSString*)reason {
  // Explain what happened
  UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Room terminated" message:reason delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
  [alert show];
  [alert release];
  [self exit];
}


// User decided to exit room
- (IBAction)exit {
  // Close the room
  [chatRoom stop];

  // Remove keyboard
  [input resignFirstResponder];

  // Erase chat
  chat.text = @"";
    if(timer)
    {
        [timer invalidate];
        timerInUse = false;
    }
  
  // Switch back to welcome view
  [[ChattyAppDelegate getInstance] showRoomSelection];
}


#pragma mark -
#pragma mark UITextFieldDelegate Method Implementations

// This is called whenever "Return" is touched on iPhone's keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    NSLog(@"should return");
    if(answering && isLocal)
    {
        [self checkAnswer:theTextField.text];
    }
    else if(answering && !isLocal)
    {
        [chatRoom broadcastChatMessage:[NSString stringWithFormat:@"@%@", theTextField.text] fromUser:[AppConfig getInstance].name]; 
    }
    /*
	if (theTextField == input) 
    {
    // processs input
    [chatRoom broadcastChatMessage:input.text fromUser:[AppConfig getInstance].name];

    // clear input
	}
     */
    
    [input setText:@""];
	return YES;
}

@end
