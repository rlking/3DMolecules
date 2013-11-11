//
//  ListAminoAcidsController.m
//  3DMolecules
//
//  Created by Philipp König on 11.11.13.
//  Copyright (c) 2013 Philipp König. All rights reserved.
//

#import "ListAminoAcidsController.h"
#import "AminoAcidController.h"

@interface ListAminoAcidsController ()

@property (strong, nonatomic) NSMutableArray *menuItems;

@end

@implementation ListAminoAcidsController

@synthesize menuItems;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    NSArray *resourcesList = [[NSBundle mainBundle] pathsForResourcesOfType:@".mol" inDirectory:@"amino_acids"];
    menuItems = [NSMutableArray array];
    for(NSString *path in resourcesList){
        NSArray *splitPath = [path componentsSeparatedByString:@"/"];
        [menuItems addObject:[splitPath lastObject]];
    }
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
    return menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [menuItems objectAtIndex:indexPath.row];
    return cell;
}

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    
    AminoAcidController *acidVC;
    
    acidVC = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"AminoAcidController"];
    
    NSArray *resourcesList = [[NSBundle mainBundle] pathsForResourcesOfType:@".mol" inDirectory:@"amino_acids"];
    [acidVC loadMoleculeFromPath:[resourcesList objectAtIndex:indexPath.row]];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:acidVC animated:YES];
}

@end
