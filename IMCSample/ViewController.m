//
//  ViewController.m
//  IMCSample
//
//  Created by 大島 雅人 on 12/02/08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize socketIO;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Communicate Node.js";
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // WebSocket接続
    socketIO = [[SocketIO alloc] initWithDelegate:self];
    [socketIO connectToHost:@"localhost" onPort:3000];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - touch

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSString *tp = NSStringFromCGPoint([[touches anyObject] locationInView:self.view]);
    [socketIO sendEvent:@"touch" withData:[NSDictionary dictionaryWithObject:tp forKey:@"touch"]];
}

#pragma mark - socketID

// WebSocket接続完了した場合
- (void) socketIODidConnect:(SocketIO *)socket
{
    NSLog(@"-- socketIODidConnect()");                                        
}
                                        
// node.jsからWebSocketでメッセージが送られてきた場合
- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    NSLog(@"-- didReceiveMessage() >>> data: %@", packet.data);
}

@end
