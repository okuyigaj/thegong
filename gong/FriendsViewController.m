//
//  FriendsViewController.m
//  gong
//
//  Created by Matthew Young on 07/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FriendsViewController.h"

@implementation FriendsViewController

@synthesize requestsButton, backButton, addFriendButton, friendsTableView, updatingFriendsView, requestsTableView;
@synthesize requestsResultsController = _requestsResultsController, allFriendsResultsController = _allFriendsResultsController, activeResultsController, activeTableView;
@synthesize managedObjectContext = _managedObjectContext, serverComms;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)backToMainView {
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)requestsButtonPressed {
  if (self.activeTableView == self.friendsTableView) {
    self.activeTableView = self.requestsTableView;
    self.activeResultsController = self.requestsResultsController;
    [self changeTitleForButton:self.requestsButton toString:@"All"];
    self.requestsTableView.hidden = NO;
    self.friendsTableView.hidden = YES;
  } else {
    self.activeTableView = self.friendsTableView;
    self.activeResultsController = self.allFriendsResultsController;
    [self changeTitleForButton:self.requestsButton toString:@"Requests"];
    self.requestsTableView.hidden = YES;
    self.friendsTableView.hidden = NO;
  }
  NSError *error;
  if (![self.activeResultsController performFetch:&error]) {
    NSLog(@"Error performing Fetch");
  } else {
    [self.activeTableView reloadData];
  }
}

- (void)changeTitleForButton:(UIButton *)button toString:(NSString *)string {
  [button setTitle:string forState: UIControlStateNormal];
  [button setTitle:string forState: UIControlStateApplication];
  [button setTitle:string forState: UIControlStateHighlighted];
  [button setTitle:string forState: UIControlStateReserved];
  [button setTitle:string forState: UIControlStateSelected];
  [button setTitle:string forState: UIControlStateDisabled];
}

- (NSManagedObjectContext *)managedObjectContext {
  if (_managedObjectContext == nil) {
    _managedObjectContext = [[DataModel sharedDataModel] createManagedObjectContext];
  }
  
  return _managedObjectContext;
}

- (UITableView *)tableViewForResultsController:(NSFetchedResultsController *)controller {
  if (controller == _allFriendsResultsController) {
    return self.friendsTableView;
  } else {
    return self.requestsTableView;
  }
}

- (NSFetchedResultsController *)resultsControllerForTableView:(UITableView *)tableView {
  if (tableView == self.friendsTableView) {
    return self.allFriendsResultsController;
  } else {
    return self.requestsResultsController;
  }
}


- (NSFetchedResultsController *)allFriendsResultsController {

  if (_allFriendsResultsController == nil) {
  
    NSManagedObjectContext *context = self.managedObjectContext;
  
    NSFetchRequest *fetchRequest = nil;
    fetchRequest = [[NSFetchRequest alloc] init]; NSEntityDescription *entity = nil;
    entity = [NSEntityDescription entityForName:@"Friend" 
              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = nil;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"friendshipId" ascending:YES];
    NSArray *sortDescriptors = nil;
    sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];    
    NSFetchedResultsController *frc = nil;
    frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context
                                              sectionNameKeyPath:@"initial" cacheName:nil];
    frc.delegate = self;
    _allFriendsResultsController = frc;
    
  }

  return _allFriendsResultsController;
}

- (NSFetchedResultsController *)requestsResultsController {

  if (_requestsResultsController == nil) {
  
  
    NSManagedObjectContext *context = self.managedObjectContext;
  
    NSFetchRequest *fetchRequest = nil;
    fetchRequest = [[NSFetchRequest alloc] init]; NSEntityDescription *entity = nil;
    entity = [NSEntityDescription entityForName:@"Friend" 
                         inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    NSSortDescriptor *sortDescriptor = nil;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES];
    NSArray *sortDescriptors = nil;
    sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relationship != 0"];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *frc = nil;
    frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context 
                                              sectionNameKeyPath:@"initial" cacheName:nil];
    frc.delegate = self;
    _requestsResultsController = frc;
    
  }

  return _requestsResultsController;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
  id <NSFetchedResultsSectionInfo> sectionInfo = nil;
  sectionInfo = [[self resultsControllerForTableView:tableView].sections objectAtIndex:section];
  return [sectionInfo numberOfObjects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
  int c = self.allFriendsResultsController.sections.count;
  NSLog(@"Sections: %d", c);
  return c;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
  FriendCell *cell = nil;
  cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
  [self configureCell:cell atIndexPath:indexPath];
  return cell;
}

- (void)configureCell:(FriendCell*)cell atIndexPath:(NSIndexPath*)indexPath {
  Friend *friend = [self.activeResultsController objectAtIndexPath:indexPath];
  
  cell.friendName.text = friend.displayName;
  cell.friendEmailAddress.text = friend.emailAddress;
  cell.friendshipId = friend.friendshipId;
  
  switch (friend.relationship.intValue) {
  case 0:
    //mutual friendship
    cell.friendRequestButton.hidden = YES;
    break;
  case 1:
    //They want to be your friend
    cell.friendRequestButton.hidden = NO;
    cell.friendRequestButton.titleLabel.text = @"Accept";
    break;
  case 2:
    //You want to be their friend
    cell.friendRequestButton.hidden = NO;
    cell.friendRequestButton.titleLabel.text = @"Cancel";
    break;
  }
  
}

- (void)requestButtonPressedForFriendCell:(FriendCell *)cell {
  //Tell the server to update the friendship.
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [[self tableViewForResultsController:controller] beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
 
    UITableView *tableView = [self tableViewForResultsController:controller];
 
    switch(type) {
 
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
 
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
 
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(FriendCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
 
        case NSFetchedResultsChangeMove:
           [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
           [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
           break;
    }
}
 
 
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
 
    UITableView *tableView = [self tableViewForResultsController:controller];
 
    switch(type) {
 
        case NSFetchedResultsChangeInsert:
            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
 
        case NSFetchedResultsChangeDelete:
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}
 
 
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [[self tableViewForResultsController:controller] endUpdates];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  self.activeTableView = self.friendsTableView;
  self.activeResultsController = self.allFriendsResultsController;
}

- (void)viewDidAppear:(BOOL)animated {
  NSError *error;
  if (![self.activeResultsController performFetch:&error]) {
    NSLog(@"Error Fetching Friends");
  } else {
    [self.activeTableView reloadData];
  }
  self.serverComms = [[ServerCommunication alloc] init];
  self.serverComms.delegate = self;
  [self.serverComms getFriendsList];
  //show the loading friends thing.
  [UIView animateWithDuration:0.3f animations:^{
    CGRect f = self.friendsTableView.frame;
    self.requestsTableView.frame = CGRectMake(f.origin.x, 95, f.size.width, 365);
    self.friendsTableView.frame = CGRectMake(f.origin.x, 95, f.size.width, 365);
    self.updatingFriendsView.hidden = NO;
    self.updatingFriendsView.alpha = 1.0f;
  } completion:^(BOOL fin){}];
}

- (void)didDownloadFriendsList:(BOOL)_trueOrFalse withReason:(NSString *)_reason andFriends:(NSArray *)_friends {
  if (_trueOrFalse) {
    NSManagedObjectContext *c = [[DataModel sharedDataModel] createManagedObjectContext];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                      selector:@selector(dataModelChanged:)
                                      name:NSManagedObjectContextDidSaveNotification
                                      object:c];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
      [self updateFriends:_friends inContext:c];
    });
  } else {
    //silently fail
    [self hideUpdatingFriends];
  }
}

- (void)dataModelChanged:(NSNotification *)notification {
  [self.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
}

- (void)hideUpdatingFriends {
  [UIView animateWithDuration:0.3f animations:^{
    CGRect f = self.friendsTableView.frame;
    self.requestsTableView.frame = CGRectMake(f.origin.x, 65, f.size.width, 395);
    self.friendsTableView.frame = CGRectMake(f.origin.x, 65, f.size.width, 395);
    self.updatingFriendsView.alpha = 0.0f;
  } completion:^(BOOL fin){self.updatingFriendsView.hidden = YES;}];
}

- (void)updateFriends:(NSArray *)friends inContext:(NSManagedObjectContext *)context {
  //THIS RUNS ON A DIFFERENT THREAD.
  //ANY UI DONE IN HERE MUST BE DONE ON MAIN_QUEUE.
  
  int i = 0;
  int j = 0;
  
  //get an array of all friends.
  NSFetchRequest *fetchRequest = nil;
  fetchRequest = [[NSFetchRequest alloc] init]; NSEntityDescription *entity = nil;
  entity = [NSEntityDescription entityForName:@"Friend" 
              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = nil;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"friendshipId" ascending:YES];
    NSArray *sortDescriptors = nil;
    sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
  
  NSError *error = nil;
  NSArray *oldFriends = [context executeFetchRequest:fetchRequest error:&error];
  
  if (error != nil) {
    NSLog(@"Error getting existing Friends");
    return;
  }
  
  //BOTH ARRAYS ARE SORTED BY FRIENDSHIP_ID IN ASCENDING ORDER.
  //CAN WALK ALONG THE ARRAYS, UPDATING / DELETING / INSERTING AS WE GO.
  
  Friend *oldFriend, *f;
  NSDictionary *newFriend;
  NSComparisonResult comparisonResult = NSOrderedSame;
  
  while (i < friends.count || j < oldFriends.count) {

    if (i < friends.count) {
      newFriend = [friends objectAtIndex:i];
    } else {
      comparisonResult = NSOrderedDescending;
    }
    
    if (j < oldFriends.count) {
      oldFriend = [oldFriends objectAtIndex:j];
    } else {
      comparisonResult = NSOrderedAscending;
    }
    
    if (i < friends.count && j < oldFriends.count) {
      comparisonResult = [[newFriend objectForKey:@"friendship_id"] compare:oldFriend.friendshipId options:0];
    }

    switch (comparisonResult) {
    
    case NSOrderedAscending:
      //INSERT NEW FRIEND
      f = [NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:context];
      f.displayName = [newFriend objectForKey:@"username"];
      f.emailAddress = [newFriend objectForKey:@"email"];
      f.userId = [newFriend objectForKey:@"id"];
      f.friendshipId = [newFriend objectForKey:@"friendship_id"];
      if ([[newFriend objectForKey:@"verified"] isEqualToString:@"yes"]) {
        f.relationship = [NSNumber numberWithInt:0];
      } else {
        if ([[newFriend objectForKey:@"userOwned"] isEqualToString:@"yes"]) {
          f.relationship = [NSNumber numberWithInt:2];
        } else {
          f.relationship = [NSNumber numberWithInt:1];
        }
      }
      if (![context save:&error]) {NSLog(@"Error Inserting Friend:%@", f.displayName);}
      NSLog(@"Inserted new Friend:%@", f.displayName);
      i = i + 1;
      break;
    case NSOrderedDescending:
      //DELETE OLD FRIEND
      [context deleteObject:oldFriend];
      if (![context save:&error]) {NSLog(@"Error Deleting Friend:%@", oldFriend.displayName);}
      NSLog(@"Deleted Old Friend:%@", oldFriend.displayName);
      j = j + 1;
      break;
    case NSOrderedSame:
      //UPDATE EXISTING FRIEND
      oldFriend.displayName = [newFriend objectForKey:@"username"];
      oldFriend.emailAddress = [newFriend objectForKey:@"email"];
      if ([[newFriend objectForKey:@"verified"] isEqualToString:@"yes"]) {
        oldFriend.relationship = [NSNumber numberWithInt:0];
      }
      if (![context save:&error]) {NSLog(@"Error Updating Friend:%@", oldFriend.displayName);}
      NSLog(@"Updated Existing Friend:%@", oldFriend.displayName);
      j = j + 1; i = i + 1;
      break;
    } 
          
  }
  //NOW WE'RE DONE. UI SHOULD HAVE AUTOMAGICALLY BEEN UPDATED.
  dispatch_async(dispatch_get_main_queue(), ^{
    [self hideUpdatingFriends];
  });
}


- (void)viewWillDisappear:(BOOL)animated {
  [serverComms cancelCurrentTask];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
