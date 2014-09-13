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
static NSString *placeholderTitle = @"what have you learned today?";
static NSString *placeholderDesc = @"add a bit more elaboration";
static NSString *placeholderLink = @"attach a link";

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
    
    self.titleTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 64, self.view.frame.size.width - 40, 75)];
    self.titleTextView.text = placeholderTitle;
    self.titleTextView.textColor = [UIColor lightGrayColor];
    self.titleTextView.font = [UIFont fontWithName:@"Kailasa-Bold" size:18.0];
    self.titleTextView.delegate = self;
    [self.view addSubview:self.titleTextView];
    
    self.descriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(self.titleTextView.frame.origin.x, self.titleTextView.frame.size.height + self.titleTextView.frame.origin.y + 10, self.titleTextView.frame.size.width, 300)];
    self.descriptionTextView.text = placeholderDesc;
    self.descriptionTextView.textColor = [UIColor lightGrayColor];
    self.descriptionTextView.font = [UIFont fontWithName:@"Kailasa" size:18.0];
    self.descriptionTextView.delegate = self;
    [self.view addSubview:self.descriptionTextView];
    
    self.linkTextView = [[UITextView alloc] initWithFrame:CGRectMake(self.titleTextView.frame.origin.x, self.descriptionTextView.frame.origin.y + self.descriptionTextView.frame.size.height + 10, self.titleTextView.frame.size.width, 50)];
    self.linkTextView.text = placeholderLink;
    self.linkTextView.textColor = [UIColor lightGrayColor];
    self.linkTextView.font = [UIFont fontWithName:@"Kailasa" size:14.0];
    self.linkTextView.delegate = self;
    [self.view addSubview:self.linkTextView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.titleTextView.text = (self.itemTitle && ![self.itemTitle isEqualToString:@""]) ? self.itemTitle :  self.titleTextView.text;
    if (![self.titleTextView.text isEqualToString:placeholderTitle]) self.titleTextView.textColor = [UIColor blackColor];

    self.descriptionTextView.text = (self.description && ![self.description isEqualToString:@""]) ? self.description : self.descriptionTextView.text;
    if (![self.descriptionTextView.text isEqualToString:placeholderDesc]) self.descriptionTextView.textColor = [UIColor blackColor];
    
    self.linkTextView.text = (self.link && ![self.link isEqualToString:@""]) ? self.link : self.linkTextView.text;
    if (![self.linkTextView.text isEqualToString:placeholderLink]) self.linkTextView.textColor = [UIColor blackColor];
}

#pragma mark - Updating Info in TextFields
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)saveNewItem
{
    self.itemTitle = ![self.titleTextView.text isEqualToString:placeholderTitle] ? self.titleTextView.text : nil;
    self.description = ![self.descriptionTextView.text isEqualToString:placeholderDesc] ? self.descriptionTextView.text : nil;
    self.link = ![self.linkTextView.text isEqualToString:placeholderLink] ? self.linkTextView.text : nil;
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
            if (self.itemTitle || self.description || self.link) {
            PFObject *newItem = [PFObject objectWithClassName:@"Item"];
            newItem[@"title"] = self.itemTitle ? self.itemTitle : [NSNull null];
            newItem[@"description"] = self.description ? self.description : [NSNull null];
            newItem[@"link"] = self.link ? self.link : [NSNull null];
            newItem[@"username"] = currentUser.username;
            
            [newItem saveInBackground];
        }
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy";
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    [[NSUserDefaults standardUserDefaults] setValue:[dateFormatter stringFromDate:[NSDate date]] forKey:@"lastDateLearned"];
    [self dismissViewControllerAnimated:YES
                             completion:NULL];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:placeholderTitle]
        || [textView.text isEqualToString:placeholderDesc]
        || [textView.text isEqualToString:placeholderLink])
        textView.text = @"";
    textView.textColor = [UIColor blackColor];
    self.descriptionTextView.frame = CGRectMake(self.titleTextView.frame.origin.x, self.titleTextView.frame.size.height + self.titleTextView.frame.origin.y + 10, self.titleTextView.frame.size.width, 125);
    self.linkTextView.frame = CGRectMake(self.titleTextView.frame.origin.x, self.descriptionTextView.frame.origin.y + self.descriptionTextView.frame.size.height + 10, self.titleTextView.frame.size.width, 50);
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        if (textView == self.titleTextView)
            self.titleTextView.text = placeholderTitle;
        if (textView == self.descriptionTextView)
            self.descriptionTextView.text = placeholderDesc;
        if (textView == self.linkTextView)
            self.linkTextView.text = placeholderLink;
        textView.textColor = [UIColor lightGrayColor];
    }
    self.descriptionTextView.frame = CGRectMake(self.titleTextView.frame.origin.x, self.titleTextView.frame.size.height + self.titleTextView.frame.origin.y + 10, self.titleTextView.frame.size.width, 300);
    self.linkTextView.frame = CGRectMake(self.titleTextView.frame.origin.x, self.descriptionTextView.frame.origin.y + self.descriptionTextView.frame.size.height + 10, self.titleTextView.frame.size.width, 50);
    
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
