//
//  Clock.swift
//  InterviewTask
//
//  Created by Manish Mahajan  on 12/06/20.
//  Copyright © 2020 Manish Mahajan. All rights reserved.


import UIKit

@IBDesignable
class ClockView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //common func to init our view
    private func setupView() {
        setup()
    }
    
    var dial = CAShapeLayer()
    var pointer = CAShapeLayer()
    var numbersLayer = CALayer()
    var animating : Bool = false {
        didSet {
            if animating {
                let animation = CABasicAnimation(keyPath: "transform.rotation.z")
                animation.duration = 60
                animation.fromValue = 0
                animation.toValue = Float.pi * 2
                animation.repeatCount = .greatestFiniteMagnitude
                pointer.add(animation, forKey: "time")
            } else {
                pointer.removeAllAnimations()
            }
        }
    }
    
    func drawNumbers() {
        numbersLayer.bounds = bounds
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        numbersLayer.position = center
        
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        let image = renderer.image { canvas in
            let context = canvas.cgContext
            
            for i in 1...60 {
                context.translateBy(x: center.x, y: center.y)
                context.rotate(by: CGFloat.pi * 2 / 60)
                context.translateBy(x: -center.x, y: -center.y)
                draw(number: i)
            }
        }
        numbersLayer.contents = image.cgImage
    }
    
    private func setup() {
        layer.addSublayer(dial)
        layer.addSublayer(numbersLayer)
        layer.addSublayer(pointer)
        
        
        dial.strokeColor = UIColor.FlatColor.SecondaryColor.cgColor
        dial.fillColor = UIColor.FlatColor.PrimaryColor.cgColor
        
        dial.shadowColor = UIColor.gray.cgColor
        dial.shadowOpacity = 0.7
        dial.shadowRadius = 8
        dial.shadowOffset = .zero
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let dialPath = UIBezierPath(ovalIn: bounds)
        dial.path = dialPath.cgPath
        let path = buildArrow(width: 5, length: bounds.midX - 25, depth: 20)
        pointer.path = path.cgPath
        pointer.strokeColor = UIColor.FlatColor.SecondaryColor.cgColor
        pointer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        pointer.lineWidth = 2
        pointer.lineCap = CAShapeLayerLineCap.round
        drawNumbers()
    }
    
    func buildArrow(width: CGFloat, length: CGFloat, depth: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: .zero)
        let endPoint = CGPoint(x: 0, y: -length)
        path.addLine(to: endPoint)
        path.move(to: CGPoint(x: 0-width, y: endPoint.y + depth))
        path.addLine(to: endPoint)
        path.move(to: CGPoint(x: width, y: endPoint.y + depth))
        path.addLine(to: endPoint)
        return path
    }
    
    func draw(number: Int) {
        let number = number%5 == 0 ? "\(number)" : "|"
        let string = number as NSString
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        let size = string.size(withAttributes: attributes)
        string.draw(at: CGPoint(x: bounds.width/2 - size.width/2, y: 10), withAttributes: attributes)
    }
}

