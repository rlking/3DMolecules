//
//  AminoAcidController.m
//  3DMolecules
//
//  Created by Philipp König on 10.11.13.
//  Copyright (c) 2013 Philipp König. All rights reserved.
//

#import "AminoAcidController.h"
#import "MoleculeViewController.h"
#import "AminoAcid.h"

@interface AminoAcidController ()
@property (strong, nonatomic) MoleculeViewController *childViewController;
@property (strong, nonatomic) AminoAcid *aminoAcid;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation AminoAcidController
@synthesize  childViewController;
@synthesize aminoAcid;
@synthesize label;

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
    
    
    [childViewController loadMoleculeFromPath:aminoAcid.molPath];
    [label setText:aminoAcid.name];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) loadMoleculeFromAminoAcid:(AminoAcid *)acid {
    aminoAcid = acid;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"FooA"]) {
        childViewController = (MoleculeViewController *) [segue destinationViewController];
    }
}



@end
