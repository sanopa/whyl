//
//  YOHSettingsTableViewController.m
//  whyl
//
//  Created by Ruoxi Tan on 9/13/14.
//  Copyright (c) 2014 Aiiyoh. All rights reserved.
//

#import "YOHSettingsTableViewController.h"

@interface YOHSettingsTableViewController ()

@property (nonatomic) BOOL showingPicker;
@property (nonatomic) BOOL switchIsOn;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSDate *timeChosen;
@property (nonatomic, strong) NSDateFormatter *timeFormatter;
@property (nonatomic, strong) UISwitch *switchControl;
@end

@implementation YOHSettingsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _showingPicker = NO;
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        timeFormatter.dateFormat = @"hh:mm a";
        timeFormatter.timeZone = [NSTimeZone defaultTimeZone];
        _timeFormatter = timeFormatter;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.showingPicker == NO) return 1;
    else return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Reminders";
        UISwitch *switchControl = [[UISwitch alloc] init];
        switchControl.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 8 - switchControl.frame.size.width, 8, switchControl.frame.size.width, switchControl.frame.size.height);
        [switchControl addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"timeOfAlert"] == nil) {
            switchControl.on = NO;
        } else {
            switchControl.on = YES;
        }
        [cell.contentView addSubview:switchControl];
        self.switchControl = switchControl;
    } else {
        if ([cell viewWithTag:15251] == nil) {
            UIDatePicker *datePicker = [[UIDatePicker alloc] init];
            datePicker.datePickerMode = UIDatePickerModeTime;
            datePicker.tag = 15251;
            self.datePicker = datePicker;
            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"timeOfAlert"] == nil) {
                datePicker.date = [NSDate date];
            } else {
                NSDateFormatter *todayFormatter = [[NSDateFormatter alloc] init];
                todayFormatter.dateFormat = @"MM/dd/yyyy";
                todayFormatter.timeZone = [NSTimeZone defaultTimeZone];
                NSString *today = [todayFormatter stringFromDate:[NSDate date]];
                NSString *combinedDate = [NSString stringWithFormat:@"%@ %@", today, [[NSUserDefaults standardUserDefaults] valueForKey:@"timeOfAlert"]];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"MM/dd/yyyy hh:mm a";
                dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
                NSDate *pickerDate = [dateFormatter dateFromString:combinedDate];
                datePicker.date = pickerDate;
            }
            [datePicker addTarget:self action:@selector(dateEditingBegin:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:datePicker];
        }
    }
    
    return cell;
}

-(void)switchChanged:(UISwitch *)switchControl
{
    if (switchControl.on == YES) {
        self.showingPicker = YES;
        [self.tableView reloadData];
    } else {
        self.showingPicker = NO;
        [self.tableView reloadData];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 44;
    } else {
        return 216;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0 && self.switchControl.on == YES) {
        if (self.showingPicker == NO) {
            self.showingPicker = YES;
        } else {
            self.showingPicker = NO;
        }
        [self.tableView reloadData];
    }
}

-(void)dateEditingBegin:(UIDatePicker *)datePicker
{
        self.timeChosen = datePicker.date;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.switchControl.on == YES) {
        if (self.timeChosen) {
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.repeatInterval = NSDayCalendarUnit;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"MM/dd/yyyy hh:mm a";
            dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
            
            NSDateFormatter *todayFormatter = [[NSDateFormatter alloc] init];
            todayFormatter.dateFormat = @"MM/dd/yyyy";
            todayFormatter.timeZone = [NSTimeZone defaultTimeZone];
            NSString *today = [todayFormatter stringFromDate:[NSDate date]];
            
            NSString *time = [self.timeFormatter stringFromDate:self.timeChosen];
            NSString *combinedDate =[NSString stringWithFormat:@"%@ %@", today, time];
            NSDate *date = [dateFormatter dateFromString:combinedDate];
            notification.timeZone = [NSTimeZone defaultTimeZone];
            notification.fireDate = date;
            NSLog(@"%@", notification.fireDate);
            
            notification.alertBody = @"Record what you learned today!";
            
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            NSLog(@"%@", [self.timeFormatter stringFromDate:self.timeChosen]);
            [[NSUserDefaults standardUserDefaults] setValue:[self.timeFormatter stringFromDate:self.timeChosen] forKey:@"timeOfAlert"];
        }
    } else {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"timeOfAlert"];
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
