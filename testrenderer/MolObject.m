//
//  MolObject.m
//  testrenderer
//
//  Created by Philipp König on 11.08.13.
//  Copyright (c) 2013 Philipp König. All rights reserved.
//

#import "MolObject.h"

#import <OpenGLES/ES2/gl.h>

@implementation MolObject {
    NSString *_path;
}


-(id) initFromPath:(NSString *)path {
    if ( self = [super init] ) {
        self->_path = path;
        
        [self readData];
        
        return self;
    }else {
        return nil;
    }
}

-(void) readData {
    NSString *molObjRaw = [NSString stringWithContentsOfFile:self->_path encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *lines = [molObjRaw componentsSeparatedByString:@"\n"];
    
    // split 4. line of mol file which contains number of atoms and bonds
    NSArray *splitLine = [[lines[3] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    numAtoms = [splitLine[0] intValue];
    // this is wrong because of weird spacing
    //u_int numBonds = [splitLine[1] intValue];
    
    atoms = malloc(sizeof(Atom) * numAtoms);
    
    for(u_int i = 4; i < 4 + numAtoms; i++) {
        NSArray *splitLine = [[lines[i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSMutableArray *parsedSplitLine = [NSMutableArray array];
        // create array without all the empty whitespace elements
        for(NSString *part in splitLine) {
            if([part length] != 0) {
                [parsedSplitLine addObject:part];
            }
        }
        
        
        atoms[i - 4].x = [parsedSplitLine[0] floatValue];
        atoms[i - 4].y = [parsedSplitLine[1] floatValue];
        atoms[i - 4].z = [parsedSplitLine[2] floatValue];
        atoms[i - 4].type = [MolObject getAtomTypeFrom:parsedSplitLine[3]];
         
        NSLog(@"i: %u x: %f y: %f z: %f", i - 4, atoms[i - 4].x,atoms[i - 4].y,atoms[i - 4].z);
    }
}

+(enum AtomType) getAtomTypeFrom:(NSString *)type {
    if([type isEqualToString:@"C"]) {
        return CARBON;
    } else if([type isEqualToString:@"H"]) {
        return HYDROGEN;
    } else if([type isEqualToString:@"O"]) {
        return OXYGEN;
    } else if([type isEqualToString:@"N"]) {
        return NITROGEN;
    }
    
    return UNKNOWN;
}

- (void)dealloc
{
    free(atoms);
}

@end
