//
//  AminoAcid.h
//  3DMolecules
//
//  Created by Philipp König on 03.01.14.
//  Copyright (c) 2014 Philipp König. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AminoAcid : NSObject {
}

@property (nonatomic) int dbID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *molData;
@property (strong, nonatomic) NSData *imageData;
@property (strong, nonatomic) NSString *polarity;
@property (strong, nonatomic) NSString *letter1;
@property (strong, nonatomic) NSString *letter3;

+ (NSDictionary *) getAminoAcids;

@end
