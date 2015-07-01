//
//  ViewController.swift
//  draw
//
//  Created by zhaoxiaolu on 15/5/28.
//  Copyright (c) 2015年 zhaoxiaolu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var carview:MyView!

    override func viewDidLoad() {
        super.viewDidLoad()
        carview = MyView(frame: CGRectMake(85, 100, 150, 250))
        carview.setImage(UIImage(named: "goods")!)
        self.view.addSubview(carview)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

