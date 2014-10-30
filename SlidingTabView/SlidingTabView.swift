//
//  SlidingTabView.swift
//  SlidingTabView
//
//  Created by JarlRyan on 14/10/29.
//  Copyright (c) 2014年 eastcom. All rights reserved.
//

import UIKit

protocol SlidingTabViewDataSource {
    func setData() -> NSDictionary
}
class SlidingTabView : UIView, UIScrollViewDelegate {
    var segmentedHeight : CGFloat = 30
    var arViewControllers : NSArray!
    var scrollView : UIScrollView!
    var contentDict : NSDictionary!{
        didSet {
            sectionTitles = contentDict.allKeys
            arViewControllers = contentDict.allValues
            initSegmentedControl()
            initScrollView()
            self.setViewControllers(arViewControllers)
        }
    }
    var sectionTitles : NSArray!
    var dataSource : SlidingTabViewDataSource? {
        willSet {
            self.dataSource = newValue
            contentDict = self.dataSource!.setData()
        }
    }
    var segmentedControl : HMSegmentedControl!
    
    var selectedIndex : Int = 0
    
    var viewControllersCount : Int = 0
    
    var transFlag = false
    
    override init() {
        super.init()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSegmentedControl(){
        
        segmentedControl = HMSegmentedControl(sectionTitles: sectionTitles)
        segmentedControl.font = UIFont(name: "STHeitiSC-Light", size: 13)!
        segmentedControl.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 30)
        segmentedControl.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 1.0, alpha: 1.0)
        segmentedControl.selectionIndicatorHeight = 2.0
        segmentedControl.indexChangeBlock = indexBlock
        segmentedControl.tag = 1
        self.addSubview(segmentedControl)
    }
    
    func initScrollView(){
        self.scrollView  = UIScrollView()
        scrollView.backgroundColor = UIColor.blackColor()
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.delegate = self
        scrollView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        let orinY = segmentedControl.frame.height
        scrollView.frame = CGRectMake(0, orinY, self.frame.size.width, self.frame.size.height-orinY)
        self.addSubview(scrollView)
    }
    
    func indexBlock(index : Int){
        if selectedIndex != index {
            let selectedViewController = arViewControllers[index] as? UIViewController
            selectedViewController?.loadData()
            selectedIndex = index
        }
        if transFlag {
            self.setSelectedViewControllerIndex(index)
        }
        transFlag = true
    }
    
    func setSelectedViewControllerIndex(cIndex : Int){
        scrollView.scrollRectToVisible((arViewControllers.objectAtIndex(cIndex) as UIViewController).view.frame, animated: true)
    }
    
    
    func setViewControllers(viewControllers : NSArray){
        if viewControllersCount > 0 {
            return
        }
        
        for i in 0 ... viewControllers.count-1 {
            let view : UIViewController = viewControllers[i] as UIViewController
            view.view.frame = CGRectMake(UIScreen.mainScreen().bounds.width * CGFloat(i), 0, self.frame.size.width, scrollView.frame.size.height)
            scrollView.addSubview(view.view)
            view.view.tag = i
            viewControllersCount++
        }
        scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width * CGFloat(viewControllersCount), scrollView.frame.size.height)
        segmentedControl.setSelectedIndex(0, animated: true)
    }
    
    func updateSlidingViewRects() {
        scrollView.frame = CGRectMake(0, segmentedControl.frame.height, UIScreen.mainScreen().bounds.width, self.frame.height-segmentedControl.frame.height)
    }
    
    //MARK: - scrollViewDelegate
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        transFlag = false
        let index : Int = Int(scrollView.contentOffset.x) / Int(self.frame.width)
        segmentedControl.setSelectedIndex(index, animated: true)
    }
    
    override var frame : CGRect {
        didSet {
            super.frame = frame
            if self.sectionTitles != nil {
                self.updateSlidingViewRects()
            }
            self.setNeedsDisplay()
        }
    }
    
    override var bounds : CGRect {
        didSet {
            super.bounds = bounds
            if self.sectionTitles != nil {
                self.updateSlidingViewRects()
            }
            
            self.setNeedsDisplay()
        }
    }
}
