//
//  WCGStartViewController.m
//  World Cities Game
//
//  Created by Alexandra Pozdnyakova on 23/08/2013.
//  Copyright (c) 2013 Alexandra Pozdnyakova. All rights reserved.
//

#import "WCGStartViewController.h"
#import "WCGMapViewController.h"
#import "WCGTextViewController.h"
#import "WCGBuyViewController.h"
#import "WCGRegionsViewController.h"
#import "WCGSettingsViewController.h"
#import "WCGSettings.h"

@interface WCGStartViewController ()

@end

@implementation WCGStartViewController

+ (void)initialize
{
    NSDictionary *defaults = [NSDictionary
                              dictionaryWithObject:@"Medium"
                              forKey:[[WCGSettings sharedStore] level]];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        allItems = [[NSArray alloc] initWithObjects:@"Play", @"Settings", @"Rules", @"Author", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [[cell textLabel] setText:[allItems objectAtIndex:[indexPath row]]];
   // [[cell detailTextLabel] setText:[item statusDetailsFull]];
    
    
    return cell;
}

- (void)tableView:(UITableView *)aTableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int curRow = [indexPath row];
    if (curRow == 0) //play
    {
       // WCGMapViewController *currentViewController = [[WCGMapViewController alloc] init];
        WCGRegionsViewController *currentViewController = [[WCGRegionsViewController alloc] init];
        
        
        [[self navigationController] pushViewController:currentViewController
                                               animated:YES];

    }
    else if (curRow == 1) //buy
    {
        WCGSettingsViewController *textViewController = [[WCGSettingsViewController alloc] init];
        [[self navigationController] pushViewController:textViewController
                                               animated:YES];

    }
    else if (curRow == 2) //rules
    {
        WCGTextViewController *textViewController = [[WCGTextViewController alloc] initForTopic:@"rules"];
        [[self navigationController] pushViewController:textViewController
                                               animated:YES];
    }
    else if (curRow == 3) //author
    {
        WCGTextViewController *textViewController = [[WCGTextViewController alloc] initForTopic:@"author"];
        [[self navigationController] pushViewController:textViewController
                                               animated:YES];
        
    }
}


@end
