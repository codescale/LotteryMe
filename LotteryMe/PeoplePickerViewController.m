//
//  PeoplePickerViewController.m
//  LotteryMe
//
//  Created by Matthias Kappeller on 27.06.12.
//  Copyright (c) 2012 CodeScale. All rights reserved.
//

#import "PeoplePickerViewController.h"

@interface PeoplePickerViewController ()
@property (readonly) NSCountedSet *selectedPeople;
@property BasicLotteryViewController *nextController;
@end

@implementation PeoplePickerViewController

@synthesize tableView = _tableView;
@synthesize playBtn = _playBtn;
@synthesize popoverView = _popupView;
@synthesize nextController = _nextController;
@synthesize selectedPeople = _selectedPeople;

- (id)initWithNextController:(BasicLotteryViewController*) nextController {
    self = [self initWithStyle:UITableViewStylePlain];
    self.nextController = nextController;
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithNibName:@"PeoplePickerViewController" bundle:nil];
    if (self) {
        _selectedPeople = [[NSCountedSet alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    // display the edit button
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.editButtonItem.action = @selector(enterEditMode);
    
    self.navigationItem.title = @"Choose Player";
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setPlayBtn:nil];
    [self setTableView:nil];
    [self setPopoverView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table edit
// Finished with edit mode, so restore the buttons and commit changes
-(void)leaveEditMode
{
    // Add the edit button
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView setEditing:NO animated:YES];
}

// Handle deletion requests
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *playerName = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    [PlayerList.instance removePlayer:playerName];
    [tableView reloadData];
}

// Enter edit mode by changing "Edit" to "Done"
-(void)enterEditMode {
    // Add the done button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(leaveEditMode)];
    [self.tableView setEditing:YES animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[PlayerList.instance getPlayer] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...    
    NSArray *player = [PlayerList.instance getPlayer];
    NSString *firstName = [player objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", firstName];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // if the popover view was shown, don't select anything and hide the popover
    if(self.popoverView.alpha == 1.0f) {
        [self displayPopoverView:NO];
        return;
    }
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(selectedCell.accessoryType == UITableViewCellAccessoryCheckmark){
        
        // This cell gets deselected
        selectedCell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectedPeople removeObject:selectedCell.textLabel.text];
    } else {
        
        // This cell get selected
        int maxAmountPlayer = [self.nextController maxAmoutOfPlayer];
        if(self.selectedPeople.count >= maxAmountPlayer) {
            
            // Reached the maximum of attendees
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Too many player" message:[NSString stringWithFormat:@"The lottery game you selected doesn't support more than %d participants.", maxAmountPlayer] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else {
            
            // mark this cell checked
            selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self.selectedPeople addObject:selectedCell.textLabel.text];
        }
    }
}

# pragma mark - Button

- (IBAction)play:(UIBarButtonItem *)sender {
    if(self.selectedPeople.count < 2) {
        // At least two participants need to be selected!
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not enough player" message:@"You need at least two participants." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self.nextController setPlayer:self.selectedPeople.allObjects];
    [self.navigationController pushViewController:self.nextController animated:YES];
}

- (IBAction)addPlayer:(UIBarButtonItem *)sender {
    // show the popover view
    [self displayPopoverView:YES];
}

- (IBAction)addPlayerFromAddrsbook:(UIButton *)sender {
    
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [picker setDelegate:self];
    [picker setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentModalViewController:picker animated:YES];
}

- (IBAction)addPlayerManual:(UIButton *)sender {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Input" message:@"Enter the name of the new player:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeDefault;
    alertTextField.placeholder = @"Name";
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{ 
    if(buttonIndex == 1) {
        NSString *playerName = [[alertView textFieldAtIndex:0] text];
        if([playerName length] > 0) {
            [PlayerList.instance addPlayer:playerName];
            [self.tableView reloadData];
        }
    }
    
    [self displayPopoverView:NO];
}

- (void) displayPopoverView:(BOOL)doDisplay {
    
    [UIView beginAnimations:@"popoverView" context:nil];
    if(doDisplay)
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    else
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.5f];
    
    if(doDisplay) {
        self.popoverView.alpha = 1.0f;
    } else {
        self.popoverView.alpha = 0.0f;
    }
    
    [UIView commitAnimations];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // if the user tabs anywhere in the screen hide the popover view
    [self displayPopoverView:NO];
}

# pragma mark - Addressbook picker


// Called after the user has pressed cancel
// The delegate is responsible for dismissing the peoplePicker
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissModalViewControllerAnimated:YES];
    [self displayPopoverView:NO];
}

// Called after a person has been selected by the user.
// Return YES if you want the person to be displayed.
// Return NO  to do nothing (the delegate is responsible for dismissing the peoplePicker).
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    CFStringRef firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    [PlayerList.instance addPlayer:[NSString stringWithFormat:@"%@", firstName]];
    CFRelease(firstName);
    
    [self dismissModalViewControllerAnimated:YES];
    [self displayPopoverView:NO];
    [self.tableView reloadData];
    
    return NO;
}

// Called after a value has been selected by the user.
// Return YES if you want default action to be performed.
// Return NO to do nothing (the delegate is responsible for dismissing the peoplePicker).
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

@end
