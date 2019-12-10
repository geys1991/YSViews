//
//  YSScaleImageView.swift
//  YSViewsCollector
//
//  Created by 葛燕生 on 2019/12/9.
//  Copyright © 2019 葛燕生. All rights reserved.
//

import UIKit

class YSScaleImageView: UIScrollView {
  
  let kMaxZoomScale: CGFloat = 3
  let kMinZoomScale: CGFloat = 1
  
  var currentZoomScale: Int = 1
  
  var contentImage: UIImage? {
    didSet {
      if let image = contentImage {
        contentImageView.image = image
      }
    }
  }
  private let contentImageView: UIImageView = UIImageView().then { (imageView) in
    imageView.isUserInteractionEnabled = true
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
  }

  // MARK: init methods
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    maximumZoomScale = kMaxZoomScale
    minimumZoomScale = kMinZoomScale
    delegate = self
    initSubviews()
    configGesture()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: gesture methods
  
  func configGesture() {
    let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction(_:)))
    doubleTap.numberOfTapsRequired = 2
    contentImageView.addGestureRecognizer(doubleTap)
  }
  
  @objc func doubleTapAction(_ gesture: UITapGestureRecognizer) {
    if gesture.numberOfTapsRequired == 2 {
      var newZoomScale: CGFloat = 1
      if self.zoomScale == 1 {
        // 放大
        newZoomScale = zoomScale * 2
      } else {
        // 缩小
        newZoomScale = zoomScale / 2
      }
      let gestureCenter = gesture.location(in: gesture.view)
      let zoomedRect = zoomRect(for: newZoomScale, with: gestureCenter)
      zoom(to: zoomedRect, animated: true)
    }
  }
  
  // MARK: private method
  
  func zoomRect(for scale: CGFloat, with center: CGPoint) -> CGRect {
    let sizeWidth = frame.size.width / scale
    let sizeHeight = frame.size.height / scale
    
    let originX = center.x - sizeWidth / 2
    let originY = center.y - sizeHeight / 2
    
    let zoomRect = CGRect(x: originX, y: originY, width: sizeWidth, height: sizeHeight)
    return zoomRect
  }
  
  // MARK: init subviews
  
  func initSubviews() {
    contentImageView.frame = CGRect(x: 0, y: 300, width: frame.size.width, height: 300)
    addSubview(contentImageView)
  }
  
}

typealias YSScaleScrollViewDelegate = YSScaleImageView
extension YSScaleScrollViewDelegate: UIScrollViewDelegate {
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return contentImageView
  }
  
  func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
    scrollView.setZoomScale( scale + 0.01, animated: false)
    scrollView.setZoomScale( scale, animated: false)
  }

  func scrollViewDidZoom(_ scrollView: UIScrollView) {
    let offsetX = scrollView.bounds.size.width > scrollView.contentSize.width ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0
    let offsetY = scrollView.bounds.size.height > scrollView.contentSize.height ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0
    contentImageView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
   }
  
}
