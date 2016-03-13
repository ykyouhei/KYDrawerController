//
//  Menu.m
//  Storyboard
//
//Just updated MainViewController and DrawerTableViewController (both programmed in Swift)
//to objectiveC version (MainViewControllerObjc and Menu), this way will be easier to implement on Objective-c Projects.
//
//  Created by Daniel Rosero on 22/01/16.
//  Copyright © 2016 Kyohei Yamaguchi. All rights reserved.
//

#import "Menu.h"
#import "MainViewControllerObjc.h"
#import "Storyboard-Swift.h"



@implementation Menu



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath{
    [tableView deselectRowAtIndexPath:newIndexPath animated:YES];
    
    KYDrawerController *elDrawer = (KYDrawerController*)self.navigationController.parentViewController;
    MainViewControllerObjc *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MainController"];
    UINavigationController *navController=[[UINavigationController alloc]initWithRootViewController:viewController];
    switch ([newIndexPath row]) {
        case 0:{
            
            
            [viewController.view setBackgroundColor:[UIColor redColor]];
            
           
            break;
        }
        
        case 1:{

             [viewController.view setBackgroundColor:[UIColor blueColor]];
            break;
        }
            
        default:{
             [viewController.view setBackgroundColor:[UIColor whiteColor]];
            break;
        }
            
            
            
        
    }
     elDrawer.mainViewController=navController;
    [elDrawer setDrawerState:DrawerStateClosed animated:YES];
}
@end
