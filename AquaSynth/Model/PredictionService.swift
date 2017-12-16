//
//  PredictionService.swift
//  AquaSynth
//
//  Created by Vincent Smithers on 9/23/17.
//  Copyright © 2017 Vincent Smithers. All rights reserved.
//

import UIKit
import CoreML

public class AsynthPredictionService: NSObject {
    
    let model = Asynth()
    let dimension: Int
    var currentLabel = "N/A"
    var currentScore: Double = 0
    var currentStill: [String: Double] = ["still": 0]
    var currentDisturbed:[String: Double] = ["disturbedA": 0]
    var currentXa: [String: Double] = ["xA": 0]
    
    public init(dimension: Int) {
        self.dimension = dimension
    }
    
    open func predict(image: UIImage) -> AsynthResult? {
        var result: AsynthResult?
        guard let buffer  = image.toPixelBuffer(image: image, dimension: dimension) else { fatalError("Could not convert image to pixel buffer") }
        
        if let prediction = try? model.prediction(data: buffer) {
            
            prediction.prob.forEach({ (label, score) in
                let realNum = score * Double(100)
                switch label {
                case "still":
                    currentStill["still"] = realNum > 1.0 || realNum < 0.001 ? 100 : realNum
                    print("STILL \(currentStill["still"] ?? 0)")
                case "disturbedA":
                    currentDisturbed["disturbedA"] = realNum > 1.0 || realNum < 0.001 ? 100 : realNum * 10
                    print("disturbed \(currentDisturbed["disturbedA"] ?? 0)")
                case "xA":
                    currentXa["xA"] = realNum > 1.0 || realNum < 0.001 ? 100 : realNum
                default: break
                }
            })
            
            var currentLow: Double = 101
            let predictions = [currentStill, currentDisturbed, currentXa]
            predictions.forEach({ (val) in
                if val.values.first! < currentLow {
                    currentLow = val.values.first!
                    currentLabel = val.keys.first!
                    currentScore = currentLow
                }
            })
            
            if currentLow == 100  {
                result = AsynthResult(className: "xA", probability: 19)
            } else if currentLow < 0.0015 && currentDisturbed["disturbedA"] ?? 0.0 < 0.001 {
                result = AsynthResult(className: "disturbedA", probability: currentScore * 3000)
            } else {
                result = AsynthResult(className: currentLabel, probability: currentScore * 30000)
                if currentLabel == "disturbedA" {
                    result = AsynthResult(className: currentLabel, probability: currentScore * 3000)
                }
            }
            
            currentScore = 0
            currentStill = ["still": 0]
            currentDisturbed = ["disturbedA": 0]
            currentXa = ["xA": 0]
            return result
        }
        return nil
    }
}
