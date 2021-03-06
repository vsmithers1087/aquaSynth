//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
containerView.backgroundColor = UIColor.black
let imageView = UIImageView(frame: containerView.frame)
imageView.image = UIImage(named: "background.png")
containerView.addSubview(imageView)
PlaygroundPage.current.liveView = containerView

class IconWaveAnimation {

    var imageView: UIImageView
    
    var offsetX: CGFloat {
        return imageView.frame.width * 0.10
    }

    init(imageView: UIImageView) {
        self.imageView = imageView
    }

    func animatePath(points: [CGPoint], level: CGFloat) {
        let verticalZero = imageView.frame.height / 2
        guard points.count > 0 else { return }
        let median = points.count / 2
        imageView.layer.sublayers?.removeAll()
        let path = UIBezierPath()
        path.move(to: points.first!)
        for (index, point) in points.enumerated() {
            if index > 1 && index < points.count - 1 {
                let medianDifference = abs(median - abs(index - median))
                let offsetY = index % 2 == 0 ? CGFloat(medianDifference * Int(level)) : -CGFloat(medianDifference * Int(level))
                let newPoint = CGPoint(x: point.x, y: point.y + offsetY)
                let controlPoint = newPoint.y > verticalZero ? CGPoint(x: newPoint.x - 8, y: newPoint.y + 150) : CGPoint(x: newPoint.x - 20, y: newPoint.y - 150)
                path.addQuadCurve(to: newPoint, controlPoint: controlPoint)
            }
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = containerView.frame
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 6.0
        shapeLayer.lineCap = kCALineCapRound
        
        shapeLayer.lineDashPattern = [5]
        
        let lineDashPhaseAnimation = CABasicAnimation(keyPath: "lineDashPhase")
        lineDashPhaseAnimation.byValue = 10.0
        lineDashPhaseAnimation.duration = 1
        lineDashPhaseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        lineDashPhaseAnimation.repeatCount = 1
        
        shapeLayer.add(lineDashPhaseAnimation, forKey: "lineDashPhaseAnimation")
        
        shapeLayer.lineWidth = 4.0
        
        let lineWidthAnimation = CABasicAnimation(keyPath: "lineWidth")
        lineWidthAnimation.toValue = 8.0
        lineWidthAnimation.duration = 1
        lineWidthAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        lineWidthAnimation.autoreverses = true
        lineWidthAnimation.repeatCount = 1
        
        shapeLayer.add(lineWidthAnimation, forKey: "lineWidthAnimation")
        
        shapeLayer.strokeStart = 0
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.duration = 1
        strokeAnimation.fromValue = 0
        strokeAnimation.toValue = 1
        strokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        shapeLayer.add(strokeAnimation, forKey: "strokeAnim")
        imageView.layer.addSublayer(shapeLayer)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + strokeAnimation.duration) {
        }
    }
    
    func mapPointsFor(level: CGFloat) {
        let pointCount = 13
        let strideX = (imageView.frame.width - offsetX) / CGFloat(pointCount)
        let verticalZero = imageView.frame.height / 2
        var points = [CGPoint(x: offsetX, y: verticalZero)]
        for point in 1...pointCount {
            let x = CGFloat(point) * strideX
            let y = point % 2 == 0 ? verticalZero + level : verticalZero - level
            let endPoint = CGPoint(x: x, y: y)
            points.append(endPoint)
        }
        //print(points)
        animatePath(points: points, level: level)
    }
}

let iconAnimation = IconWaveAnimation(imageView: imageView)
iconAnimation.mapPointsFor(level: 10)


