//
//  MolObject.h
//  testrenderer
//
//  Created by Philipp König on 11.08.13.
//  Copyright (c) 2013 Philipp König. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

enum AtomType {
    CARBON,
    HYDROGEN,
    OXYGEN,
    NITROGEN,
    PHOSPHORUS,
    SULFUR,
    FLUOR,
    UNKNOWN
};

typedef struct {
    GLfloat x;
    GLfloat y;
    GLfloat z;
    enum AtomType type;
} Atom;

@interface MolObject : NSObject {
    @public
    Atom *atoms;
    @public
    u_int numAtoms;
}

-(id) initFromPath:(NSString *)path;
+(u_int) getAtomRadius:(enum AtomType)type;
+(GLKVector4) getColorForAtomType:(enum AtomType)type;

@end
