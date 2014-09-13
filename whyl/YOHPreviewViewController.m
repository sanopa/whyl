//
//  YOHPreviewViewController.m
//  whyl
//
//  Created by Ruoxi Tan on 9/13/14.
//  Copyright (c) 2014 Aiiyoh. All rights reserved.
//

#import "YOHPreviewViewController.h"
#import "YOHPostViewController.h"
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
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 65, [UIScreen mainScreen].bounds.size.width - 60, 205 )];
    titleLabel.numberOfLines = 0;
    titleLabel.text = self.objectDict[@"title"];
    titleLabel.font = [UIFont fontWithName:@"Kailasa" size:15.0];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:titleLabel];

    UIWebView *redditView = [[UIWebView alloc] initWithFrame:CGRectMake(30, 280, [UIScreen mainScreen].bounds.size.width - 60, 125)];
    NSURLRequest *redditRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.reddit.com%@",self.objectDict[@"permalink"]]]];
    [redditView loadRequest:redditRequest];
    redditView.scalesPageToFit = YES;
    redditView.userInteractionEnabled = NO;
    [self.view addSubview: redditView];
    
    UIButton *redditButton = [[UIButton alloc ] initWithFrame:redditView.frame];
    [redditButton addTarget:self action:@selector(viewReddit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:redditButton];
    
    
    if (self.objectDict[@"url"]) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(30, 415, [UIScreen mainScreen].bounds.size.width - 60, 125)];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.objectDict[@"url"]]];
        [webView loadRequest:request];
        webView.scalesPageToFit = YES;
        webView.userInteractionEnabled = NO;
        [self.view addSubview:webView];
    
        UIButton *webButton = [[UIButton alloc ] initWithFrame:webView.frame];
        [webButton addTarget:self action:@selector(viewWebsite) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:webButton];
    }
}

-(void)viewReddit
{
    YOHPostViewController *postvc = [YOHPostViewController new];
    postvc.url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.reddit.com%@",self.objectDict[@"permalink"]]];
    [self.navigationController pushViewController:postvc animated:YES];
}

-(void)viewWebsite
{
    YOHPostViewController *postvc = [YOHPostViewController new];
    postvc.url = [NSURL URLWithString:self.objectDict[@"url"]];
    [self.navigationController pushViewController:postvc animated:YES];
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
