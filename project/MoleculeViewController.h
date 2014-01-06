//
//  ViewController.h
//  testrenderer
//
//  Created by Philipp König on 03.08.13.
//  Copyright (c) 2013 Philipp König. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface MoleculeViewController : GLKViewController

-(void) loadMoleculeFromPath:(NSString *)path;
-(void) loadMoleculeFromString:(NSString *)stringData;


@end
