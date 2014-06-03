//
//  BDVProgressViewS.swift
//  BDVProgressView
//
//  Created by Dima Belov on 6/2/14.
//  Copyright (c) 2014 dnepr. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore


let radius:CGFloat = 100

class ProgressView: UIView {
    var innerProgress: CGFloat
    var progress: CGFloat {
    get {
        return innerProgress;
    }
    set {
        if newValue < 0 || newValue > 100 {
            innerProgress = newValue < 0 ? 0 : (newValue > 100) ? 100 : newValue;
        }
        else {
            setProgress(newValue, animated: false)
        }
        
    }
    }
    var progressLabel: UILabel!
    var progressShape: CAShapeLayer!
    
    
    
    init(frame:CGRect) {
        innerProgress = 0.0
        super.init(frame:frame);
        internalInit()
    }
    
    init(coder aDecoder: NSCoder!) {
        innerProgress = 0.0
        super.init(coder: aDecoder)
        internalInit()
    }
    
    func internalInit() {
        
        progressLabel = UILabel(frame:self.bounds)
        progressLabel.font = UIFont.systemFontOfSize(50)
        
        progressLabel.attributedText = formattedProgressPercent(0.0)
        progressLabel.numberOfLines = 1
        progressLabel.textColor = UIColor.greenColor();
        progressLabel.textAlignment = NSTextAlignment.Center
        progressLabel.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleHeight
        
        addSubview(progressLabel)
        
        progressShape = CAShapeLayer()
        progressShape.strokeColor = UIColor.greenColor().CGColor
        progressShape.fillColor = UIColor.clearColor().CGColor
        progressShape.lineWidth = 20;
        progressShape.strokeEnd = 0;
        self.layer.addSublayer(progressShape)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews();
        progressShape.path = createProgressPath(100.0).CGPath
    }
    
    func setProgress(progress:CGFloat, animated:Bool) {
        var oldProgress = innerProgress;
        innerProgress = progress/100;
        
        //Make sure progress is within limits
        var percent = progress/100;
        
        
        progressLabel.attributedText = formattedProgressPercent(progress)
        
        if(animated) {
            
            let duration = CGFloat.abs((percent - oldProgress));
            var pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
            pathAnimation.duration = CFTimeInterval(duration)
            pathAnimation.fromValue = oldProgress;
            pathAnimation.toValue = percent;
            progressShape.addAnimation(pathAnimation, forKey: "strokeEnd")
        }
        updateShapeLayerWithPercent(percent)
    }
    
    
    /**
    *  Disables the implicit animation on the CAShapeLayer and sets the strokeEnd
    *
    *  @param percent a value from 0.0 to 1.0
    */
    func updateShapeLayerWithPercent(percent: CGFloat) {
        CATransaction.begin();
        CATransaction.setDisableActions(true)
        progressShape.strokeEnd = percent
        CATransaction.commit()
    }
    
    
    func formattedProgressPercent(percent: CGFloat) -> NSAttributedString {
        
        var attrString = NSMutableAttributedString(string: NSString(format: "%.02f%%", percent))
        attrString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(14), range: NSMakeRange(attrString.length-1, 1));
        
        return attrString;
    }
    
    
    func degreeToRadian(degree: CGFloat) -> CGFloat {
        return 3.14159265359 * degree / 180.0
    }
    
    func createProgressPath(percent: CGFloat) -> UIBezierPath
    {
        
        //Offset the angle to start at the bottom of the label
        var degrees = (360 * percent/100) + 90;
        
        var path = UIBezierPath(arcCenter: progressLabel.center, radius: radius, startAngle: degreeToRadian(90), endAngle: degreeToRadian(degrees), clockwise: true)
        
        return path;
    }
    
}