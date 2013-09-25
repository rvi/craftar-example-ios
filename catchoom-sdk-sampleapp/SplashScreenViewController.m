//
// © Catchoom Technologies S.L.
// Licensed under the MIT license.
// http://github.com/Catchoom/catchoom-example-ios/blob/master/LICENSE
//  All warranties and liabilities are disclaimed.
//

#import "SplashScreenViewController.h"

@interface SplashScreenViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation SplashScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if( IS_IPHONE_5 )
    {
        self.backgroundImageView.image = [UIImage imageNamed:@"Default-568h@2x.png"];
    }
    [self performSelector:@selector(launchMainMenu) withObject:self afterDelay: 1];
}

- (void) launchMainMenu {
    UIViewController *target;
    UIStoryboard *exampleStoryBoard = [UIStoryboard storyboardWithName:@"CloudRecognition" bundle:nil];
    
    // FINDER MODE
    //target = (UIViewController *)[exampleStoryBoard instantiateViewControllerWithIdentifier:@"CloudRecognitionFinderMode"];
    
    // ONE SHOT MODE
    target = (UIViewController *)[exampleStoryBoard instantiateViewControllerWithIdentifier:@"CloudRecognitionSnapPhoto"];
    
    [self.navigationController pushViewController:target animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
