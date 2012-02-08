//
//  ViewController.h
//  IMCSample
//
//  Created by 大島 雅人 on 12/02/08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SocketIO.h"

@interface ViewController : UIViewController<SocketIODelegate,UIScrollViewDelegate>

@property (strong, nonatomic) SocketIO *socketIO;
@property (strong, nonatomic) IBOutlet UIScrollView *pagingScrollView;
@property (assign, nonatomic) BOOL mode;

- (IBAction)connect;
- (IBAction)disconnect;
- (IBAction)changeMode:(id)sender;
@end
