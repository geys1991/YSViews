//
//  YSDoubleWaveViewController.swift
//  YSViewsCollector
//
//  Created by 葛燕生 on 2020/7/24.
//  Copyright © 2020 葛燕生. All rights reserved.
//

import UIKit

class YSDoubleWaveViewController: UIViewController {
  
  var displayLink: CADisplayLink?
  var shapeLayer1: CAShapeLayer = CAShapeLayer()
  var shapeLayer2: CAShapeLayer = CAShapeLayer()
  var path1: UIBezierPath?
  var path2: UIBezierPath?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.white
    
    
    shapeLayer1.frame = CGRect(x: 0, y: 100, width: 375, height: 150)
    view.layer.addSublayer(shapeLayer1)
    
    shapeLayer1.fillColor = UIColor.black.cgColor
    
//    displayLink = CADisplayLink(target: self, selector: #selector(drawPath))
//    displayLink?.add(to: RunLoop.current, forMode: .common)
    createTimer()
  }
  
  func createTimer() {
    let timer = Timer(timeInterval: TimeInterval(1), target: self, selector: #selector(drawPath), userInfo: nil, repeats: true)
    timer.fire()
  }
  
  
  
  @objc func drawPath() {
    print("---")
    var i = 0
    
    let A: CGFloat = 10.0
    let k: CGFloat = 0.0
    let ω: CGFloat = 0.03
    let φ: CGFloat = CGFloat(0 + i)
    
    path1 = UIBezierPath()
    path1?.move(to: CGPoint.zero)
    
    for index in 0...375 {
      let x = CGFloat(index)
      let y: CGFloat = A + sin(ω * CGFloat(x) + φ) + k
      let point = CGPoint(x: x, y: y)
      path1?.addLine(to: point)
    }
    path1?.addLine(to: CGPoint(x: 375, y: -100))
    
    path1?.lineWidth = 1
    shapeLayer1.path = path1?.cgPath
  }

}
