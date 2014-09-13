//
//  YOHMainViewController.m
//  whyl
//
//  Created by Sophia Anopa on 12.09.14.
//  Copyright (c) 2014 Aiiyoh. All rights reserved.
//

#import "YOHMainViewController.h"

#import "YOHAddViewController.h"
#import "YOHHistoryViewController.h"
#import "YOHLearnViewController.h"

#import <Parse/Parse.h>

@interface YOHMainViewController ()
@property (nonatomic, strong) UIImageView *titleLabel;
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
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // S: initializing buttons and title
    self.titleLabel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    self.titleLabel.frame = CGRectMake(0, 0, self.view.frame.size.width - 100, (self.view.frame.size.width - 100)/(self.titleLabel.image.size.width) * (self.titleLabel.image.size.height));
    self.titleLabel.center = CGPointMake(self.view.frame.size.width / 2, 100);
    [self.view addSubview:self.titleLabel];
    
    self.addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, 75, 75)];
    [self.addButton setImage:[UIImage imageNamed:@"add-main"] forState:UIControlStateNormal];
    [self.addButton addTarget:self action:@selector(addButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.addButton.center = CGPointMake(self.view.frame.size.width / 2 - (self.addButton.frame.size.width / self.addButton.currentImage.size.width) / 2,
                                        self.addButton.frame.origin.y + (self.addButton.frame.size.height / self.addButton.currentImage.size.height) / 2);
    [self.view addSubview:self.addButton];
    
    
    self.historyButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.addButton.frame.origin.y + self.addButton.frame.size.height + 50, 75, 75)];
    [self.historyButton setImage:[UIImage imageNamed:@"history-main"] forState:UIControlStateNormal];
    [self.historyButton addTarget:self action:@selector(historyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.historyButton.center = CGPointMake(self.view.frame.size.width / 2 - (self.historyButton.frame.size.width / self.historyButton.currentImage.size.width) / 2, self.historyButton.frame.origin.y + (self.historyButton.frame.size.height / self.historyButton.currentImage.size.height) / 2);
    [self.view addSubview:self.historyButton];
    
    self.redditButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.historyButton.frame.origin.y + self.historyButton.frame.size.height + 50, 75, 75)];
    [self.redditButton setImage:[UIImage imageNamed:@"learn-main"] forState:UIControlStateNormal];
    [self.redditButton addTarget:self action:@selector(redditButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.redditButton.center = CGPointMake(self.view.frame.size.width / 2 - (self.redditButton.frame.size.width / self.redditButton.currentImage.size.width) / 2, self.redditButton.frame.origin.y + (self.redditButton.frame.size.height / self.redditButton.currentImage.size.height) / 2);
    [self.view addSubview:self.redditButton];
    
    self.settingsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.redditButton.frame.origin.y + self.redditButton.frame.size.height + 50, 75, 75)];
    [self.settingsButton setImage:[UIImage imageNamed:@"settings-main"] forState:UIControlStateNormal];
    [self.settingsButton addTarget:self action:@selector(settingsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.settingsButton.center = CGPointMake(self.view.frame.size.width / 2 - (self.settingsButton.frame.size.width / self.settingsButton.currentImage.size.width) / 2, self.settingsButton.frame.origin.y + (self.settingsButton.frame.size.height / self.settingsButton.currentImage.size.height) / 2);
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

#pragma mark - Dealing with Buttons
- (void)addButtonPressed:(UIButton *)button
{
    UIViewController *addViewController = [[YOHAddViewController alloc] init];
    addViewController.title = @"Add";
    self.navigationController.navigationBarHidden = false;
    [self presentViewController:addViewController
                       animated:YES
                     completion:NULL];
}

- (void)historyButtonPressed:(UIButton *)button
{
    UIViewController *historyViewController = [[YOHHistoryViewController alloc] init];
    self.navigationController.navigationBarHidden = false;
    [self.navigationController pushViewController:historyViewController animated:YES];
}

- (void)redditButtonPressed:(UIButton *)button
{
    UIViewController *redditViewController = [[YOHLearnViewController alloc] init];
    self.navigationController.navigationBarHidden = false;
    [self.navigationController pushViewController:redditViewController animated:YES];
}

- (void)settingsButtonPressed:(UIButton *)button
{
    NSLog(@"Settings button pressed");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = true;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
