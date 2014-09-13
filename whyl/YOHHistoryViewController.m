//
//  YOHHistoryViewController.m
//  whyl
//
//  Created by Sophia Anopa on 12.09.14.
//  Copyright (c) 2014 Aiiyoh. All rights reserved.
//

#import "YOHHistoryViewController.h"
#import "YOHHistoryTableViewCell.h"

#import "YOHAddViewController.h"

#import <Parse/Parse.h>

@interface YOHHistoryViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *items;
@end

@implementation YOHHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 20) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[YOHHistoryTableViewCell class] forCellReuseIdentifier:@"YOHHistoryTableViewCell"];
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    PFQuery *query = [PFQuery queryWithClassName:@"Item"];
    [query whereKey:@"username" equalTo:[PFUser currentUser].username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"%@", objects);
            self.items = objects;
            [self.tableView reloadData];
        } else {
            NSLog(@"Fetching items failed");
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YOHHistoryTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"YOHHistoryTableViewCell"];
    NSDictionary *item = self.items[indexPath.row];
    cell.title.text = item[@"title"];
    cell.description.text = item[@"description"];
    cell.date.text = [((PFObject *)item).updatedAt description];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YOHAddViewController *addViewController = [[YOHAddViewController alloc] init];
    NSDictionary *item = self.items[indexPath.row];
    addViewController.link = item[@"link"];
    addViewController.itemTitle = item[@"title"];
    addViewController.description = item[@"description"];
    addViewController.objectId = ((PFObject *)item).objectId;
    self.navigationController.navigationBarHidden = false;
    [self presentViewController:addViewController
                       animated:YES
                     completion:NULL];
}

@end
