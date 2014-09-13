//
//  YOHLearnViewController.m
//  whyl
//
//  Created by Sophia Anopa on 12.09.14.
//  Copyright (c) 2014 Aiiyoh. All rights reserved.
//

#import "YOHLearnViewController.h"
#import "YOHLearnTableViewCell.h"
#import "YOHAddViewController.h"
#import "YOHPreviewViewController.h"

@interface YOHLearnViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (copy, nonatomic) NSArray *posts;
@property (nonatomic) NSInteger *viewed;

@end

@implementation YOHLearnViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _viewed = calloc(3, sizeof(bool));
        
        self.title = @"Learn";
        UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(refreshData)];
        self.navigationItem.rightBarButtonItem = refreshItem;
    }
    return self;
}

-(void)loadView
{
    self.view = [[UIView alloc] init];
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    [self.tableView registerClass:[YOHLearnTableViewCell class] forCellReuseIdentifier:@"YOHLearnTableViewCell"];

    UILabel *footerText = [[UILabel alloc] initWithFrame:CGRectMake(0, self.tableView.frame.size.height - 14.0, self.tableView.frame.size.width, 14.0)];
    footerText.text = @"Content provided by the Reddit API.";
    footerText.textAlignment = NSTextAlignmentCenter;
    footerText.font = [UIFont fontWithName:@"Kailasa" size:13.0];
    footerText.textColor = [UIColor lightGrayColor];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:footerText];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YOHLearnTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"YOHLearnTableViewCell" forIndexPath:indexPath];
    cell.titleLabel.text = self.posts[indexPath.row][@"title"];
    cell.addToHistoryButton.tag = indexPath.row;
    [cell.addToHistoryButton addTarget:self action:@selector(addToHistory:) forControlEvents:UIControlEventTouchUpInside];
    if (self.viewed[indexPath.row] == true) {
        cell.addToHistoryButton.hidden = NO;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    YOHPostViewController *postViewController = [[YOHPostViewController alloc] init];
    self.viewed[indexPath.row] = true;
//    postViewController.url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.reddit.com%@",self.posts[indexPath.row][@"permalink"]]];
//    [self.navigationController pushViewController:postViewController animated:YES];
    YOHPreviewViewController *previewViewController = [[YOHPreviewViewController alloc] init];
    previewViewController.objectDict = self.posts[indexPath.row];
    [self.navigationController pushViewController:previewViewController animated:YES];
    NSLog(@"%@", self.posts[indexPath.row]);
    [tableView reloadData];
}

-(void)addToHistory:(UIButton *)button
{
    NSInteger index = button.tag;
    YOHAddViewController *addViewController = [[YOHAddViewController alloc] init];
    addViewController.description = self.posts[index][@"title"];
    addViewController.link = [NSString stringWithFormat:@"http://www.reddit.com%@",self.posts[index][@"permalink"]];
    addViewController.title = @"Add";
    [self presentViewController:addViewController animated:YES completion:nil];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURLRequest *redditRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.reddit.com/r/todayilearned/hot.json?limit=4"]];
    [NSURLConnection sendAsynchronousRequest:redditRequest queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"%@",connectionError.localizedDescription);
        } else {
            NSError* error;
            NSDictionary* json = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:kNilOptions
                                  error:&error];
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            } else {
                self.posts =  [[(NSArray *)json[@"data"][@"children"] subarrayWithRange:NSMakeRange(1, 3)] valueForKey:@"data"] ;
                [self.tableView reloadData];
            }
        }
    }];
}

- (void)refreshData
{
    NSString *lastID = self.posts[[self.posts count]-1][@"id"];
    NSURLRequest *redditRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.reddit.com/r/todayilearned/hot.json?after=t3_%@&limit=3", lastID]]];
    [NSURLConnection sendAsynchronousRequest:redditRequest queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"%@",connectionError.localizedDescription);
        } else {
            NSError* error;
            NSDictionary* json = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:kNilOptions
                                  error:&error];
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            } else {
                self.posts = [(NSArray *)json[@"data"][@"children"] valueForKey:@"data"];
                [self.tableView reloadData];
            }
        }
    }];
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
