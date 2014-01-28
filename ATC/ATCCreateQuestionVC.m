//
//  ATCCreateQuestionVC.m
//  ATC
//
//  Created by Carl-Arvid Ewerbring on 11/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ATCCreateQuestionVC.h"
#import "ATCChooseDataVC.h"
#import "ATCQuestion.h"
#import "ATCServerInterface.h"

#import "NSDictionary+JSON.h"
#import "TPKeyboardAvoidingScrollView.h"

#define QUESTION_TITLE_HEIGHT 100
#define DEFAULT_AMOUNT_OF_ALTERNATIVES 2
#define TITLE_TEXTVIEW_TAG 2

#define XPADDING 10
#define BOTTOM_BUTTON_SPACE 40

@interface ATCCreateQuestionVC ()
-(void)cancelQuestion:(id)sender;                               //Ask containerVC to switch
-(void)postQuestion:(id)sender;
@end

@implementation ATCCreateQuestionVC

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.view = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:self.view.frame];
        self.alternatives = [[NSMutableArray alloc] init];
        
        //question textview
        self.questionTitle = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        self.questionTitle.text = @"Title";
        self.questionTitle.delegate = self;
        self.questionTitle.tag = TITLE_TEXTVIEW_TAG;
        [self.view addSubview:self.questionTitle];
        
        //buttons
        [self createAlternativeNumberButtons];
        
        //navigation buttons
        [self createBottomButtons];

        
    }
    return self;
}

-(void)createAlternativeNumberButtons
{
    _alternativeNumberButtons = [[NSMutableArray alloc] initWithCapacity:3];
    for (NSUInteger buttonCounter = 2; buttonCounter <= 4; buttonCounter++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.tag = buttonCounter;
        [button addTarget:self action:@selector(setNumberOfAlternatives:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[NSString stringWithFormat:@"%d",buttonCounter] forState:UIControlStateNormal];
        [_alternativeNumberButtons addObject:button];
        [self.view addSubview:button];
    }

}

-(void)createBottomButtons
{
    _postQuestion = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_postQuestion setTitle:@"Post" forState:UIControlStateNormal];
    [_postQuestion addTarget:self action:@selector(postQuestion:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_postQuestion];
    _cancelPost = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_cancelPost setTitle:@"C" forState:UIControlStateNormal];
    [_cancelPost addTarget:self action:@selector(cancelQuestion:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelPost];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.amountOfAlternatives = DEFAULT_AMOUNT_OF_ALTERNATIVES;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidUnload
{
    [self setTitle:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark -
#pragma mark View Layout


#pragma mark -
#pragma mark Managing alternatives
-(void)layoutSubviews
{
    [self layoutView];
    
    [self removeButtonsOfHigherIndexThanWeWantAlternatives];
    
    for (NSUInteger viewCount = 1; viewCount <= self.amountOfAlternatives; viewCount++) {
        [self setUpAlternativeNumber:viewCount];
    }
    
}

-(void)removeButtonsOfHigherIndexThanWeWantAlternatives
{
    //remove all views over the chosen alternative number
    NSUInteger viewIndex = [self.alternatives count] == 0 ? 0 : [self.alternatives count] - 1;
    for ( ; viewIndex >= self.amountOfAlternatives ; viewIndex --)
    {
        if (viewIndex >= self.amountOfAlternatives) {
            ATCChooseDataVC *thisAlternative = [self.alternatives lastObject];
            [thisAlternative.view removeFromSuperview];
            [self.alternatives removeLastObject];
        }
    }
}

-(void)layoutView
{
    [self layoutQuestionTitle];
    [self layoutAlternativeNumberButtons];
    [self layoutBottomButtons];
    
    
}

-(void)layoutAlternativeNumberButtons
{
    CGFloat xPaddingToPhoneFrame = XPADDING;
    CGFloat yPadding = 10;
    CGFloat buttonHeight = 35;
    CGFloat buttonWidth = 35;
    
    
    CGFloat yPos = self.questionTitle.frame.origin.y + self.questionTitle.frame.size.height + yPadding;
    CGFloat xSpaceInBetween = ( self.view.frame.size.width - 2*xPaddingToPhoneFrame - buttonWidth ) / 2.0;
    
    for (NSUInteger buttonCounter = 0 ; buttonCounter + 1 <= [_alternativeNumberButtons count] ; buttonCounter++) {
        UIButton *button  =[_alternativeNumberButtons objectAtIndex:buttonCounter];
        CGRect buttonFrame = CGRectMake(xPaddingToPhoneFrame + buttonCounter * xSpaceInBetween,
                                        yPos,
                                        buttonWidth,
                                        buttonHeight);
        button.frame = buttonFrame;
        
    }
    
}

-(void)layoutBottomButtons
{
    CGFloat yPadding = 10;
    CGFloat xPadding = XPADDING;
    CGFloat proportionOfPostButton = 0.75; // post button will be X% of the space cancel and post button can have
    CGFloat startY = self.view.frame.size.height - BOTTOM_BUTTON_SPACE; //the alternatives have padding to us!
    CGFloat startX = xPadding;
    CGFloat buttonHeight = BOTTOM_BUTTON_SPACE - yPadding;
    CGFloat totalButtonWidth = self.view.frame.size.width - 3*xPadding; //one padding in the middle
    CGFloat cancelButtonWidth = totalButtonWidth * (1.0-proportionOfPostButton);
    CGRect cancelButtonFrame = CGRectMake(startX, startY, cancelButtonWidth, buttonHeight);
    _cancelPost.frame = cancelButtonFrame;
    
    startX = startX + cancelButtonWidth + xPadding;
    CGFloat postButtonWidth = totalButtonWidth * proportionOfPostButton;
    CGRect postButtonFrame = CGRectMake(startX, startY, postButtonWidth, buttonHeight);
    _postQuestion.frame = postButtonFrame;
    
}

-(void)layoutQuestionTitle
{
    CGFloat xPadding = XPADDING;
    CGFloat yPadding = 10;
    
    //question text
    CGRect newQuestionFrame = CGRectMake(xPadding,
                                         yPadding,
                                         self.view.frame.size.width-2*xPadding,
                                         QUESTION_TITLE_HEIGHT);
    
    self.questionTitle.frame = newQuestionFrame;
}

-(void)setUpAlternativeNumber:(NSUInteger)viewToSetUp
{
    BOOL existedBefore = NO;
    ATCChooseDataVC *alternative;
    if ([self.alternatives count] >= viewToSetUp) {
        alternative = [self.alternatives objectAtIndex:(viewToSetUp-1)];
        existedBefore = YES;
    } else
    {
        alternative = [[ATCChooseDataVC alloc] initWithNibName:@"ATCChooseDataVC" bundle:nil];
    }

    // SET UP POSITION --------------------------- START
    CGRect newFrame = [self getNewFrameForAlternative:viewToSetUp];
    alternative.view.frame = newFrame;
    
    // SET UP POSITION --------------------------- END
    
    // SET UP LOOKS --------------------------- START
    alternative.alternativ.text = [NSString stringWithFormat:@"%d",viewToSetUp];
    [alternative layoutSubviews];
    
    //Hook it up!
    if (!existedBefore) {
        [self.view addSubview:alternative.view];
        //add it to our array to retain it
        [self.alternatives addObject:alternative];
    }
    alternative.questionVC = self;
}

-(CGRect)getNewFrameForAlternative:(NSUInteger)viewToSetUp
{
    CGFloat xPadding = XPADDING;
    CGFloat yPadding = 10;
    CGFloat bottomButtonOffset = BOTTOM_BUTTON_SPACE;
    CGFloat temporaryExtraRoomForNumberOfAlternativeButtons =  52; //TODO
    
    CGFloat chooseDataStartY = self.questionTitle.frame.origin.y +
    self.questionTitle.frame.size.height +
    temporaryExtraRoomForNumberOfAlternativeButtons; //
    CGFloat chooseDataWidth = self.view.frame.size.width - 2*xPadding;
    CGFloat amountOfAlternatives = self.amountOfAlternatives;

    CGFloat chooseDataHeightInclPadding = (self.view.frame.size.height - chooseDataStartY - bottomButtonOffset) / amountOfAlternatives;
    CGFloat chooseDataHeight = chooseDataHeightInclPadding - yPadding;
    CGFloat thisYPosition = chooseDataStartY + (viewToSetUp-1) * (chooseDataHeight + yPadding); //-1 because the first one should be at "initial" yPosition.
    CGRect alternativeFrame = CGRectMake(xPadding, thisYPosition, chooseDataWidth, chooseDataHeight);
    return alternativeFrame;
}

-(void)changeAllDataTypesTo:(AlternativeType)alternativeType
{
    for (ATCChooseDataVC *data in self.alternatives) {
        data.alternativeType = alternativeType;
    }
}

-(IBAction)switchDataType:(id)sender
{
    ATCChooseDataVC *anAlternative = [self.alternatives objectAtIndex:0];
    AlternativeType currentType = anAlternative.alternativeType;
    AlternativeType newType;
    switch (currentType) {
        case AlternativeTypeImage:
            newType = AlternativeTypeText;
            break;
        case AlternativeTypeText:
            newType = AlternativeTypeImage;
            break;
        default:
            NSAssert1(nil, @"Alternative type switch is broken in questioncreator", nil);
            break;
    }
    
    [self changeAllDataTypesTo:newType];
}

-(IBAction)setNumberOfAlternatives:(id)sender
{

    NSAssert1([sender isKindOfClass:[UIButton class]], @"soemthing is trying to set no of alts in a weird way", nil);
    UIButton *button = (UIButton*)sender;
    NSUInteger alternatives = button.tag;
    NSAssert(alternatives > 1 && alternatives < 5, @"weird amount of buttons!");
    self.amountOfAlternatives = alternatives;
    [self layoutSubviews];
    
}

#pragma mark POST to server
-(BOOL)checkIfAllFieldsAreFilledIn
{
    BOOL shouldPost = YES;
    if ([self.questionTitle.text isEqualToString:@""]) {
        shouldPost = NO;
        [self popAlertWarningUserAboutIncorrectFieldsForField:0];
    } else
    {
        for (ATCChooseDataVC *alternative in self.alternatives) {
            if ([alternative.alternativeText.text isEqualToString:@""]) {
                shouldPost = NO;
                [self popAlertWarningUserAboutIncorrectFieldsForField:[self.alternatives indexOfObject:alternative]+1];
            }
        }
    }
    
    return shouldPost;
}

-(void)popAlertWarningUserAboutIncorrectFieldsForField:(NSUInteger)field
{
    NSString *fieldWithError;
    switch (field) {
        case 0:
            fieldWithError = @"the Title.";
            break;
        default:
            fieldWithError = [NSString stringWithFormat:@"alternative no:%d",field];
            break;
    }
    
    NSString *fullstring = [NSString stringWithFormat:@"The question was incorrectly filled in. Please take a look at %@",fieldWithError];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Question incorrectly entered"
                                                    message:fullstring
                                                   delegate:self cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
	[alert show];
    
}

#pragma mark -
#pragma mark Navigation
-(void)cancelQuestion:(id)sender
{
    [self.delegate cancelledQuestion];
}

-(void)postQuestion:(id)sender
{
    BOOL everythingLooksGood = [self checkIfAllFieldsAreFilledIn];
    if (!everythingLooksGood) {
        return;
    }
    NSString *questionTitle = self.questionTitle.text;
    NSMutableArray *alternativeArray = [NSMutableArray array];
    for (ATCChooseDataVC *alternative in self.alternatives) {
        [alternativeArray addObject:alternative.alternativeText.text];
    }
    ATCServerInterface *server = [ATCServerInterface sharedServerInterface];
    //[server createQuestionOnServerWithTitle:questionTitle alternatives:alternativeArray callBackTo:self];
    [self.delegate postedQuestion];
    
}

#pragma mark UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSUInteger tag = textView.tag;
    BOOL shouldChange = YES;
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        shouldChange = NO;
    }
    
    NSString *stringInView = textView.text;
    NSUInteger lengthOfCurrentString = [stringInView length];
    NSUInteger lengthOfNewString = lengthOfCurrentString - range.length + [text length];
    
    //if we're in the right field, above range and NOT removing, say no
    if (tag == TITLE_TEXTVIEW_TAG && lengthOfNewString > MAX_CHARACTERS_IN_QUESTION && ![text isEqualToString:@""]) {
        shouldChange = NO;
    }
    return shouldChange;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    
    return YES;
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

@end
