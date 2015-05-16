//
//  MainViewController.swift
//  Storyboard
//
//  Created by kyo__hei on 2015/05/16.
//  Copyright (c) 2015年 Kyohei Yamaguchi. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func didTapOpenButton(sender: UIBarButtonItem) {
        if let drawerController = navigationController?.parentViewController as? KYDrawerController {
            drawerController.setDrawerState(.Opened, animated: true)
        }
    }
    

}
