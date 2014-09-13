//
//  YOHAddViewController.m
//  whyl
//
//  Created by Sophia Anopa on 12.09.14.
//  Copyright (c) 2014 Aiiyoh. All rights reserved.
//

#import "YOHAddViewController.h"

#import "YOHHistoryViewController.h"

#import <Parse/Parse.h>

@interface YOHAddViewController () <UITextViewDelegate>
@property (nonatomic, strong) UITextView *titleTextView;
@property (nonatomic, strong) UITextView *descriptionTextView;
@property (nonatomic, strong) UITextView *linkTextView;
@end

@implementation YOHAddViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveNewItem)];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    UIBarButtonItem *title = [[UIBarButtonItem alloc] initWithTitle:self.title
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:NULL];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:self
                                                                           action:NULL];
    
    UIView *coverStatusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    coverStatusBarView.backgroundColor = [UIColor colorWithRed:32/255.0 green:32/255.0 blue:32/255.0 alpha:1.0];
    [self.view addSubview:coverStatusBarView];
    
    [toolbar setItems:[NSArray arrayWithObjects:cancelItem, space, title, space, addItem, nil]];
    toolbar.tintColor = [UIColor colorWithRed:247/255.0 green:141/255.0 blue:3/255.0 alpha:1.0];
    toolbar.barTintColor = [UIColor blackColor];
    [self.view addSubview:toolbar];
    
    self.titleTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 64, self.view.frame.size.width - 40, 50)];
    self.titleTextView.text = @"what did you learn today?";
    self.titleTextView.textColor = [UIColor lightGrayColor];
    self.titleTextView.font = [UIFont fontWithName:@"Kailasa-Bold" size:18.0];
    self.titleTextView.delegate = self;
    [self.view addSubview:self.titleTextView];
    
    self.descriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(self.titleTextView.frame.origin.x, self.titleTextView.frame.size.height + self.titleTextView.frame.origin.y + 10, self.titleTextView.frame.size.width, 100)];
    self.descriptionTextView.text = @"add a bit more elaboration";
    self.descriptionTextView.textColor = [UIColor lightGrayColor];
    self.descriptionTextView.font = [UIFont fontWithName:@"Kailasa" size:18.0];
    self.descriptionTextView.delegate = self;
    [self.view addSubview:self.descriptionTextView];
    
    self.linkTextView = [[UITextView alloc] initWithFrame:CGRectMake(self.titleTextView.frame.origin.x, self.descriptionTextView.frame.origin.y + self.descriptionTextView.frame.size.height + 10, self.titleTextView.frame.size.width, 50)];
    self.linkTextView.text = @"attach a link";
    self.linkTextView.textColor = [UIColor lightGrayColor];
    self.linkTextView.font = [UIFont fontWithName:@"Kailasa" size:18.0];
    self.linkTextView.delegate = self;
    [self.view addSubview:self.linkTextView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.titleTextView.text = self.itemTitle ? self.itemTitle :  self.titleTextView.text;
    self.titleTextView.hidden = NO;
    self.descriptionTextView.text = self.description ? self.description : self.descriptionTextView.text;
    self.linkTextView.text = self.link ? self.link : self.linkTextView.text;
}

#pragma mark - Updating Info in TextFields
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)saveNewItem
{
    self.itemTitle = self.titleTextView.text;
    self.description = self.descriptionTextView.text;
    self.link = self.linkTextView.text;
    if (self.objectId) {
        PFQuery *query = [PFQuery queryWithClassName:@"Item"];
        [query getObjectInBackgroundWithId:self.objectId block:^(PFObject *object, NSError *error) {
            if (!error) {
                object[@"title"] = self.itemTitle ? self.itemTitle : [NSNull null];
                object[@"description"] = self.description ? self.description : [NSNull null];
                object[@"link"] = self.link ? self.link : [NSNull null];
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        [(YOHHistoryViewController *)self.presentingViewController viewWillAppear:YES];
                    }
                }];
            }
        }];
    } else {
        PFUser *currentUser = [PFUser currentUser];
        PFObject *newItem = [PFObject objectWithClassName:@"Item"];
        newItem[@"title"] = self.itemTitle ? self.itemTitle : [NSNull null];
        newItem[@"description"] = self.description ? self.description : [NSNull null];
        newItem[@"link"] = self.link ? self.link : [NSNull null];
        newItem[@"username"] = currentUser.username;
        
        [newItem saveInBackground];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy";
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    [[NSUserDefaults standardUserDefaults] setValue:[dateFormatter stringFromDate:[NSDate date]] forKey:@"lastDateLearned"];
    [self dismissViewControllerAnimated:YES
                             completion:NULL];
}

#pragma mark - Dealing with Cancel Button
- (void)cancel
{
    [self dismissViewControllerAnimated:YES
                             completion:NULL];
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

@end
