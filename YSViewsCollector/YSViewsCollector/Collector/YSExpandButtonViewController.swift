//
//  YSExpandButtonViewController.swift
//  YSViewsCollector
//
//  Created by 葛燕生 on 2020/8/27.
//  Copyright © 2020 葛燕生. All rights reserved.
//

import UIKit

class YSExpandButtonViewController: UIViewController {

  lazy var button = UIButton().then { (expand) in
    expand.backgroundColor = UIColor.red
    expand.addTarget(self, action: #selector(click), for: .touchUpInside)
    expand.hw_clickEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white
    view.addSubview(button)
    
    button.snp.makeConstraints { (make) in
      make.size.equalTo(CGSize(width: 25, height: 25))
      make.centerX.centerY.equalToSuperview()
    }
  }
  
  @objc func click() {
    print("Click")
  }
  
}
