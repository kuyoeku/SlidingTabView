//
//  HMSegmentedControl.swift
//  SlidingTabView
//
//  Created by JarlRyan on 14/10/29.
//  Copyright (c) 2014年 eastcom. All rights reserved.
//

import UIKit
import QuartzCore

enum HMSelectionIndicatorMode : Int {
    case HMSelectionIndicatorResizesToStringWidth = 0 // Indicator width will only be as big as the text width
    case HMSelectionIndicatorFillsSegment = 1 // Indicator width will fill the whole segment
}
class HMSegmentedControl : UIControl{
    var sectionTitles: NSArray!
    var indexChangeBlock : ((index: Int) -> Void)?
    var font: UIFont = UIFont(name: "STHeitiSC-Light", size: 18.0)!
    var textColor: UIColor =  UIColor.blackColor()
    var selectionIndicatorColor: UIColor = UIColor(red: 52.0/255, green: 181.0/255, blue: 229.0/255, alpha: 1.0)
    var selectionIndicatorMode : HMSelectionIndicatorMode = .HMSelectionIndicatorResizesToStringWidth
    
    var selectedIndex : NSInteger = 0
    var height : CGFloat = 32.0
    var selectionIndicatorHeight : CGFloat = 5.0
    var segmentEdgeinset : UIEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5)
    
    var selectedSegmentLayer : CALayer!
    var segmentWidth : CGFloat!
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setDefaults()
    }
    
    convenience init(sectionTitles: NSArray){
        self.init(frame: CGRectZero)
        self.sectionTitles = sectionTitles
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDefaults() {
        self.backgroundColor = UIColor.whiteColor()
        self.selectedSegmentLayer = CALayer()
        
    }
    
    override func drawRect(rect: CGRect) {
        self.backgroundColor?.set()
        UIRectFill(self.bounds)
        
        self.textColor.set()
        
        self.sectionTitles.enumerateObjectsUsingBlock { (titleString: AnyObject!, idx: Int, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
            let titleNSString : NSString = titleString as NSString
            let stringHeight: CGFloat = titleNSString.sizeWithAttributes([NSFontAttributeName : self.font]).height
            let y : CGFloat = ((self.height - self.selectionIndicatorHeight) / 2) + (self.selectionIndicatorHeight - stringHeight / 2)
            let rect: CGRect = CGRectMake(self.segmentWidth * CGFloat(idx), y, self.segmentWidth, stringHeight)
            var style: NSMutableParagraphStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as NSMutableParagraphStyle
            style.lineBreakMode = NSLineBreakMode.ByClipping
            style.alignment = NSTextAlignment.Center
            titleNSString.drawInRect(rect, withAttributes: [NSFontAttributeName : self.font,NSParagraphStyleAttributeName : style])
            
            self.selectedSegmentLayer.frame = self.frameForSelectionIndicator()
            self.selectedSegmentLayer.backgroundColor = self.selectionIndicatorColor.CGColor
            self.layer.addSublayer(self.selectedSegmentLayer)
            
        }
    }

    
    func frameForSelectionIndicator() -> CGRect{
        let stringWidth : CGFloat = self.sectionTitles.objectAtIndex(self.selectedIndex).sizeWithAttributes([NSFontAttributeName : self.font]).width
        
        if self.selectionIndicatorMode == .HMSelectionIndicatorResizesToStringWidth {
            let widthTillEndOfSelectedIndex : CGFloat = (self.segmentWidth * CGFloat(self.selectedIndex)) + self.segmentWidth
            let widthTillBeforeSelectedIndex : CGFloat = (self.segmentWidth * CGFloat(self.selectedIndex))
            
            let x : CGFloat = ((widthTillEndOfSelectedIndex - widthTillBeforeSelectedIndex) / 2) + (widthTillBeforeSelectedIndex - stringWidth / 2)
            
            return CGRectMake(x, self.height-self.selectionIndicatorHeight, stringWidth, self.selectionIndicatorHeight)
        } else {
            return CGRectMake(self.segmentWidth * CGFloat(self.selectedIndex), self.height-self.selectionIndicatorHeight, self.segmentWidth, self.selectionIndicatorHeight)
        }
        
    }

    func updateSegmentsRects() {
        if CGRectIsEmpty(self.frame) {
            self.segmentWidth = 0
            for titleString in self.sectionTitles {
                let stringWidth: CGFloat = titleString.sizeWithAttributes([NSFontAttributeName : self.font]).width + self.segmentEdgeinset.left + self.segmentEdgeinset.right
                self.segmentWidth = max(stringWidth, self.segmentWidth)
            }
            self.bounds = CGRectMake(0, 0, self.segmentWidth * CGFloat(self.sectionTitles.count), self.height);
        }else{
            self.segmentWidth = self.frame.size.width / CGFloat(self.sectionTitles.count)
            self.height = self.frame.size.height
        }
        
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        if newSuperview == nil {
            return
        }
        self.updateSegmentsRects()
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch: UITouch = event.allTouches()?.anyObject() as UITouch
        let touchLocation: CGPoint = touch.locationInView(self)
        
        if CGRectContainsPoint(self.bounds, touchLocation) {
            let segment : NSInteger = Int(touchLocation.x / self.segmentWidth)
            if segment != self.selectedIndex {
                self.setSelectedIndex(segment, animated:true)
            }
        }
    }
    
    func setSelectedIndex(index : NSInteger){
        self.setSelectedIndex(index,animated: false)
    }
    
    func setSelectedIndex(index: NSInteger, animated: Bool){
        selectedIndex = index
        if animated {
            self.selectedSegmentLayer.actions = nil
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.15)
            CATransaction.setCompletionBlock({
                () -> Void in
                if (self.superview != nil) {
                    self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
                }
                if (self.indexChangeBlock != nil) {
                    self.indexChangeBlock!(index: index)
                }
            })
            self.selectedSegmentLayer.frame = self.frameForSelectionIndicator()
            CATransaction.commit()
        } else {
            let newActions : NSMutableDictionary = NSMutableDictionary(objectsAndKeys: NSNull(),"position",NSNull(),"bounds")
            self.selectedSegmentLayer.actions = newActions
            
            self.selectedSegmentLayer.frame = self.frameForSelectionIndicator()
            
            if self.superview != nil {
                self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
            }
            
            if self.indexChangeBlock != nil {
                self.indexChangeBlock!(index: index)
            }
        }
    }
    override var frame : CGRect {
        didSet {
            super.frame = frame
            if self.sectionTitles != nil {
                self.updateSegmentsRects()
            }
            self.setNeedsDisplay()
        }
    }

    override var bounds : CGRect {
        didSet {
            super.bounds = bounds
            if self.sectionTitles != nil {
                self.updateSegmentsRects()
            }
            
            self.setNeedsDisplay()
        }
    }

}
