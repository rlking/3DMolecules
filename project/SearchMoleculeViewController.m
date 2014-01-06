//
//  SearchMoleculeViewController.m
//  3DMolecules
//
//  Created by Philipp König on 05.01.14.
//  Copyright (c) 2014 Philipp König. All rights reserved.
//

#import "SearchMoleculeViewController.h"
#import "MoleculeViewController.h"

@interface SearchMoleculeViewController () {
    NSMutableArray *tableData;
    
}

@property (strong, nonatomic) MoleculeViewController *childViewController;

@end

@implementation SearchMoleculeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSArray *resourcesList = [[NSBundle mainBundle] pathsForResourcesOfType:@".mol" inDirectory:nil];
    tableData = [NSMutableArray array];
    for(NSString *path in resourcesList){
        NSArray *splitPath = [path componentsSeparatedByString:@"/"];
        [tableData addObject:[splitPath lastObject]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"FooB"]) {
        _childViewController = (MoleculeViewController *) [segue destinationViewController];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *resourcesList = [[NSBundle mainBundle] pathsForResourcesOfType:@".mol" inDirectory:nil];
    [_childViewController loadMoleculeFromPath:[resourcesList objectAtIndex:indexPath.row]];
}

@end
