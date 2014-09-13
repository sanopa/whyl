//
//  YOHLearnViewController.m
//  whyl
//
//  Created by Sophia Anopa on 12.09.14.
//  Copyright (c) 2014 Aiiyoh. All rights reserved.
//

#import "YOHLearnViewController.h"
#import "YOHLearnTableViewCell.h"
#import "YOHPostViewController.h"

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
        NSURLRequest *redditRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.reddit.com/r/todayilearned/hot.json?limit=4"]];
        [NSURLConnection sendAsynchronousRequest:redditRequest queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            NSError* error;
            NSDictionary* json = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  
                                  options:kNilOptions 
                                  error:&error];
            self.posts =  [[(NSArray *)json[@"data"][@"children"] subarrayWithRange:NSMakeRange(1, 3)] valueForKey:@"data"] ;
            [self.tableView reloadData];
        }];
        _viewed = calloc(3, sizeof(bool));
    }
    return self;
}

-(void)loadView
{
    self.view = [[UIView alloc] init];
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
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
    YOHLearnTableViewCell *cell = [YOHLearnTableViewCell new];
    cell.titleLabel.text = self.posts[indexPath.row][@"title"];
    if (self.viewed[indexPath.row] == true) {
        cell.addToHistoryButton.hidden = NO;
    }
    NSLog(@"%@", cell.titleLabel.text);
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YOHPostViewController *postViewController = [[YOHPostViewController alloc] init];
    self.viewed[indexPath.row] = true;
    postViewController.url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.reddit.com%@",self.posts[indexPath.row][@"permalink"]]];
    [tableView reloadData];
    [self.navigationController pushViewController:postViewController animated:YES];
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
