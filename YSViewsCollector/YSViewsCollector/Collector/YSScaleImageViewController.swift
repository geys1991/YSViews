//
//  YSScaleImageViewController.swift
//  YSViewsCollector
//
//  Created by 葛燕生 on 2019/12/9.
//  Copyright © 2019 葛燕生. All rights reserved.
//

import UIKit

class YSScaleImageViewController: UIViewController {
  
  var scaleImageView: YSScaleImageView = {
    let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    let imageView = YSScaleImageView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
    return imageView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white
    initSubviews()
    setContent()
  }
  
  // MARK: private methods
  
  func setContent() {
    if let imagePath = Bundle.main.path(forResource: "image_littleAnimal", ofType: "jpg") {
      scaleImageView.contentImage = UIImage(contentsOfFile: imagePath)
    }
    
    let itemTempWidth = UIScreen.main.bounds.size.width
    scaleImageView.contentSize = CGSize(width: itemTempWidth, height: 300)
  }
  
  // MARK: init subviews
  
  func initSubviews() {
    view.addSubview(scaleImageView)
  }

}
