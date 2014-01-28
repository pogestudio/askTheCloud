//
//  ATCChooseDataVC.h
//  ATC
//
//  Created by CA on 11/17/12.
//
//

/*
 
 An alternative for creating questions. If the CreateQuestionVC wants to get another alternative,
 it needs to add an instance of this to it's view. 
 
 THis class handles the input from user.
 
 */
#import <UIKit/UIKit.h>
@class ATCCreateQuestionVC;

#define MAX_CHARACTERS_IN_QUESTION 140


typedef enum {
    AlternativeTypeText = 1,
    AlternativeTypeImage,
} AlternativeType;

@interface ATCChooseDataVC : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UINavigationControllerDelegate> //UINavCon only for show. It's never used, but still needed. Would fuck up our design :P
{
    AlternativeType _alternativeType;                                   //declared for custom getter and setter
}
@property (strong, nonatomic) IBOutlet UILabel *alternativ;             //the text label which indicates which alternative number
@property (strong, nonatomic) IBOutlet UIImageView *chosenImage;        //the image which is chosen
@property (strong, nonatomic) IBOutlet UIButton *wantImage;             //the button which is put above the image, and can be pressed to choose new image.
@property (strong, nonatomic) IBOutlet UITextView *alternativeText;     //the text which is chosen. 
@property (assign) AlternativeType alternativeType;                     //defines if alternative is text or image
@property (weak) ATCCreateQuestionVC *questionVC;                       //reference back to parent view



-(IBAction)chooseImage:(id)sender;                                      //fired off if the user wants to choose a new (or change) image.
-(void)layoutSubviews;                                                  //used to update the views inside to match the size of choose data

@end
