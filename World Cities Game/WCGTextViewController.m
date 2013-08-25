//
//  WCGTextViewController.m
//  World Cities Game
//
//  Created by Alexandra Pozdnyakova on 25/08/2013.
//  Copyright (c) 2013 Alexandra Pozdnyakova. All rights reserved.
//

#import "WCGTextViewController.h"

@interface WCGTextViewController ()

@end

@implementation WCGTextViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initForTopic:(NSString*)newTopic
{
     self = [super initWithNibName:@"WCGTextViewController" bundle:nil];
    if (self)
    {
        topic = [[NSString alloc] initWithString:newTopic];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *text;
    if ([topic isEqualToString:@"rules"])
    {
        text = @"Rules: \n 1) Start the game \n 2) Try to touch your screen as close to the city as possible";
    }
    else
    {
        text = @"Hi, my name is Alexandra and you can contact me via e-mail: ylibatsya@gmail.com";
    }
    [textField setText:text];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
