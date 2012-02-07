//
//  ViewController.h
//  IMCSample
//
//  Created by 大島 雅人 on 12/02/08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketIO.h"

@interface ViewController : UIViewController<SocketIODelegate>
@property (strong, nonatomic) SocketIO *socketIO;
@end
