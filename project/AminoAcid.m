//
//  AminoAcid.m
//  3DMolecules
//
//  Created by Philipp König on 03.01.14.
//  Copyright (c) 2014 Philipp König. All rights reserved.
//

#import "AminoAcid.h"
#import "FMDatabase.h"

static NSArray *aminoAcids;

@implementation AminoAcid {
}

@synthesize dbID;
@synthesize name;
@synthesize molData;
@synthesize imageData;


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
        
        
        
        FMDatabase *database = [self openDatabase];
        [database open];
        
        @try
        {
            FMResultSet *results = [database executeQuery:@"select * from amino_acids"];
            while([results next]) {
                NSLog(@"name: %@", [results stringForColumn:@"name"]);
                
                AminoAcid *acid = [AminoAcid new];
                acid.dbID = [results intForColumn:@"id"];
                acid.name = [results stringForColumn:@"name"];
                acid.molData = [results stringForColumn:@"mol_data"];
                acid.imageData = [results dataForColumn:@"image_data"];
                
                [acids addObject:acid];
            }
        }
        @catch (NSException *exception)
        {
            [NSException raise:@"could not execute query" format:nil];
        }
        @finally
        {
            [database close];
        }

        
        //NSArray *resourcesList = [[NSBundle mainBundle] pathsForResourcesOfType:@".mol" inDirectory:@"amino_acids"];
        aminoAcids = acids;
    }
    
    return aminoAcids;
}

+ (FMDatabase*)openDatabase
{
    FMDatabase *database;
    @try
    {
        database = [FMDatabase databaseWithPath:[[NSBundle mainBundle] pathForResource:@"amino_acids" ofType:@".sqlite"]];
        if (![database open])
        {
            [NSException raise:@"could not open db" format:nil];
        }
    }
    @catch (NSException *e)
    {
        // #!
        return nil;
    }
    return database;
}

@end
