//
//  WaveObject.h
//  testrenderer
//
//  Created by Philipp König on 10.08.13.
//  Copyright (c) 2013 Philipp König. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    GLfloat x;
    GLfloat y;
    GLfloat z;
} Vertex;

typedef struct {
    GLushort v1;
    GLushort v2;
    GLushort v3;
} Face;



@interface WaveObject : NSObject {
    @public
    Vertex *vertices;
    @public
    Vertex *normals;
    @public
    Face *vertexIndices;
    @public
    u_int numIndices;
    @public
    Face *normalIndices;
    @public
    Vertex *vertices2;
    @public
    Vertex *normals2;
}
-(id) initFromPath:(NSString *)path;
@end
