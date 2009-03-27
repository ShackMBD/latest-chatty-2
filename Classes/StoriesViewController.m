//
//  RootViewController.m
//  LatestChatty2
//
//  Created by Alex Wayne on 3/16/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "StoriesViewController.h"
#import "LatestChatty2AppDelegate.h"


@implementation StoriesViewController

@synthesize stories;

- (id)init {
  [super initWithNibName:@"StoriesViewController" bundle:nil];
  self.title = @"Stories";
  return self;
}

- (id)initWithStateDictionary:(NSDictionary *)dictionary {
  [self init];
  self.stories = [dictionary objectForKey:@"stories"];
  return self;
}

- (NSDictionary *)stateDictionary {
  return [NSDictionary dictionaryWithObjectsAndKeys:@"Stories", @"type",
                                                    stories, @"stories", nil];
}


- (void)viewDidLoad {
  [super viewDidLoad];
  
  if (stories == nil) [self refresh:self];
  
  UIBarButtonItem *latestChattyButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ChatIcon.24.png"]
                                                                         style:UIBarButtonItemStyleDone
                                                                        target:self
                                                                        action:@selector(tappedLatestChattyButton)];
  self.navigationItem.rightBarButtonItem = latestChattyButton;
  [latestChattyButton release];
  
  UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SettingsIcon.24.png"]
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(tappedSettingsButton)];
  self.navigationItem.leftBarButtonItem = settingsButton;
  [settingsButton release];
}

- (IBAction)refresh:(id)sender {
  [super refresh:sender];
  loader = [[Story findAllWithDelegate:self] retain];
}


- (void)didFinishLoadingAllModels:(NSArray *)models otherData:(id)otherData {
  self.stories = models;
  [loader release];
  loader = nil;
  [super didFinishLoadingAllModels:models otherData:otherData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
  // Release anything that's not essential, such as cached data
}

#pragma mark Shake Handler

// FIXME: This never gets called
//- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
//  NSLog(@"Shook!");
//  if (motion == UIEventSubtypeMotionShake) [self refresh:self];
//}

#pragma mark Table view methods

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSInteger count = 0;
  if (self.stories) count = [self.stories count];
  return count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"StoryCell";
  
  StoryCell *cell = (StoryCell *)[aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[StoryCell alloc] init] autorelease];
    [cell.chattyButton addTarget:self action:@selector(tappedChattyButton:) forControlEvents:UIControlEventTouchUpInside];
  }
  
  // Set the story
  cell.story = [stories objectAtIndex:indexPath.row];

  return (UITableViewCell *)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [StoryCell cellHeight];
}


#pragma mark Actions

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Story *story = [stories objectAtIndex:indexPath.row];
  StoryViewController *viewController = [[StoryViewController alloc] initWithStory:story];
  [self.navigationController pushViewController:viewController animated:YES];
  [viewController release];
}

- (IBAction)tappedChattyButton:(id)sender {
  NSIndexPath *indexPath;
  for (StoryCell *cell in [self.tableView visibleCells]) {
    if (cell.chattyButton == sender)
      indexPath = [self.tableView indexPathForCell:cell];
  }
  
  Story *story = [stories objectAtIndex:indexPath.row];
  ChattyViewController *viewController = [[ChattyViewController alloc] initWithStoryId:story.modelId];
  [self.navigationController pushViewController:viewController animated:YES];
  [viewController release];
}

- (IBAction)tappedLatestChattyButton {
  ChattyViewController *viewController = [[ChattyViewController alloc] initWithLatestChatty];
  [self.navigationController pushViewController:viewController animated:YES];
  [viewController release];
}

- (IBAction)tappedSettingsButton {
  SettingsViewController *viewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
  [self.navigationController presentModalViewController:viewController animated:YES];
  [viewController release];
}


- (void)dealloc {
  self.stories = nil;
  [super dealloc];
}


@end
