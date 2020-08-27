//
//  YSMultiInputViewController.swift
//  YSViewsCollector
//
//  Created by 葛燕生 on 2020/7/21.
//  Copyright © 2020 葛燕生. All rights reserved.
//

import UIKit

class YSMultiInputViewController: UIViewController {

  var multiInputView: YSMultiInputAlertView = {
    let iV = YSMultiInputAlertView()
    iV.configInputView()
    iV.layer.borderColor = UIColor.black.cgColor
    iV.layer.borderWidth = 1
    iV.layer.cornerRadius = 12
    iV.layer.masksToBounds = true
    return iV
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white
    
    view.addSubview(multiInputView)
    
    multiInputView.snp.makeConstraints { (make) in
      make.height.equalTo(300)
      make.centerY.centerX.equalToSuperview()
      make.left.equalToSuperview().offset(40)
    }
  }
}
