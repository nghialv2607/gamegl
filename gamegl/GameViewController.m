//
//  GameViewController.m
//  gamegl
//
//  Created by iNghia on 5/9/13.
//  Copyright (c) 2013 framgia. All rights reserved.
//

#import "GameViewController.h"
#import "Common.h"
#import "BallTable.h"
#import "WelcomeScene.h"

@interface GameViewController ()

@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, strong) GLKBaseEffect *effect;
@property (nonatomic, retain) SceneManager *sceneManager;

@end

// implementation
@implementation GameViewController

@synthesize context = m_context;
@synthesize effect = m_effect;
@synthesize sceneManager = m_sceneManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    m_context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!m_context)
        NSLog(@"Failed to create OpenGLES2 context");
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    self.preferredFramesPerSecond  = 60;
    [EAGLContext setCurrentContext:m_context];
    // create base effect
    m_effect = [[GLKBaseEffect alloc] init];
    GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0,
                                                      DEVICE_WIDTH,
                                                      0,
                                                      DEVICE_HEIGHT,
                                                      -1000.0,
                                                      1000.0);
    m_effect.transform.projectionMatrix = projectionMatrix;
    
    m_sceneManager = [SceneManager sharedInstance];
    [m_sceneManager addScene:@"welcomescene" andScene:[[WelcomeScene alloc] initWithEffect:m_effect]];
    [m_sceneManager changeToScene:@"welcomescene"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GLKViewDelegate
- (void)update {
    [[m_sceneManager currentScene] update:self.timeSinceLastUpdate];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    // clear color
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    // blend
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    
    // draw current scene
    [[m_sceneManager currentScene] render];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint endPoint = [touch locationInView:self.view];
    endPoint.y = DEVICE_HEIGHT - endPoint.y;
    
    [[m_sceneManager currentScene] touchesBegan:endPoint];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint endPoint = [touch locationInView:self.view];
    endPoint.y = DEVICE_HEIGHT - endPoint.y;
    
    [[m_sceneManager currentScene] touchesMoved:endPoint];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint endPoint = [touch locationInView:self.view];
    endPoint.y = DEVICE_HEIGHT - endPoint.y;
    
    [[m_sceneManager currentScene] touchesEnded:endPoint];
}

@end
