//
//  StoryboardExtend.swift
//  SegmentScrollViewController
//
//  Created by JarlRyan on 14/9/13.
//  Copyright (c) 2014年 eastcom. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    class func getViewControllerFromStoryboard(viewController:NSString, storyboard:NSString) -> UIViewController {
        let sBoard = UIStoryboard(name: storyboard, bundle: nil)
        let vController: UIViewController = sBoard.instantiateViewControllerWithIdentifier(viewController) as UIViewController
        return vController
    }
}