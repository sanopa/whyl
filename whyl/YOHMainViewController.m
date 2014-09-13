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
@property (nonatomic, strong) UIButton *addButton;
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
    
    self.addButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.addButton setTitle:@"Add" forState:UIControlStateNormal];
    self.addButton.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.addButton];
    
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
