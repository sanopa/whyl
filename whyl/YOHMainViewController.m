//
//  YOHMainViewController.m
//  whyl
//
//  Created by Sophia Anopa on 12.09.14.
//  Copyright (c) 2014 Aiiyoh. All rights reserved.
//

#import "YOHMainViewController.h"

#import <Parse/Parse.h>

@interface YOHMainViewController ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *historyButton;
@property (nonatomic, strong) UIButton *redditButton;
@property (nonatomic, strong) UIButton *settingsButton;
@end

@implementation YOHMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        PFUser *currentUser = [PFUser currentUser];
        if (!currentUser) {
            NSString *UUID = [self getUUID];
            [PFUser logInWithUsernameInBackground:UUID password:@"" block:^(PFUser *user, NSError *error) {
                if (error) {
                    [self signUpForParse:UUID];
                }
            }];
        }
        
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    
    // S: initializing buttons and title
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 100, 50)];
    self.titleLabel.text = @"whyl";
    self.titleLabel.textColor = [UIColor blackColor];
    [self.view addSubview:self.titleLabel];
    
    self.addButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.addButton setTitle:@"Add" forState:UIControlStateNormal];
    self.addButton.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.addButton];
    
    self.historyButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
    [self.historyButton setTitle:@"History" forState:UIControlStateNormal];
    self.historyButton.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.historyButton];
    
    self.redditButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 100, 100)];
    [self.redditButton setTitle:@"learn" forState:UIControlStateNormal];
    self.redditButton.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.redditButton];
    
    self.settingsButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, 100, 100)];
    [self.settingsButton setTitle:@"Settings" forState:UIControlStateNormal];
    self.settingsButton.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.settingsButton];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"Yay, signed up / logged in successfully\n");
        NSLog(@"%@",currentUser.username);
    } else {
        // Gray out the buttons
    }
}

- (NSString *)getUUID
{
    NSString *UUID = [[NSUserDefaults standardUserDefaults] objectForKey:@"uniqueID"];
    if (!UUID) {
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        CFStringRef string = CFUUIDCreateString(NULL, theUUID);
        CFRelease(theUUID);
        UUID = [(__bridge NSString*)string stringByReplacingOccurrencesOfString:@"-"withString:@""];
        [[NSUserDefaults standardUserDefaults] setValue:UUID forKey:@"uniqueID"];
    }
    return UUID;
}

- (void)signUpForParse:(NSString *)UUID
{
    PFUser *newUser = [PFUser user];
    newUser.username = UUID;
    newUser.password = @"";
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error)
            NSLog(@"Some error with signing up.");
    }];
    
}

- (void)createUserOnParse:(NSString *)UUID
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
