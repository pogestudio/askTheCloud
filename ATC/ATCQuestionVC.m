//
//  ATCQuestionView.m
//  ATC
//
//  Created by CA on 11/18/12.
//
//

#import "ATCQuestionVC.h"
#import "ATCQuestion.h"
#import "UILabel+sizeToFit.h"
#import "ATCQuestionStorage.h"
#import "ATCQuestionStatisticsVC.h"
#import "ATCLoadingIndicator.h"
#import "UIView+addShadow.h"

#define QUESTION_TITLE_LABEL_HEIGHT 100
#define BOTTOM_MENU_HEIGHT 40

@interface ATCQuestionVC ()
-(void)setUpForQuestion;                                                //called when you set self.questionToShow
@end

@implementation ATCQuestionVC

@synthesize questionToShow = _questionToShow;

-(id)initWithNibName:(NSString *)nibNameOrNil frame:(CGRect)frameForView delegate:(id<ATCQuestionVoteDelegate>)delegate
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self){
        self.alternativeButtons = [[NSMutableArray alloc] init];
        self.delegate = delegate;
        self.view.frame = frameForView;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [ATCColorPalette lightBackgroundColor];
    self.otherButton.backgroundColor = [UIColor lightGrayColor];
    self.otherButton.titleLabel.textColor = [ATCColorPalette accessoryButtonFont];
    self.otherButton.titleLabel.text = @"● ● ●";
    self.otherButton.titleLabel.textAlignment = UITextAlignmentCenter;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTitle:nil];
    [self setOtherButton:nil];
    [super viewDidUnload];
}

#pragma mark - 
#pragma mark Data related
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    ATCQuestionStorage *storage = [ATCQuestionStorage sharedStorage];
    [storage removeObserver:self forKeyPath:@"hasQuestionsToGiveAway"];
    [self removeLoadingIndicator];
    [self setUpView];
}

-(BOOL)loadQuestion
{
    BOOL loadQSuccess = NO;
    
    ATCQuestionStorage *storage = [ATCQuestionStorage sharedStorage];
    if (!storage.hasQuestionsToGiveAway) {
        [storage addObserver:self forKeyPath:@"hasQuestionsToGiveAway" options:NSKeyValueObservingOptionNew context:nil];
        [self addLoadingIndicator];
        [storage getMoreQuestions];
    } else {
        ATCQuestion *newQuestion = [[ATCQuestionStorage sharedStorage] deliverNextQuestion];
        self.questionToShow = newQuestion;
        loadQSuccess = YES;
    }

    return loadQSuccess;
}

#pragma mark -
#pragma mark Init all objects
-(void)setUpView
{
    //this method might be called several times due to signing up as an observer.
    //If we don't have a question, we should get one. We're only supposed to ask ONCE so
    //make sure that we don't have one first. Also, we should only set up the once, just after we receive
    //a new question.
    BOOL weGotANewQuestionAndShouldLoadView = NO;
    if (self.questionToShow == nil) {
        weGotANewQuestionAndShouldLoadView = [self loadQuestion];
    }
    
    if (weGotANewQuestionAndShouldLoadView) {
        [self setUpForQuestion];
    }
}

-(void)setUpForQuestion
{
    [self setUpTitleLabel];
    [self layoutSubviews];
    [self setUpStatisticsView];

}

-(void)setUpTitleLabel
{
    self.titleText.text = self.questionToShow.title;
    self.titleText.textColor = [ATCColorPalette questionFont];
}

-(void)addSingleTapGestureRecognizer
{
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewWasTapped:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
    
}

-(void)setUpStatisticsView
{
    //first calculate the frame
    CGFloat yPos = QUESTION_TITLE_LABEL_HEIGHT;
    CGFloat xPos = 0;
    CGFloat height = self.view.frame.size.height - yPos - BOTTOM_MENU_HEIGHT;
    CGFloat width = self.view.frame.size.width;
    CGRect frameForVoting = CGRectMake(xPos, yPos, width, height);
    
    self.statVC = [[ATCQuestionStatisticsVC alloc] initWithQuestion:self.questionToShow forFrame:frameForVoting withDelegate:self];
    
    [self.view addSubview:self.statVC.view];
    
}
#pragma mark -
#pragma mark Layout views
-(void)layoutSubviews
{
    [self layoutQuestionTitle];
    [self layoutExtraAccesoryButtons];
}

-(void)layoutQuestionTitle
{
    NSUInteger xPadding = 20;
    NSUInteger yPadding = 10;
    CGRect titleFrame = CGRectMake(xPadding, yPadding, self.view.frame.size.width-2*xPadding, QUESTION_TITLE_LABEL_HEIGHT);
    self.titleText.frame = titleFrame;
    self.titleText.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [self.titleText sizeFontToFitCurrentFrameStartingAt:50];
    self.maxFontSizeForAlternatives = self.titleText.font.pointSize;
    
}

-(void)layoutExtraAccesoryButtons
{
    CGFloat xPadding = 10;
    CGFloat xPos = xPadding;
    CGFloat yPos = self.view.frame.size.height - BOTTOM_MENU_HEIGHT;
    CGSize currentButtonSize = self.otherButton.frame.size;
    xPos = self.view.frame.size.width - xPadding - currentButtonSize.width;
    CGRect frameForRightButton = CGRectMake(xPos, yPos, currentButtonSize.width, currentButtonSize.height);
    self.otherButton.frame = frameForRightButton;
    [self.otherButton addShadowWithOffset:CGSizeMake(2, 2)];
}

#pragma mark -
#pragma mark View Animation
-(void)slideOutVoteButtons
{
    for (UIButton *buttonToSlide in self.alternativeButtons) {
        CGRect currentFrame = buttonToSlide.frame;
        CGRect newFrame = CGRectMake(-currentFrame.size.width,
                                     currentFrame.origin.y,
                                     currentFrame.size.width,
                                     currentFrame.size.height);
        
        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationCurveEaseIn
                         animations:^{
                             buttonToSlide.frame = newFrame; }
                         completion:^(BOOL finished){
                             [self addSingleTapGestureRecognizer];
                         }];
    
    }
}

-(void)addLoadingIndicator
{
    ATCLoadingIndicator *loadingInd = [[ATCLoadingIndicator alloc] init];
    CGFloat animationWidth = 50;
    CGFloat yPos = 150;
    CGFloat xPos = self.view.frame.size.width/2 - animationWidth/2;
    loadingInd.frame = CGRectMake(xPos,yPos,animationWidth,animationWidth);
    loadingInd.tag = LOADING_INDICATOR_VIEW_TAG;
    [self.view addSubview:loadingInd];
    [loadingInd startAnimation];
    
}

-(void)removeLoadingIndicator
{
    UIView *loading = [self.view viewWithTag:LOADING_INDICATOR_VIEW_TAG];
    NSAssert1([loading isKindOfClass:[ATCLoadingIndicator class]], @"Trying to cast a non-loading indicator as a loading ind. Did we assign wrong tag?", nil);
    ATCLoadingIndicator *loadingInd = (ATCLoadingIndicator*)loading;
    [loadingInd removeFromSuperview];
}

#pragma mark -
#pragma mark View Interaction

/*
-(void)viewWasSwiped:(UISwipeGestureRecognizer*)gestureRec
{
    //if we are here, we got a left swipe
    [self.delegate questionHasBeenVotedOn];
}

*/

-(void)viewWasTapped:(id)sender
{
    NSAssert1([sender isKindOfClass:[UIGestureRecognizer class]], @"not a gesture rec calling tap-selector", nil);
    UIGestureRecognizer *gestureRec = (UIGestureRecognizer*)sender;
    [self.view removeGestureRecognizer:gestureRec];

    [self.delegate presentNextQuestion];
}

-(IBAction)otherButtonPressed:(id)sender
{
    
}


#pragma mark QuestionVoteDelegate
-(void)questionHasBeenVotedOn
{
    [self addSingleTapGestureRecognizer];
}

@end
