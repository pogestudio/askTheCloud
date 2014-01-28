//
//  ATCChooseDataVC.m
//  ATC
//
//  Created by CA on 11/17/12.
//
//

#import "ATCChooseDataVC.h"
#import "ATCCreateQuestionVC.h"

#define WIDTH_OF_ALTERNATIVE_NUMBER 30.0

@interface ATCChooseDataVC ()

@end

@implementation ATCChooseDataVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.alternativeType = AlternativeTypeText;
        NSLog(@"self:%@",self);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
#pragma mark Look Related
-(void)layoutSubviews
{
    // 1 set the position and size of alternative number to the left
    // 2 do the same for the textview
    // 3 do the same for the image view
    // 4 do the same for the image view OVERLAY button
    
    //1
    CGRect oldFrame = self.alternativ.frame;
    CGRect newFrame = CGRectMake(oldFrame.origin.x,
                                 oldFrame.origin.y,
                                 WIDTH_OF_ALTERNATIVE_NUMBER,
                                 oldFrame.size.height);
    self.alternativ.frame = newFrame;
    //2
    oldFrame = self.alternativeText.frame;
    newFrame = CGRectMake(self.alternativ.frame.size.width,
                          oldFrame.origin.y,
                          self.view.frame.size.width - self.alternativ.frame.size.width,
                          self.view.frame.size.height);
    self.alternativeText.frame = newFrame;
    //3
    self.chosenImage.frame = newFrame;
    //4
    self.wantImage.frame = newFrame;
}



#pragma mark Textfield
-(void)setUpViewForText
{
    self.alternativeText.hidden = NO;
    //self.wantImage.hidden = NO;
    self.chosenImage.hidden = YES;
    self.wantImage.hidden = YES;
}

#pragma mark Image
-(void)setUpViewForImage
{
    self.alternativeText.hidden = YES;
    self.chosenImage.hidden = NO;
    
    //set the button which removes the chosen image.
    self.wantImage.frame = self.chosenImage.frame;
    self.wantImage.hidden = NO;
    
}
-(IBAction)chooseImage:(id)sender
{
    
    // open a dialog with two custom buttons
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose image source"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take photo", @"Choose existing", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    //UIView *parentView = self.questionVC.view;
    //[actionSheet showInView:parentView]; // show from our table view (pops up in the middle of the table)A
}

#pragma mark - UIActionSheetDelegate for image selection

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    
	if (buttonIndex == 0)
	{
		//Take photo from camera
        NSLog(@"Take photo!");
        
        //Check Camera available or not
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.showsCameraControls = YES;
        }
        else
        {
            NSLog(@"NO CAMMEERA :(");
        }
        
	}
	else
	{
		//Pick from all folders in the gallery
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
    

    //[self.questionVC presentModalViewController:imagePicker animated:YES];


}

#pragma mark UIImagePickerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //Show OriginalImage size
    NSLog(@"OriginalImage width:%f height:%f",originalImage.size.width,originalImage.size.height);
    self.chosenImage.image = originalImage;
    [picker dismissModalViewControllerAnimated:YES];
}

//Tells the delegate that the user cancelled the pick operation.
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Custom Getters & Setters
-(void)setAlternativeType:(AlternativeType)alternativeType
{
    _alternativeType = alternativeType;
    switch (alternativeType) {
        case AlternativeTypeImage:
            [self setUpViewForImage];
            NSLog(@"Alternative: IMAGE");
            break;
        case AlternativeTypeText:
            [self setUpViewForText];
            NSLog(@"Alternative: TEXT");
            break;
        default:
            NSAssert1(nil, @"AlternativeTypes are weird...", nil);
            break;
    }
}

-(AlternativeType)alternativeType
{
    return _alternativeType;
}

#pragma mark UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL shouldChange = YES;
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        shouldChange = NO;
    }
    
    NSString *stringInView = textView.text;
    //if we're above range and NOT removing, say no
    if ([stringInView length] > MAX_CHARACTERS_IN_QUESTION && ![text isEqualToString:@""]) {
        shouldChange = NO;
    }
    
    return shouldChange;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
 
    return YES;
}

- (void)viewDidUnload {
    [self setAlternativ:nil];
    [self setChosenImage:nil];
    [self setWantImage:nil];
    [self setAlternativeText:nil];
    [super viewDidUnload];
}

@end
