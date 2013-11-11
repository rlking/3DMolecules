//
//  AminoAcidController.m
//  3DMolecules
//
//  Created by Philipp König on 10.11.13.
//  Copyright (c) 2013 Philipp König. All rights reserved.
//

#import "AminoAcidController.h"
#import "MoleculeViewController.h"

@interface AminoAcidController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation AminoAcidController
@synthesize  containerView;

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) loadMoleculeFromPath:(NSString *)path {
    [(MoleculeViewController *)containerView loadMoleculeFromPath:path];
}

@end
