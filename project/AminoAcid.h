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

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *molPath;
@property (strong, nonatomic) NSString *imagePath;

+ (NSArray *) getAminoAcids;

@end
