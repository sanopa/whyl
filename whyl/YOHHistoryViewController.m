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

@interface YOHHistoryViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSTimer *searchDelay;
@end

@implementation YOHHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"History";
        UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                    target:self
                                                                                    action:@selector(searchHistory)];
        self.navigationItem.rightBarButtonItem = searchItem;
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
    if ([self.searchBar.text isEqualToString:@""]) {
        PFQuery *query = [PFQuery queryWithClassName:@"Item"];
        [query whereKey:@"username" equalTo:[PFUser currentUser].username];
        [query orderByDescending:@"createdAt"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                NSLog(@"%@", objects);
                self.items = objects;
                [self.tableView reloadData];
            } else {
                NSLog(@"Fetching items failed");
            }
        }];

    } else {
        NSString *searchString = self.searchBar.text;
        PFQuery *prefixQuery = [PFQuery queryWithClassName:@"Item"];
        [prefixQuery whereKey:@"title" hasPrefix:searchString];
        [prefixQuery whereKey:@"username" equalTo:[PFUser currentUser].username];
        
        PFQuery *middleQuery = [PFQuery queryWithClassName:@"Item"];
        [middleQuery whereKey:@"title" containsString:[NSString stringWithFormat:@" %@", searchString]];
        [middleQuery whereKey:@"username" equalTo:[PFUser currentUser].username];
        
        PFQuery *query = [PFQuery orQueryWithSubqueries:@[prefixQuery, middleQuery]];
        [query orderByDescending:@"createdAt"];
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
    cell.date.text = [((PFObject *)item).createdAt description];
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
    addViewController.title = @"Edit";
    self.navigationController.navigationBarHidden = false;
    [self presentViewController:addViewController
                       animated:YES
                     completion:NULL];
}

- (void)searchHistory
{
    if (!self.searchBar) {
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44)];
        self.tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 44);
        [self.view addSubview:self.searchBar];
        self.searchBar.delegate = self;
    } else {
        [self.searchBar removeFromSuperview];
        self.searchBar = nil;
        self.tableView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.searchDelay invalidate];
    self.searchDelay = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(displaySearch) userInfo:nil repeats:NO];
}

-(void)displaySearch
{
    if ([self.searchBar.text isEqualToString:@""]) {
        PFQuery *query = [PFQuery queryWithClassName:@"Item"];
        [query whereKey:@"username" equalTo:[PFUser currentUser].username];
        [query orderByDescending:@"createdAt"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                NSLog(@"%@", objects);
                self.items = objects;
                [self.tableView reloadData];
            } else {
                NSLog(@"Fetching items failed");
            }
        }];
    } else {
        NSString *searchString = self.searchBar.text;
        PFQuery *prefixQuery = [PFQuery queryWithClassName:@"Item"];
        [prefixQuery whereKey:@"title" hasPrefix:searchString];
        [prefixQuery whereKey:@"username" equalTo:[PFUser currentUser].username];
        
        PFQuery *middleQuery = [PFQuery queryWithClassName:@"Item"];
        [middleQuery whereKey:@"title" containsString:[NSString stringWithFormat:@" %@", searchString]];
        [middleQuery whereKey:@"username" equalTo:[PFUser currentUser].username];

        PFQuery *query = [PFQuery orQueryWithSubqueries:@[prefixQuery, middleQuery]];
        [query orderByDescending:@"createdAt"];
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
}

@end
