//
//  GradientArcLayer.swift
//  ProgressHUD
//
//  Created by igor on 8/18/17.
//  Copyright © 2017 igor. All rights reserved.
//

import Foundation
import UIKit

final class GradientArcLayer: CALayer {
    
    // MARK: - Constants
    
    private static let arcStartAngle = CGFloat.pi - CGFloat.pi / 4.0
    private static let arcEndAngle = CGFloat.pi / 2.0 - CGFloat.pi / 4.0

    // MARK: - Lifeycle
    
    private override init () {
        super.init()
    }
    
    convenience init(in parentView: UIView, fromColor: UIColor, toColor: UIColor, lineWidth: CGFloat) {
        self.init()
        bounds = parentView.bounds
        position = parentView.center
        let colors: [UIColor] = graint(fromColor: fromColor, toColor: toColor, count:4)
        let graintBounds = CGRect(origin: CGPoint.zero,
                                  size: CGSize(width: bounds.width / 2.0, height: bounds.height / 2.0))
        for i in 0..<colors.count - 1 {
            let graint = CAGradientLayer()
            graint.bounds = graintBounds
            let valuePoint = positionArrayWith(bounds: bounds)[i]
            graint.position = valuePoint
            let fromColor = colors[i]
            let toColor = colors[i + 1]
            let colors = [fromColor.cgColor, toColor.cgColor]
            
            let locations = [0.1, 0.8]
            graint.colors = colors
            graint.locations = locations.flatMap({ NSNumber(value: $0) })
            graint.startPoint = startPoints[i]
            graint.endPoint = endPoints[i]
            addSublayer(graint)
        }
        //Set mask
        let arcLayer = CAShapeLayer()
        let center = bounds.height / 2.0
        let path = UIBezierPath(arcCenter: CGPoint(x: center, y: center),
                                radius: center - lineWidth / 2.0,
                                startAngle: GradientArcLayer.arcStartAngle,
                                endAngle: GradientArcLayer.arcEndAngle,
                                clockwise: true)
        arcLayer.path = path.cgPath
        arcLayer.fillColor = UIColor.clear.cgColor
        arcLayer.strokeColor = UIColor.green.cgColor
        arcLayer.lineWidth = lineWidth
        arcLayer.lineCap = kCALineCapRound
        mask = arcLayer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func graint(fromColor:UIColor, toColor:UIColor, count:Int) -> [UIColor]{
        var fromR:CGFloat = 0.0,fromG:CGFloat = 0.0,fromB:CGFloat = 0.0,fromAlpha:CGFloat = 0.0
        fromColor.getRed(&fromR,green: &fromG,blue: &fromB,alpha: &fromAlpha)
        
        var toR:CGFloat = 0.0,toG:CGFloat = 0.0,toB:CGFloat = 0.0,toAlpha:CGFloat = 0.0
        toColor.getRed(&toR,green: &toG,blue: &toB,alpha: &toAlpha)
        
        var result : [UIColor]! = [UIColor]()
        
        for i in 0...count {
            let oneR:CGFloat = fromR + (toR - fromR)/CGFloat(count) * CGFloat(i)
            let oneG : CGFloat = fromG + (toG - fromG)/CGFloat(count) * CGFloat(i)
            let oneB : CGFloat = fromB + (toB - fromB)/CGFloat(count) * CGFloat(i)
            let oneAlpha : CGFloat = fromAlpha + (toAlpha - fromAlpha)/CGFloat(count) * CGFloat(i)
            let oneColor = UIColor.init(red: oneR, green: oneG, blue: oneB, alpha: oneAlpha)
            result.append(oneColor)
        }
        return result
    }
    
    private func positionArrayWith(bounds:CGRect) -> [CGPoint] {
        let width = bounds.width / 4.0
        let height = bounds.height / 4.0
        let p13 = CGPoint(x: width * 1.0, y: height * 3.0)
        let p11 = CGPoint(x: width * 1.0, y: height * 1.0)
        let p31 = CGPoint(x: width * 3.0, y: height * 1.0)
        let p33 = CGPoint(x: width * 3.0, y: height * 3.0)
        return [p13, p11, p31, p33]
    }
    
    private var startPoints: [CGPoint] {
        return [CGPoint(x: 1, y: 1), CGPoint(x: 0, y: 1), CGPoint.zero, CGPoint(x: 1, y: 0)]
    }
    
    private var endPoints: [CGPoint] {
        return [CGPoint.zero, CGPoint(x: 1, y: 0), CGPoint(x: 1, y: 1), CGPoint(x: 0, y: 1)]
    }
    
    // MARK: - Public methods
    
    // This is what you call to draw a partial circle.
    internal func animateCircle(duration: TimeInterval, fromValue: CGFloat = 0.0, toValue: CGFloat = 1.0) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.isRemovedOnCompletion = true
        animation.duration = duration
        
        animation.fromValue = fromValue
        animation.toValue = toValue
        
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        let circleMask = self.mask as! CAShapeLayer
        circleMask.strokeEnd = toValue
        
        circleMask.removeAllAnimations()
        circleMask.add(animation, forKey: "animateCircle")
    }
    
    internal static func backgroundArcLayer(in parentView: UIView, lineWidth: CGFloat, color: UIColor) -> CAShapeLayer {
        let arcLayer = CAShapeLayer()
        let path = UIBezierPath(arcCenter: parentView.center,
                                radius: parentView.center.x - lineWidth / 2.0,
                                startAngle: GradientArcLayer.arcStartAngle,
                                endAngle: GradientArcLayer.arcEndAngle,
                                clockwise: true)
        arcLayer.path = path.cgPath
        arcLayer.fillColor = UIColor.clear.cgColor
        arcLayer.strokeColor = color.cgColor
        arcLayer.lineWidth = lineWidth
        arcLayer.lineCap = kCALineCapRound
        return arcLayer
    }
    
}
