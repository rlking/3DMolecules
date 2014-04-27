//
//  ListAminoAcidsController.m
//  3DMolecules
//
//  Created by Philipp König on 11.11.13.
//  Copyright (c) 2013 Philipp König. All rights reserved.
//

#import "ListAminoAcidsController.h"
#import "AminoAcidController.h"
#import "AminoAcid.h"

@interface ListAminoAcidsController ()

@property (strong, nonatomic) NSMutableArray *menuItems;
@property (strong, atomic) NSThread *thread;
@property (strong, atomic) NSDictionary *aminoAcids;

@end

@implementation ListAminoAcidsController

@synthesize menuItems;
@synthesize thread;
@synthesize aminoAcids;

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
    
    
//    NSArray *resourcesList = [[NSBundle mainBundle] pathsForResourcesOfType:@".mol" inDirectory:@"amino_acids"];
//    menuItems = [NSMutableArray array];
//    for(NSString *path in resourcesList){
//        NSArray *splitPath = [path componentsSeparatedByString:@"/"];
//        [menuItems addObject:[splitPath lastObject]];
//    }
    
//    menuItems = [NSMutableArray array];
//    for(AminoAcid *acid in [AminoAcid getAminoAcids]) {
//        [menuItems addObject:acid.name];
//    }
    
    //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    thread = [[NSThread alloc] initWithTarget:self selector:@selector(loadAcids) object:nil];
    [thread start];
}

- (void)loadAcids {
    aminoAcids = [AminoAcid getAminoAcids];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[aminoAcids allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[aminoAcids valueForKey:[[[aminoAcids allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[aminoAcids allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return [[[AminoAcid getAminoAcids] allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    AminoAcid *acid = [[aminoAcids valueForKey:[[[aminoAcids allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    //cell.textLabel.text = [menuItems objectAtIndex:indexPath.row];
    cell.textLabel.text = acid.name;
    return cell;
}

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    
    AminoAcidController *acidVC;
    acidVC = [[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"AminoAcidController"];
    
    AminoAcid *acid = [[aminoAcids valueForKey:[[[aminoAcids allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    [acidVC loadMoleculeFromAminoAcid:acid];
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:acidVC animated:YES];
}

@end
