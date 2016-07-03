//
//  PIDrawView.swift
//  layer的应用
//
//  Created by hznucai on 16/2/14.
//  Copyright © 2016年 hznucai. All rights reserved.
//

//
//  PIDrawerView.swift
//  图像的应用
//
//  Created by hznucai on 16/2/14.
//  Copyright © 2016年 hznucai. All rights reserved.
//

import Foundation
import UIKit
enum DrawingMode:Int{
    case None = 0
    case Paint
    case Erase
}
class PIDrawView: UIView{
    var drawingMode = DrawingMode.None
    var selectedColor = UIColor.redColor()
    var previousPoint = CGPointMake(0, 0)
    var currentPoint = CGPointMake(0, 0)
    var viewImage = UIImage()
   
    override func drawRect(rect: CGRect) {
        self.viewImage.drawInRect(self.bounds)
    }
    func setDrawingMode(drawingMode:DrawingMode) {
        self.drawingMode = drawingMode
    }

func eraseLine() {
        UIGraphicsBeginImageContext(self.bounds.size)
        self.viewImage.drawInRect(self.bounds)
    //背景与画板的混合模式
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), .Clear)
    //设置线条两端的样式为圆角
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), .Round)
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 10)
        CGContextBeginPath(UIGraphicsGetCurrentContext())
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), .Clear)
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), previousPoint.x, previousPoint.y)
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y)
        CGContextStrokePath(UIGraphicsGetCurrentContext())
        self.viewImage = UIGraphicsGetImageFromCurrentImageContext()
        previousPoint = currentPoint
        self.setNeedsDisplay()
    }
    func drawLineNew() {
        UIGraphicsBeginImageContext(self.bounds.size)
        self.viewImage.drawInRect(self.bounds)
        CGContextSetLineCap(UIGraphicsGetCurrentContext(),.Round)
        CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), self.selectedColor.CGColor)
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 10)
        CGContextBeginPath(UIGraphicsGetCurrentContext())
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), previousPoint.x, previousPoint.y)
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y)
        CGContextStrokePath(UIGraphicsGetCurrentContext())
        self.viewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        previousPoint = currentPoint
        self.setNeedsDisplay()
    }
    func handleTouches() {
        if self.drawingMode == .None {
            
        }else if self.drawingMode == .Paint{
            self.drawLineNew()
        }else{
            self.eraseLine()
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //记下第一次的触摸点
        let p = touches.first?.locationInView(self)
        previousPoint = p!
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //记下滑动时的触摸点
        currentPoint = (touches.first?.locationInView(self))!
        self.handleTouches()
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //记下最后的触摸点
        currentPoint = (touches.first?.locationInView(self))!
        self.handleTouches()
    }
}