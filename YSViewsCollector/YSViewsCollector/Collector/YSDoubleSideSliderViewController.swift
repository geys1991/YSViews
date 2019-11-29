//
//  YSDoubleSideSliderViewController.swift
//  YSViewsCollector
//
//  Created by 葛燕生 on 2019/11/29.
//  Copyright © 2019 葛燕生. All rights reserved.
//

import UIKit

class YSDoubleSideSliderViewController: UIViewController {
  
  let doubleSliderView = YSDoubleSideSliderView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white
    initSubviews()
  }
  
  // MARK: init subviews
  
  func initSubviews() {
    
    view.addSubview(doubleSliderView)
    
    doubleSliderView.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.centerX.equalToSuperview()
      make.left.equalToSuperview()
      make.height.equalTo(300)
    }
    
  }
  
}
