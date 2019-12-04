//
//  YSDoubleSideSliderView.swift
//  YSViewsCollector
//
//  Created by 葛燕生 on 2019/11/28.
//  Copyright © 2019 葛燕生. All rights reserved.
//

import UIKit

class YSDoubleSideSliderView: UIView {
  
  let sliderMargin: CGFloat = 40
  
  // 用于实现 slider 滑块的隐藏效果
  private var dotImage: UIImage? = {
    let scaleSize = CGSize(width: 0.1, height: 0.1)
    UIGraphicsBeginImageContextWithOptions(scaleSize, false, UIScreen.main.scale)
    UIRectFill(CGRect(x: 0, y: 0, width: 0.1, height: 0.1))
    let dotImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return dotImage
  }()
  private var dotView: UIView = UIView().then { (dotView) in
    dotView.layer.cornerRadius = 3
    dotView.layer.masksToBounds = true
    dotView.backgroundColor = UIColor.init(red: 216 / 255.0, green: 216 / 255.0, blue: 216 / 255.0, alpha: 1)
  }
  private var sliderDot: UIImageView = UIImageView().then { (sliderDot) in
    sliderDot.isUserInteractionEnabled = true
    sliderDot.image = UIImage(named: "icon_slider_dot")
  }
  private var leftSliderView: UISlider = UISlider().then { (slider) in
    slider.minimumTrackTintColor = UIColor.red
    slider.maximumTrackTintColor = UIColor.lightGray
    slider.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
  }
  private var rightSliderView: UISlider = UISlider().then { (slider) in
    slider.isUserInteractionEnabled = false
    slider.minimumTrackTintColor = UIColor.red
    slider.maximumTrackTintColor = UIColor.lightGray
  }
  
  // MARK: init method
  
  convenience init() {
    self.init(frame: .zero)
    initSubviews()
    gestureConfig()
  }
  
  // MARK: action method
  
  @objc func dotPanAction(_ recognizer: UIPanGestureRecognizer) {
    let point = recognizer.translation(in: self)
    if let gestureView = recognizer.view {
      let moveToPoint = CGPoint(x: gestureView.center.x + point.x, y: gestureView.center.y)
      if moveToPoint.x <= sliderMargin || moveToPoint.x >= UIScreen.main.bounds.size.width - sliderMargin {
        return
      }
      gestureView.center = moveToPoint
      recognizer.setTranslation(CGPoint(x: 0, y: 0), in: self)
    }
    
    if recognizer.state == .changed {
      if let blockCenterPoint = recognizer.view?.center {
        let dotViewCenterPoint = dotView.center
        let distance = blockCenterPoint.x - dotViewCenterPoint.x
        if distance > 0 {
          let totalWidth = rightSliderView.frame.size.width
          let changedValue = distance / totalWidth
          leftSliderView.value = 0
          rightSliderView.value = Float(changedValue)
        } else {
          let totalWidth = leftSliderView.frame.size.width
          let changedValue = abs(distance) / totalWidth
          rightSliderView.value = 0
          leftSliderView.value = Float(changedValue)
        }
      }
    }
  }
  
  // MARK: private method
  
  private func gestureConfig() {
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dotPanAction(_:)))
    sliderDot.addGestureRecognizer(panGesture)
  }
  
  // MARK: init subviews
  
  private func initSubviews() {
    
    leftSliderView.setThumbImage(dotImage, for: .normal)
    rightSliderView.setThumbImage(dotImage, for: .normal)
    
    addSubview(leftSliderView)
    addSubview(rightSliderView)
    addSubview(dotView)
    addSubview(sliderDot)
    
    leftSliderView.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.left.equalToSuperview().inset(sliderMargin)
      make.right.equalTo(rightSliderView.snp.left)
      make.width.equalTo(rightSliderView.snp.width)
    }

    rightSliderView.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.right.equalToSuperview().inset(sliderMargin)
    }

    dotView.snp.makeConstraints { (make) in
      make.size.equalTo(CGSize(width: 6, height: 6))
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview()
    }

    sliderDot.snp.makeConstraints { (make) in
      make.size.equalTo(CGSize(width:26, height: 26))
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview()
    }
  }
}
