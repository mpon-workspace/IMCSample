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
@synthesize pagingScrollView;
@synthesize mode;
#define PAGES 10

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.socketIO = nil;
    self.pagingScrollView = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
#define PADDING 2
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.    
    CGFloat w = CGRectGetWidth(pagingScrollView.frame);
    CGFloat h = CGRectGetHeight(pagingScrollView.frame);
    pagingScrollView.contentSize = CGSizeMake(w * PAGES, h);
    for (int i = 0; i < PAGES; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * w + PADDING, PADDING, w - 2 * PADDING, h - 2 * PADDING)];
        label.text = [NSString stringWithFormat:@"%d", i + 1];
        label.font = [UIFont fontWithName:@"Futura" size:150];
        label.textAlignment = UITextAlignmentCenter;
        label.backgroundColor = [UIColor colorWithRed:(CGFloat)i * 0.1 green:(CGFloat)i * 0.1 blue:1.0f alpha:1.0f];
        label.layer.cornerRadius = 10;
        [pagingScrollView addSubview:label];
        [label release];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.pagingScrollView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.mode) {
        NSString *x = [NSString stringWithFormat:@"%f",scrollView.contentOffset.x];
        NSString *y = [NSString stringWithFormat:@"%f",scrollView.contentOffset.y];
        NSArray *objects = [NSArray arrayWithObjects:x, y, nil];
        NSArray *keys = [NSArray arrayWithObjects:@"x",@"y", nil];
        [socketIO sendEvent:@"scroll" withData:[NSDictionary dictionaryWithObjects:objects forKeys:keys]];
    }
}

#pragma mark - socket.io
#define SERVER_ADDRESS @"localhost"
#define PORT 3000
- (void)connect
{
    self.socketIO = [[SocketIO alloc] initWithDelegate:self];
    [socketIO connectToHost:SERVER_ADDRESS onPort:PORT];
}

- (void)disconnect
{
    [socketIO disconnect];
    self.socketIO = nil;
}

- (void)changeMode:(id)sender
{
    UISegmentedControl *segment = sender;
    self.mode = segment.selectedSegmentIndex;
}

// WebSocket接続完了した場合
- (void) socketIODidConnect:(SocketIO *)socket
{
    NSLog(@"-- socketIODidConnect()");
}
                                        
// node.jsからWebSocketでメッセージが送られてきた場合
#define SCROLLING @"scrolling"
#define RESET @"reset"
- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    if (!self.mode) {
        if ([packet.name isEqualToString:SCROLLING]) {
            CGFloat x = [[[packet.args lastObject] objectForKey:@"x"] floatValue];
            CGFloat y = [[[packet.args lastObject] objectForKey:@"y"] floatValue];
            [pagingScrollView setContentOffset:CGPointMake(x, y) animated:YES];
        } else if ([packet.name isEqualToString:RESET]) {
            [pagingScrollView setContentOffset:CGPointZero animated:YES];
        }
    }
}

@end
