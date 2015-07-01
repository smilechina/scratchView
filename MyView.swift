//
//  MyView.swift
//  draw
//
//  Created by zhaoxiaolu on 15/5/28.
//  Copyright (c) 2015年 zhaoxiaolu. All rights reserved.
//

import UIKit

class MyView: UIView {
    
    /**
    要刮的底图.
    */
    var _image:UIImage!
    
    /**
    涂层图片.
    */
    var _surfaceImage:UIImage!

    var boImageView:UIImageView!
    var surfaceImageView:UIImageView!
    var imageLayer:CALayer!
    var shapeLayer:CAShapeLayer!
    var path:CGMutablePathRef!
    /**
    涂层是否已被刮开
    */
    var isOpen:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.boImageView = UIImageView(frame: self.bounds)
        self.addSubview(boImageView)
        
        self.surfaceImageView = UIImageView(frame: self.bounds)
        self.surfaceImageView.image = self.imageByColor(UIColor(white: 0.3, alpha: 0.8))
        self.addSubview(self.surfaceImageView)
        
        self.imageLayer = CALayer(layer: layer)
        self.imageLayer.frame = self.bounds
//        self.imageLayer.backgroundColor = UIColor(white: 0.8, alpha: 0.8).CGColor;
        self.layer.addSublayer(self.imageLayer)
        
        self.shapeLayer = CAShapeLayer(layer: layer)
        self.shapeLayer.frame = self.bounds
        self.shapeLayer.lineCap = kCALineCapRound
        self.shapeLayer.lineJoin = kCALineJoinRound
        self.shapeLayer.lineWidth = 30
        self.shapeLayer.strokeColor = UIColor.blackColor().CGColor
        self.shapeLayer.fillColor = nil
//        self.shapeLayer.backgroundColor = UIColor.blackColor().CGColor;
//        self.shapeLayer.backgroundColor = UIColor.blackColor().CGColor;
//        var op:CABasicAnimation = CABasicAnimation(keyPath: "opacity")
//        op.fromValue = NSNumber(float: 1.0)
//        op.toValue = NSNumber(float: 0.5)
        self.layer.addSublayer(self.shapeLayer)
        self.imageLayer.mask = self.shapeLayer
        
        self.path = CGPathCreateMutable()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        if !self.isOpen {
            var touch:UITouch = (touches as NSSet).anyObject()! as! UITouch
            var point:CGPoint = touch.locationInView(self)
            CGPathMoveToPoint(self.path, nil, point.x, point.y)
            var path:CGMutablePathRef = CGPathCreateMutableCopy(self.path)
            self.shapeLayer.path = path
//            CGPathRelease(path)
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
        if !self.isOpen {
            var touch:UITouch = (touches as NSSet).anyObject()! as! UITouch
            var point:CGPoint = touch.locationInView(self)
            CGPathAddLineToPoint(self.path, nil, point.x, point.y)
            var path:CGMutablePathRef = CGPathCreateMutableCopy(self.path)
            self.shapeLayer.path = path
            //            CGPathRelease(path)
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        if !self.isOpen {
            self.checkForOpen()
        }
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        super.touchesCancelled(touches, withEvent: event)
        if !self.isOpen {
            self.checkForOpen()
        }
    }
    
    /**
    设置要刮的图片
    */
    func setImage(image:UIImage) {
        _image = image
        self.imageLayer.contents = image.CGImage
        self.boImageView.image = image
    }
    
    /**
    设置图层
    */
    func setSurfaceImage(surfaceImage:UIImage) {
        _surfaceImage = surfaceImage
        self.surfaceImageView.image = surfaceImage
    }
    
    /**
    重置刮刮卡涂层.
    */
    func reset() {
//        if self.path !=nil {
//            CGPathRelease(self.path)
//        }
        self.isOpen = false
        self.path = CGPathCreateMutable()
        self.shapeLayer.path = nil
        self.imageLayer.mask = self.shapeLayer
    }
    
    func checkForOpen() {
        var rect:CGRect = CGPathGetPathBoundingBox(self.path)
        
        var pointsArray:NSArray = self.getPointsArray()
        for value in pointsArray {
            var point:CGPoint = value.CGPointValue()
            if !CGRectContainsPoint(rect, point) {
                return
            }
        }
        
        self.isOpen = true
        
        UIGraphicsBeginImageContext(self.imageLayer.bounds.size)
        self.imageLayer.renderInContext(UIGraphicsGetCurrentContext())
        var image:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        var aa = UIImageView(frame: CGRectMake(10, 10, 70, 70))
        aa.image = image
        self.addSubview(aa)
        
        self.imageLayer.mask = nil
        
        println("ok。。。。。")
//        if self.
    }
    
    func getPointsArray() ->NSArray {
        var array:NSMutableArray = NSMutableArray()
        
        var width:CGFloat = CGRectGetWidth(self.bounds)
        var height:CGFloat = CGRectGetHeight(self.bounds)
        
        var topPoint:CGPoint = CGPointMake(width/2, height/6)
        var leftPoint:CGPoint = CGPointMake(width/6, height/2)
        var bottomPoint:CGPoint = CGPointMake(width/2, height-height/6)
        var rightPoint:CGPoint = CGPointMake(width-width/6, height/2)
        
        array.addObject(NSValue(CGPoint:topPoint))
        array.addObject(NSValue(CGPoint:leftPoint))
        array.addObject(NSValue(CGPoint:bottomPoint))
        array.addObject(NSValue(CGPoint:rightPoint))
        
        return array
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func imageByColor(color:UIColor) -> UIImage {
        var imageSize:CGSize = CGSizeMake(1, 1)
        UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.mainScreen().scale)
        color.set()
        UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height))
        var image:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}
