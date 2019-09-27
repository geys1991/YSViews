//
//  YSMenuItemViewController.swift
//  YSViewsCollector
//
//  Created by 葛燕生 on 2019/9/27.
//  Copyright © 2019 葛燕生. All rights reserved.
//

import UIKit

class YSMenuItemViewController: UIViewController {
  
  private lazy var menuItemViews: YSMenuItemContainerView = YSMenuItemContainerView().then { (menuView) in
    let titles = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    menuView.setItemTitles(titles)
    menuView.currentSelectedIndexBlock = { [weak self] (index) in
//      if let strongSelf = self {
//        let offsetX: CGFloat = UIScreen.main.bounds.size.width * CGFloat(index)
//        strongSelf.scrollContainerView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
//      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white
    initSubviews()
  }
  
  // MARK: init subviews
  
  func initSubviews() {
    view.addSubview(menuItemViews)
    menuItemViews.snp.makeConstraints { (make) in
      if #available(iOS 11.0, *) {
        make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      } else {
        
      }
      make.left.equalToSuperview()
      make.centerX.equalToSuperview()
      make.height.equalTo(48)
    }
  }
  
}
