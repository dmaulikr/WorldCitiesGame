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

@interface WCGStartViewController ()

@end

@implementation WCGStartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        allItems = [[NSArray alloc] initWithObjects:@"Play", @"Get more cities", @"Rules", @"Author", nil];
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
        WCGMapViewController *currentViewController = [[WCGMapViewController alloc] init];
        [[self navigationController] pushViewController:currentViewController
                                               animated:YES];

    }
    else if (curRow == 1) //buy
    {
        
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
