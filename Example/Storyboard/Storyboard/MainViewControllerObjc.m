//
//  MainViewControllerObjc.m
//  Storyboard
//
//Just updated MainViewController and DrawerTableViewController (both programmed in Swift)
//to objectiveC version (MainViewControllerObjc and Menu), this way will be easier to implement on Objective-c Projects.
//
//  Created by Daniel Rosero on 22/01/16.
//  Copyright © 2016 Kyohei Yamaguchi. All rights reserved.
//

#import "MainViewControllerObjc.h"
#import "Storyboard-Swift.h"

@implementation MainViewControllerObjc

- (IBAction)clickedOpen:(id)sender {
    
    KYDrawerController *elDrawer = (KYDrawerController*)self.navigationController.parentViewController;
    [elDrawer setDrawerState:DrawerStateOpened animated:YES];
}
@end
