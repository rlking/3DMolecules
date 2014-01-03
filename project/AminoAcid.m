//
//  AminoAcid.m
//  3DMolecules
//
//  Created by Philipp König on 03.01.14.
//  Copyright (c) 2014 Philipp König. All rights reserved.
//

#import "AminoAcid.h"

static NSArray *aminoAcids;

@implementation AminoAcid {
}

@synthesize name;
@synthesize molPath;
@synthesize imagePath;


-(id) init {
    if ( self = [super init] ) {
        return self;
    }else {
        return nil;
    }
}


+ (NSArray *) getAminoAcids {
    if(!aminoAcids) {
        NSMutableArray *acids = [NSMutableArray array];
        
        NSArray *resourcesList = [[NSBundle mainBundle] pathsForResourcesOfType:@".mol" inDirectory:@"amino_acids"];
        for(NSString *path in resourcesList){
            AminoAcid *acid = [AminoAcid new];
            
            // set full path
            acid.molPath = path;
            // parse name from full path
            NSArray *splitPath = [path componentsSeparatedByString:@"/"];
            acid.name = [splitPath lastObject];
            [acids addObject:acid];
        }
        
        aminoAcids = acids;
    }
    
    return aminoAcids;
}

@end
