//
//  ViewController.swift
//  SlidingTabView
//
//  Created by JarlRyan on 14/10/29.
//  Copyright (c) 2014年 eastcom. All rights reserved.
//

import UIKit

class ViewController: UIViewController,SlidingTabViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        let slidingTabView : SlidingTabView = SlidingTabView()
        slidingTabView.frame = CGRectMake(0, 24, self.view.frame.width, self.view.frame.height-24)
        slidingTabView.dataSource = self
        //slidingTabView.contentDict = ["第一页":FirstVC(),"第二页":SecondVC()]
        self.view.addSubview(slidingTabView)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData() -> NSDictionary{
        return ["第一页":FirstVC(),"第二页":SecondVC()]
    }


}

