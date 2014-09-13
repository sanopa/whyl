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

@interface YOHAddViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *titleTextView;
@property (nonatomic, strong) UITextField *descriptionTextView;
@property (nonatomic, strong) UITextField *linkTextView;
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
    
    [toolbar setItems:[NSArray arrayWithObjects:cancelItem, space, title, space, addItem, nil]];
    toolbar.tintColor = [UIColor blackColor];
    [self.view addSubview:toolbar];
    
    self.titleTextView = [[UITextField alloc] initWithFrame:CGRectMake(20, 60, self.view.frame.size.width - 40, 50)];
    self.titleTextView.placeholder = @"what did you learn today?";
    self.titleTextView.delegate = self;
    [self.view addSubview:self.titleTextView];
    
    self.descriptionTextView = [[UITextField alloc] initWithFrame:CGRectMake(self.titleTextView.frame.origin.x, self.titleTextView.frame.size.height + self.titleTextView.frame.origin.y + 10, self.titleTextView.frame.size.width, 100)];
    self.descriptionTextView.placeholder = @"add a bit more elaboration";
    self.descriptionTextView.delegate = self;
    [self.view addSubview:self.descriptionTextView];
    
    self.linkTextView = [[UITextField alloc] initWithFrame:CGRectMake(self.titleTextView.frame.origin.x, self.descriptionTextView.frame.origin.y + self.descriptionTextView.frame.size.height + 10, self.titleTextView.frame.size.width, 50)];
    self.linkTextView.placeholder = @"attach a link";
    self.linkTextView.delegate = self;
    [self.view addSubview:self.linkTextView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.titleTextView.text = self.itemTitle ? self.itemTitle : nil;
    self.descriptionTextView.text = self.description ? self.description : nil;
    self.linkTextView.text = self.link ? self.link : nil;
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
