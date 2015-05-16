//
//  DrawerTableViewController.swift
//  Storyboard
//
//  Created by kyo__hei on 2015/05/16.
//  Copyright (c) 2015年 Kyohei Yamaguchi. All rights reserved.
//

import UIKit

class DrawerTableViewController: UITableViewController {

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if let drawerController = navigationController?.parentViewController as? KYDrawerController {
            let mainNavigation = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainNavigation") as! UINavigationController
            let backgroundColor: UIColor
            switch indexPath.row {
            case 0:
                backgroundColor = UIColor.redColor()
            case 1:
                backgroundColor = UIColor.blueColor()
            default:
                backgroundColor = UIColor.whiteColor()
            }
            mainNavigation.topViewController.view.backgroundColor = backgroundColor
            drawerController.mainViewController = mainNavigation
            drawerController.setDrawerState(.Closed, animated: true)
        }
    }

}
