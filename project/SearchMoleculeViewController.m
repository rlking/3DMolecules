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
    NSMutableArray *filtered ;
    UITableView *autoCompleteTable;
    
}

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) MoleculeViewController *childViewController;

@end

@implementation SearchMoleculeViewController

@synthesize textField;

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
    
    filtered = [NSMutableArray array];
    [filtered addObjectsFromArray:tableData];
    
    // Add a "textFieldDidChange" notification method to the text field control.
    [textField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [filtered count];
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
    
    cell.textLabel.text = [filtered objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //remove keyboard
    [self.view endEditing:YES];
    //remove drop down
    [autoCompleteTable setHidden:YES];
    NSArray *resourcesList = [[NSBundle mainBundle] pathsForResourcesOfType:@".mol" inDirectory:nil];
    
    NSString *molPath;
    for (NSString *item in resourcesList) {
        if([item rangeOfString:[filtered objectAtIndex:indexPath.row]].location != NSNotFound) {
            molPath = item;
            break;
        }
    }
    
    [_childViewController loadMoleculeFromPath:molPath];
}

- (void)textFieldDidChange {
    [filtered removeAllObjects];
    if([textField.text isEqualToString:@""]) {
        [filtered addObjectsFromArray:tableData];
    } else {
        for (NSString *item in tableData) {
            if([item rangeOfString:textField.text].location != NSNotFound) {
                [filtered addObject:item];
            }
        }
    }
    
    if(autoCompleteTable) {
        [autoCompleteTable setHidden:NO];
    } else {
        CGRect visibleRect = CGRectIntersection(textField.frame, textField.superview.frame);
        visibleRect.origin.y += textField.frame.size.height;
        visibleRect.size.height *= 5;
        
        autoCompleteTable = [[UITableView alloc] initWithFrame:visibleRect
                                                         style:UITableViewStylePlain];
        
        autoCompleteTable.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        autoCompleteTable.delegate = self;
        autoCompleteTable.dataSource = self;
        
        UIWindow* window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:autoCompleteTable];
    }
    
    [autoCompleteTable reloadData];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self textFieldDidChange];
}


@end
