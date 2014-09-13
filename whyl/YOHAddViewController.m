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

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) UIImage *image;
@end

@implementation YOHAddViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveNewItem)];
        self.navigationItem.rightBarButtonItem = addItem;
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
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

#pragma mark - Updating Info in TextFields
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)saveNewItem
{
    self.title = self.titleTextView.text;
    self.description = self.descriptionTextView.text;
    self.link = self.linkTextView.text;
    self.image = self.imageView.image;

    PFUser *currentUser = [PFUser currentUser];
    PFObject *newItem = [PFObject objectWithClassName:@"Item"];
    newItem[@"title"] = self.title ? self.title : [NSNull null];
    newItem[@"description"] = self.description ? self.description : [NSNull null];
    newItem[@"link"] = self.link ? self.link : [NSNull null];
    newItem[@"photo"] = self.image ? UIImagePNGRepresentation(self.image) : [NSNull null];
    newItem[@"username"] = currentUser.username;
    
    [newItem saveInBackground];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
