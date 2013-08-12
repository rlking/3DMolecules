//
//  WaveObject.m
//  testrenderer
//
//  Created by Philipp König on 10.08.13.
//  Copyright (c) 2013 Philipp König. All rights reserved.
//

#import "WaveObject.h"
#import <OpenGLES/ES2/gl.h>

@implementation WaveObject {
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
    NSString *sphereObjRaw = [NSString stringWithContentsOfFile:self->_path encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *lines = [sphereObjRaw componentsSeparatedByString:@"\n"];
    
    // loop over file to estimate sizes for vertices and indices
    u_int numVertices = 0;
    u_int numNormals = 0;
    for (NSString * line in lines) {
        if ([line hasPrefix:@"v "]) {
            numVertices++;
        }
        else if ([line hasPrefix:@"vn "]) {
            numNormals++;
        }
        else if ([line hasPrefix:@"f "]) {
            numIndices++;
        }
    }
    
    vertices = malloc(sizeof(Vertex) * numVertices);
    normals = malloc(sizeof(Vertex) * numNormals);
    vertexIndices = malloc(sizeof(Face) * numIndices);
    normalIndices = malloc(sizeof(Face) * numIndices);
    
    NSLog(@"vertices: %u normals %u indices: %u", numVertices, numNormals, numIndices);
    
    
    u_int loopVerticesCount = 0;
    u_int loopNormalsCount = 0;
    u_int loopIndicesCount = 0;
    for(NSString *line in lines) {
        // example vertex
        // v -0.375330 -0.195090 -0.906128
        if ([line hasPrefix:@"v "]) {
            NSArray *splitLine = [line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            vertices[loopVerticesCount].x = [splitLine[1] floatValue];
            vertices[loopVerticesCount].y = [splitLine[2] floatValue];
            vertices[loopVerticesCount].z = [splitLine[3] floatValue];
            
            loopVerticesCount++;
        }
        
        if ([line hasPrefix:@"vn "]) {
            NSArray *splitLine = [line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            normals[loopNormalsCount].x = [splitLine[1] floatValue];
            normals[loopNormalsCount].y = [splitLine[2] floatValue];
            normals[loopNormalsCount].z = [splitLine[3] floatValue];
            
            loopNormalsCount++;
        }
        
        // example faces line
        // vertex/texture/normal
        // f 57//49 72//49 73//49
        if ([line hasPrefix:@"f "]) {
            NSArray *splitLine = [line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            NSArray *splitFace1 = [splitLine[1] componentsSeparatedByString:@"/"];
            NSArray *splitFace2 = [splitLine[2] componentsSeparatedByString:@"/"];
            NSArray *splitFace3 = [splitLine[3] componentsSeparatedByString:@"/"];
            
            // they are index 1 but need to be index 0 based
            vertexIndices[loopIndicesCount].v1 = [splitFace1[0] intValue] - 1;
            vertexIndices[loopIndicesCount].v2 = [splitFace2[0] intValue] - 1;
            vertexIndices[loopIndicesCount].v3 = [splitFace3[0] intValue] - 1;
            
            normalIndices[loopIndicesCount].v1 = [splitFace1[2] intValue] - 1;
            normalIndices[loopIndicesCount].v2 = [splitFace2[2] intValue] - 1;
            normalIndices[loopIndicesCount].v3 = [splitFace3[2] intValue] - 1;
            
            loopIndicesCount++;
        }
    }
    
    vertices2 = malloc(sizeof(Vertex) * numIndices * 3);
    normals2 = malloc(sizeof(Vertex) * numIndices * 3);
    
    for(int i=0; i<numIndices; i++) {
        vertices2[i * 3].x = vertices[vertexIndices[i].v1].x;
        vertices2[i * 3].y = vertices[vertexIndices[i].v1].y;
        vertices2[i * 3].z = vertices[vertexIndices[i].v1].z;
        
        vertices2[i * 3 + 1].x = vertices[vertexIndices[i].v2].x;
        vertices2[i * 3 + 1].y = vertices[vertexIndices[i].v2].y;
        vertices2[i * 3 + 1].z = vertices[vertexIndices[i].v2].z;
        
        vertices2[i * 3 + 2].x = vertices[vertexIndices[i].v3].x;
        vertices2[i * 3 + 2].y = vertices[vertexIndices[i].v3].y;
        vertices2[i * 3 + 2].z = vertices[vertexIndices[i].v3].z;
        
        normals2[i * 3].x = normals[normalIndices[i].v1].x;
        normals2[i * 3].y = normals[normalIndices[i].v1].y;
        normals2[i * 3].z = normals[normalIndices[i].v1].z;
        
        normals2[i * 3 + 1].x = normals[normalIndices[i].v2].x;
        normals2[i * 3 + 1].y = normals[normalIndices[i].v2].y;
        normals2[i * 3 + 1].z = normals[normalIndices[i].v2].z;
        
        normals2[i * 3 + 2].x = normals[normalIndices[i].v3].x;
        normals2[i * 3 + 2].y = normals[normalIndices[i].v3].y;
        normals2[i * 3 + 2].z = normals[normalIndices[i].v3].z;
    }
}

-(void) free {
    free(vertices);
    free(vertices2);
    free(normals);
    free(normals2);
    free(vertexIndices);
    free(normalIndices);
}

@end
