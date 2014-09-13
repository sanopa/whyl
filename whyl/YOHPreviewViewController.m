//
//  YOHPreviewViewController.m
//  whyl
//
//  Created by Ruoxi Tan on 9/13/14.
//  Copyright (c) 2014 Aiiyoh. All rights reserved.
//

#import "YOHPreviewViewController.h"

@interface YOHPreviewViewController ()

@end

@implementation YOHPreviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 56, [UIScreen mainScreen].bounds.size.width - 60, 140)];
    titleLabel.numberOfLines = 0;
    titleLabel.text = self.objectDict[@"title"];
    [self.view addSubview:titleLabel];
    UILabel *urlLabel = [[UILabel alloc ]initWithFrame:CGRectMake(30, 200, [UIScreen mainScreen].bounds.size.width - 60, 80)];
    urlLabel.numberOfLines = 0;
    urlLabel.text = self.objectDict[@"url"];
    urlLabel.userInteractionEnabled = YES;
    [self.view addSubview:urlLabel];
    
    UIWebView *webView = [[UIWebView alloc] init]; 
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
