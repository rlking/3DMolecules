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

const GLfloat axisLines[] = {
    1.0f, 1.0f, 1.0f, // 1. point
    5.0f, 5.0f, 5.0f  // 2. point 
};

@interface ViewController () {
    float _rotation;
    float _scale;
    float _x;
    float _y;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    GLuint _normalBuffer;
    
    WaveObject *sphere;
    MolObject *molObj;

	GLKVector3 _position;
	
	GLKVector3 _up;
	GLKVector3 _right;
    NSMutableArray *tableData;
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
    
	_position	= GLKVector3Make(0.0f, 0.0f, 15.0f);
	_up			= GLKVector3Make(0.0f, 1.0f,  0.0f);
	_right		= GLKVector3Make(1.0f, 0.0f,  0.0f);
	
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    NSArray *resourcesList = [[NSBundle mainBundle] pathsForResourcesOfType:@".mol" inDirectory:nil];
    tableData = [NSMutableArray array];
    for(NSString *path in resourcesList){
        NSArray *splitPath = [path componentsSeparatedByString:@"/"];
        [tableData addObject:[splitPath lastObject]];
    }
    
    sphere = [[WaveObject alloc] initFromPath:[[NSBundle mainBundle] pathForResource:@"sphere_smooth" ofType:@"obj"]];
    molObj = [[MolObject alloc] initFromPath:[[NSBundle mainBundle] pathForResource:@"meth" ofType:@"mol"]];
    
    self.effects = [NSMutableArray array];
    
    UIPinchGestureRecognizer *pinchRecognize = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(respondToPinchGesture:)];
    [self.view addGestureRecognizer:pinchRecognize];
    UIPanGestureRecognizer *panRecognize = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(respondToPanGesture:)];
    panRecognize.maximumNumberOfTouches = 1;
    [self.view addGestureRecognizer:panRecognize];

    
    [self setupGL];
}

float _origScale;
-(void) respondToPinchGesture:(UIPinchGestureRecognizer *)recognizer {
    //NSLog(@"pinch gesture: velo: %f scale: %f state: %d", recognizer.velocity, recognizer.scale, recognizer.state);
	if (recognizer.state == UIGestureRecognizerStateBegan) {
        _origScale = GLKVector3Length(_position);
	}	
	float newScale = _origScale / recognizer.scale;
	_position = GLKVector3MultiplyScalar(GLKVector3Normalize(_position), newScale);
}

float _lastPx;
float _lastPy;
-(void) respondToPanGesture:(UIPanGestureRecognizer *)recognizer {
    CGPoint p = [recognizer translationInView:self.view];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _lastPx = 0.0f;
		_lastPy = 0.0f;
    }
	
	{
		GLKMatrix4 rotation_x = GLKMatrix4MakeRotation(-(p.x - _lastPx) / 100.0f, _up.x, _up.y, _up.z);
		
		_right = GLKMatrix4MultiplyVector3(rotation_x, _right);
		_position = GLKMatrix4MultiplyVector3(rotation_x, _position);
	}
		
	{
		GLKMatrix4 rotation_y = GLKMatrix4MakeRotation(-(p.y - _lastPy) / 100.0f, _right.x, _right.y, _right.z);
		
		_up = GLKMatrix4MultiplyVector3(rotation_y, _up);
		_position = GLKMatrix4MultiplyVector3(rotation_y, _position);
	}
		
	_lastPx = p.x;
	_lastPy = p.y;
	
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
        effect.light0.diffuseColor = [MolObject getColorForAtomType:molObj->atoms[i].type];
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

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_normalBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    
    [self.effects removeAllObjects];
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    
	GLKMatrix4 viewMatrix = GLKMatrix4MakeLookAt(_position.x, _position.y, _position.z, 0.0f, 0.0f, 0.0f, _up.x, _up.y, _up.z);
    
    
    u_int i=0;
    for(GLKBaseEffect *effect in self.effects){
        effect.transform.projectionMatrix = projectionMatrix;
        
        GLKMatrix4 modelMatrix = GLKMatrix4MakeTranslation(molObj->atoms[i].x, molObj->atoms[i].y, molObj->atoms[i].z);
        
        u_int radH = [MolObject getAtomRadius:HYDROGEN];
        float radScale = [MolObject getAtomRadius:molObj->atoms[i].type] / (float)radH;
        
        modelMatrix = GLKMatrix4Scale(modelMatrix, radScale, radScale, radScale);
        modelMatrix = GLKMatrix4Multiply(viewMatrix, modelMatrix);
        effect.transform.modelviewMatrix = modelMatrix;
        
        i++;
    }
    
    //_rotation += self.timeSinceLastUpdate * 0.5f;
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *resourcesList = [[NSBundle mainBundle] pathsForResourcesOfType:@".mol" inDirectory:nil];
    molObj = [[MolObject alloc] initFromPath:[resourcesList objectAtIndex:indexPath.row]];
    
    [self.effects removeAllObjects];
    for(u_int i=0; i < molObj->numAtoms; i++) {
        GLKBaseEffect *effect = [[GLKBaseEffect alloc] init];
        effect.light0.enabled = GL_TRUE;
        effect.light0.diffuseColor = [MolObject getColorForAtomType:molObj->atoms[i].type];
        [self.effects addObject:effect];
    }
}

@end
