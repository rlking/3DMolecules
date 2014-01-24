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
        NSString *molObjRaw = [NSString stringWithContentsOfFile:self->_path encoding:NSUTF8StringEncoding error:nil];
        [self readDataFromString:molObjRaw];
        
        return self;
    }else {
        return nil;
    }
}

-(id) initFromString:(NSString *)stringData {
    if ( self = [super init] ) {
        
        [self readDataFromString:stringData];
        
        return self;
    }else {
        return nil;
    }
}

-(void) readDataFromString:(NSString *)stringData {
    
    //NSArray *lines = [stringData componentsSeparatedByString:@"\n"];
    NSArray *lines = [stringData componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
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
         
        //NSLog(@"i: %u x: %f y: %f z: %f", i - 4, atoms[i - 4].x,atoms[i - 4].y,atoms[i - 4].z);
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
    } else if([type isEqualToString:@"P"]) {
        return PHOSPHORUS;
    } else if([type isEqualToString:@"S"]) {
        return SULFUR;
    } else if([type isEqualToString:@"F"]) {
        return FLUOR;
    } else if([type isEqualToString:@"Cl"]) {
        return CHLORINE;
    }
    
    return UNKNOWN;
}

// http://en.wikipedia.org/wiki/CPK_coloring
+(GLKVector4) getColorForAtomType:(enum AtomType)type {
    switch(type) {
        case CARBON:
            return GLKVector4Make(0.5f, 0.5f, 0.5f, 1.0f);
            break;
        case HYDROGEN:
            return GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
            break;
        case OXYGEN:
            return GLKVector4Make(1.0f, 0.0f, 0.0f, 1.0f);
            break;
        case NITROGEN:
            return GLKVector4Make(0.0f, 0.0f, 1.0f, 1.0f);
            break;
        case PHOSPHORUS:
            return GLKVector4Make(1.0f, 0.6f, 0.0f, 1.0f);
            break;
        case SULFUR:
            return GLKVector4Make(1.0f, 0.9f, 0.0f, 1.0f);
            break;
        case FLUOR:
            return GLKVector4Make(0.0f, 1.0f, 0.0f, 1.0f);
            break;
        case CHLORINE:
            return GLKVector4Make(0.3f, 0.8f, 0.0f, 1.0f);
            break;
        case UNKNOWN:
        default:
            return GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
            break;
    }
}

+(u_int) getAtomRadius:(enum AtomType)type {
    switch(type) {
        case CARBON:
            return 170; // van-der-waals-radius
            break;
        case HYDROGEN:
            return 110;
            break;
        case OXYGEN:
            return 152;
            break;
        case NITROGEN:
            return 155;
            break;
        case PHOSPHORUS:
            return 180;
            break;
        case SULFUR:
            return 180;
            break;
        case FLUOR:
            return 150;
            break;
        case CHLORINE:
            return 180;
            break;
        case UNKNOWN:
        default:
            return 100;
            break;
    }
}

- (void)dealloc
{
    free(atoms);
}

@end
