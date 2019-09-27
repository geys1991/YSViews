//
//  YSMenuItemContainerView.swift
//  YS_G
//
//  Created by 葛燕生 on 2019/7/31.
//  Copyright © 2019 北京瓴岳信息技术有限公司. All rights reserved.
//

import UIKit
import Then

class YSMenuItemView: UIView {
  
  var index: Int = 0
  var selectedMenuItemBlock: ((_ index: Int) -> Void)?
  
  var itemTitle: UIButton = UIButton().then { (button) in
    button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
    button.titleLabel?.textColor = UIColor.darkText

    button.setTitleColor(UIColor.darkText, for: .normal)
    button.setTitleColor(UIColor.red, for: .selected)
  }
  var title: String = "" {
    didSet {
      itemTitle.setTitle(title, for: .normal)
    }
  }
  
  // MARK: init
  
  convenience init() {
    self.init(frame: .zero)
    initSubviews()
    itemTitle.addTarget(self, action: #selector(selectedAction), for: .touchUpInside)
  }
  
  // MARK: action method
  
  @objc func selectedAction() {
    selectedMenuItemBlock?(index)
  }
  
  // MARK: subviews
  
  func initSubviews() {
    
    addSubview(itemTitle)
    
    itemTitle.snp.makeConstraints { (make) in
      make.left.top.equalToSuperview()
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview()
    }
  }
}

class YSMenuItemContainerView: UIScrollView {
  
  private var itemWidth: CGFloat {
    let itemTempWidth = UIScreen.main.bounds.size.width / CGFloat(itemTitles.count)
    return max(60, itemTempWidth)
  }
  private var slideViewWidth: CGFloat {
    return itemWidth / 2.0
  }
  
  var currentSelectedIndexBlock: ((_ currentIndex: Int) -> Void)?
  
  var itemViews: [YSMenuItemView] = []
  var itemTitles: [String] = []
  var itemSelectedIndex: Int = 0 {
    didSet {
      refreshItemStatus()
      animatedSlideView()
      currentSelectedIndexBlock?(itemSelectedIndex)
    }
  }
  private var slideView: UIView = {
    let slide = UIView()
    slide.backgroundColor = UIColor.blue
    return slide
  }()
  private lazy var lineView: UIView = {
    let lineView = UIView()
    lineView.backgroundColor = UIColor.lightText
    return lineView
  }()
  
  // MARK: init method
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    showsHorizontalScrollIndicator = false
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: public method
  
  func setItemTitles(_ titles: [String]) {
    itemTitles = titles
    DispatchQueue.main.async {
      self.initSubviews()
    }
  }
  
  // MARK: private method
  
  private func animatedSlideView() {
    let offsetY: CGFloat = CGFloat(itemSelectedIndex) * itemWidth + (itemWidth - slideViewWidth) / 2
    slideView.snp.updateConstraints { (make) in
      make.left.equalTo(offsetY)
    }
    UIView.animate(withDuration: 0.5) {
      self.layoutIfNeeded()
    }
  }
  
  private func refreshItemStatus() {
    itemViews.enumerated().forEach { (offset, element) in
      element.itemTitle.isSelected = offset == itemSelectedIndex
    }
  }
  
  // MARK: init subviews
  func initSubviews() {
    contentSize = CGSize(width: CGFloat(itemTitles.count) * itemWidth, height: 0)

    addSubview(slideView)
    addSubview(lineView)

    var offsetY: CGFloat = 0
    for index in 0..<itemTitles.count {
      let itemView = YSMenuItemView()
      itemView.title = itemTitles[index]
      itemView.index = index
      itemView.selectedMenuItemBlock = { [weak self] (index) in
        if let strongSelf = self {
          strongSelf.itemSelectedIndex = index
        }
      }
      itemViews.append(itemView)
    }
    
    itemViews.forEach { (element) in
      addSubview(element)
      element.snp.makeConstraints { (make) in
        make.width.equalTo(itemWidth)
        make.top.equalToSuperview()
        make.centerY.equalToSuperview()
        make.left.equalToSuperview().offset(offsetY)
      }
      offsetY = offsetY + itemWidth
    }
    refreshItemStatus()
    
    // slide view
    slideView.snp.makeConstraints { (make) in
      make.bottom.equalToSuperview()
      make.height.equalTo(2)
      make.width.equalTo(slideViewWidth)
      make.left.equalToSuperview().offset((itemWidth - slideViewWidth) / 2)
    }
    
    // line view
    lineView.snp.makeConstraints { (make) in
      make.bottom.equalToSuperview()
      make.left.equalToSuperview()
      make.centerX.equalToSuperview()
      make.height.equalTo(1)
    }
  }
}
