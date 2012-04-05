#import <UIKit/UIKit.h>
#import "Room.h"
#import "RoomDelegate.h"
#import "RemoteRoom.h"
#import "LocalRoom.h"
#import <AVFoundation/AVAudioPlayer.h>
#import "PacketViewController.h"


@interface ChatRoomViewController : UIViewController <RoomDelegate, UITextFieldDelegate, UIAlertViewDelegate, AVAudioPlayerDelegate, PacketViewControllerDelegate> {
    UIButton *button;
    Room* chatRoom;
    IBOutlet UITextView* chat;
    IBOutlet UITextField* input;
    UINavigationBar *bar;
    NSString *state;
    UIScrollView *scroller;
    AVAudioPlayer *buttonBuzz;
    AVAudioPlayer *clearSound;
    
    NSMutableArray *questions; 
    NSMutableArray *categories;
    NSMutableArray *answers;
    
    NSString *textFile;
    NSTimer  *timer;
    
    int questionIndex;
    int categoryIndex;
    int answerIndex;
    int wordInQuestion;
    NSArray *wordsInQuestion;
    
    UILabel *whoBuzzedLabel;
    
    BOOL botPlaying;
    
    BOOL answering;
    BOOL timerInUse;
    BOOL isLocal;
}

@property(nonatomic,retain) NSString* state;
@property(nonatomic,retain) Room* chatRoom;
@property (nonatomic, retain) IBOutlet UIButton *button;
@property (nonatomic, retain) IBOutlet UINavigationBar *bar;
@property (nonatomic, retain) IBOutlet UIScrollView *scroller;

@property (nonatomic, retain) NSMutableArray *questions;
@property (nonatomic, retain) NSMutableArray *categories;
@property (nonatomic, retain) NSMutableArray *answers;
@property (nonatomic, retain) NSString *textFile;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) NSArray *wordsInQuestion;

@property (nonatomic, retain) AVAudioPlayer *buttonBuzz;
@property (nonatomic, retain) AVAudioPlayer *clearSound;

@property (nonatomic, retain) IBOutlet UILabel *whoBuzzedLabel;

// Exit back to the welcome screen
- (IBAction)exit;

//Buzzer Pressed
-(IBAction) button:(id) sender;

-(IBAction)changePacket:(id)sender;

// View is active, start everything up
- (void)activate;

- (void) animateTextField: (UITextField*) textField up: (BOOL) up;
-(void) setSelection:(int)theSelection withObjects:(NSArray *)objectsArray;
-(void) packetViewControllerDidFinish:(PacketViewController *)packetViewController;


@end
