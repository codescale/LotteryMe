//
//  PeoplePickerViewController.h
//  LotteryMe
//
//  Created by Matthias Kappeller on 27.06.12.
//  Copyright (c) 2012 CodeScale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import "BasicLotteryViewController.h"
#import "PlayerList.h"

@interface PeoplePickerViewController : UIViewController <UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,ABPeoplePickerNavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *playBtn;
@property (weak, nonatomic) IBOutlet UIView *popoverView;

- (id)initWithNextController:(BasicLotteryViewController *)nextController;

- (IBAction)play:(UIBarButtonItem *)sender;
- (IBAction)addPlayer:(UIBarButtonItem *)sender;
- (IBAction)addPlayerFromAddrsbook:(UIButton *)sender;
- (IBAction)addPlayerManual:(UIButton *)sender;

@end
