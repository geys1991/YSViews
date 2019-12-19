//
//  YSCameraResultViewController.swift
//  YSViewsCollector
//
//  Created by 葛燕生 on 2019/12/18.
//  Copyright © 2019 葛燕生. All rights reserved.
//

import UIKit

class YSCameraResultViewController: UIViewController {

  private var imageView: UIImageView = UIImageView()
  
  var takenImage: UIImage?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    initSubviews()
    
    if takenImage != nil {
      imageView.image = takenImage
    }
  }
  
  // MARK: init subviews
  
  func initSubviews() {
    view.addSubview(imageView)
    
    imageView.snp.makeConstraints { (make) in
      make.left.equalToSuperview()
      make.centerX.equalToSuperview()
      if #available(iOS 11, *) {
        make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
      } else {
        make.top.equalToSuperview()
        make.bottom.equalToSuperview()
      }
    }
  }

}
