//
//  ResultViewController.m
//  LotteryMe
//
//  Created by Matthias Kappeller on 03.07.12.
//  Copyright (c) 2012 CodeScale. All rights reserved.
//

#import "ResultViewController.h"

@interface ResultViewController ()

@end

@implementation ResultViewController

@synthesize result = _result;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] 
                                initWithTitle:@"Home" 
                                style:UIBarButtonItemStyleDone 
                                target:self 
                                action:@selector(pressedBack:)];
    
    self.navigationItem.leftBarButtonItem = backBtn;
}

- (void)viewDidUnload
{
    self.result = nil;
    [super viewDidUnload];
}

- (void) pressedBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.result.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *resultAtIndex = [self.result objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%d. Place - %@", indexPath.row +1, [resultAtIndex valueForKey:KEY_PLAYER]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ points", [resultAtIndex valueForKey:KEY_POINTS]];
    
    return cell;
}

@end
