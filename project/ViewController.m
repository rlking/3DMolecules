//
//  ViewController.m
//  testrenderer
//
//  Created by Philipp König on 03.08.13.
//  Copyright (c) 2013 Philipp König. All rights reserved.
//

#import "ViewController.h"
#import "WaveObject.h"
#import "MolObject.h"

@interface ViewController () {
    float _rotation;
    float _scale;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    GLuint _normalBuffer;
    
    WaveObject *sphere;
    MolObject *molObj;
}

@property (strong, nonatomic) NSMutableArray *effects;
@property (strong, nonatomic) EAGLContext *context;

- (void)setupGL;
- (void)tearDownGL;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    sphere = [[WaveObject alloc] initFromPath:[[NSBundle mainBundle] pathForResource:@"sphere_smooth" ofType:@"obj"]];
    molObj = [[MolObject alloc] initFromPath:[[NSBundle mainBundle] pathForResource:@"water" ofType:@"mol"]];
    
    self.effects = [NSMutableArray array];
    _scale = 1.0f;
    
    UIPinchGestureRecognizer *pinchRecognize = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(respondToPinchGesture:)];
    [self.view addGestureRecognizer:pinchRecognize];
    UIPanGestureRecognizer *panRecognize = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(respondToPanGesture:)];
    panRecognize.maximumNumberOfTouches = 1;
    [self.view addGestureRecognizer:panRecognize];

    
    [self setupGL];
}


float _origScale = 0.0f;
-(void) respondToPinchGesture:(UIPinchGestureRecognizer *)recognizer {
    //NSLog(@"pinch gesture: velo: %f scale: %f state: %d", recognizer.velocity, recognizer.scale, recognizer.state);
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _origScale = _scale;
    }
    _scale = _origScale * recognizer.scale;
}

-(void) respondToPanGesture:(UIPanGestureRecognizer *)recognizer {
    CGPoint p = [recognizer translationInView:self.view];
    //NSLog(@"pan gesture: x:%f y:%f", p.x, p.y);
}

- (void)dealloc
{    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }

    // Dispose of any resources that can be recreated.
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    for(u_int i=0; i < molObj->numAtoms; i++) {
        GLKBaseEffect *effect = [[GLKBaseEffect alloc] init];
        effect.light0.enabled = GL_TRUE;
        effect.light0.diffuseColor = [ViewController getColorForAtomType:molObj->atoms[i].type];
        [self.effects addObject:effect];
    }
    
    glEnable(GL_DEPTH_TEST);
    
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);

    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER,sizeof(Vertex) * sphere->numIndices * 3, sphere->vertices2, GL_STATIC_DRAW);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, 0);
    
    glGenBuffers(1, &_normalBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _normalBuffer);
    glBufferData(GL_ARRAY_BUFFER,sizeof(Vertex) * sphere->numIndices * 3, sphere->normals2, GL_STATIC_DRAW);
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 0, 0);
    
    glBindVertexArrayOES(0);
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
        case UNKNOWN:
            return GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
        default:
            
            break;
    }
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_normalBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    
    [self.effects removeAllObjects];
    
    [sphere free];
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    
    
    GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -15.0f * _scale);
    baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, _rotation, 0.0f, 1.0f, 0.0f);
    
    
    u_int i=0;
    for(GLKBaseEffect *effect in self.effects){
        effect.transform.projectionMatrix = projectionMatrix;
        
        GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(molObj->atoms[i].x,molObj->atoms[i].y, molObj->atoms[i].z);
        //modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
        modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
        effect.transform.modelviewMatrix = modelViewMatrix;
        
        i++;
    }
    
    _rotation += self.timeSinceLastUpdate * 0.5f;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    
    glBindVertexArrayOES(_vertexArray);
    
    for(GLKBaseEffect *effect in self.effects){
        [effect prepareToDraw];
        glDrawArrays(GL_TRIANGLES, 0, sphere->numIndices * 3);
    }
}

@end
