//
//  YOHAddViewController.m
//  whyl
//
//  Created by Sophia Anopa on 12.09.14.
//  Copyright (c) 2014 Aiiyoh. All rights reserved.
//

#import "YOHAddViewController.h"

#import <Parse/Parse.h>

@interface YOHAddViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *titleTextView;
@property (nonatomic, strong) UITextField *descriptionTextView;
@property (nonatomic, strong) UITextField *linkTextView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImage *image;
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
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveNewItem)];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil action:NULL];
    
    [toolbar setItems:[NSArray arrayWithObjects:cancelItem, space, addItem, nil]];
    [self.view addSubview:toolbar];
    
    self.titleTextView = [[UITextField alloc] initWithFrame:CGRectMake(50, 50, self.view.frame.size.width - 100, 50)];
    self.titleTextView.placeholder = @"Put in your title here";
    self.titleTextView.delegate = self;
    [self.view addSubview:self.titleTextView];
    
    self.descriptionTextView = [[UITextField alloc] initWithFrame:CGRectMake(50, 100, self.view.frame.size.width - 100, 100)];
    self.descriptionTextView.placeholder = @"Add some more thoughts";
    self.descriptionTextView.delegate = self;
    [self.view addSubview:self.descriptionTextView];
    
    self.linkTextView = [[UITextField alloc] initWithFrame:CGRectMake(50, 200, self.view.frame.size.width - 100, 50)];
    self.linkTextView.placeholder = @"Put in a link";
    self.linkTextView.delegate = self;
    [self.view addSubview:self.linkTextView];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 300, self.view.frame.size.width - 100, 100)];
    [self.view addSubview:self.imageView];
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
    self.image = self.imageView.image;

    PFUser *currentUser = [PFUser currentUser];
    PFObject *newItem = [PFObject objectWithClassName:@"Item"];
    newItem[@"title"] = self.itemTitle ? self.itemTitle : [NSNull null];
    newItem[@"description"] = self.description ? self.description : [NSNull null];
    newItem[@"link"] = self.link ? self.link : [NSNull null];
    newItem[@"photo"] = self.image ? UIImagePNGRepresentation(self.image) : [NSNull null];
    newItem[@"username"] = currentUser.username;
    
    [newItem saveInBackground];
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
