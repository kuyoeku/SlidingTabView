//
//  SecondVC.swift
//  SlidingTabView
//
//  Created by JarlRyan on 14/10/29.
//  Copyright (c) 2014年 eastcom. All rights reserved.
//

import UIKit
class SecondVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        let label : UILabel = UILabel(frame: CGRectMake(0, 0, 100, 200))
        label.text = "第二页"
        self.view.addSubview(label)
    }
}
