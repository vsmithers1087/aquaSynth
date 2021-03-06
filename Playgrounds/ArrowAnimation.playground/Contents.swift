//: Playground - noun: a place where people can play

import UIKit

import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
PlaygroundPage.current.liveView = containerView

class ArrowButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       setBackgroundImage(UIImage(named: "background"), for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func beginArrowAnimation() {
        let point1 = CGPoint(x: 40, y: 33)
        let point2 = CGPoint(x: 40, y: frame.height - 33)
        let point3 = CGPoint(x: frame.width - 33, y: frame.height / 2)
        let path = UIBezierPath()
        path.move(to: point1)
        path.addLine(to: point2)
        path.addLine(to: point3)
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = bounds
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 3.0
        shapeLayer.lineCap = kCALineCapRound
        
        shapeLayer.strokeStart = 0
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.duration = 3
        strokeAnimation.fromValue = 0
        strokeAnimation.toValue = 1
        strokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        strokeAnimation.repeatCount = .infinity
        shapeLayer.add(strokeAnimation, forKey: "strokeAnim")
        layer.addSublayer(shapeLayer)
    }
}

let arrowButton = ArrowButton(frame: CGRect(x: 200, y: 200, width: 100, height: 100))
arrowButton.beginArrowAnimation()
containerView.addSubview(arrowButton)

