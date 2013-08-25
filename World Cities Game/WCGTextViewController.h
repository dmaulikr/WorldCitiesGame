//
//  WCGTextViewController.h
//  World Cities Game
//
//  Created by Alexandra Pozdnyakova on 25/08/2013.
//  Copyright (c) 2013 Alexandra Pozdnyakova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCGTextViewController : UIViewController
{
    __weak IBOutlet UITextView *textField;
    NSString * topic;
}
- (id) initForTopic:(NSString*)newTopic;
@end
