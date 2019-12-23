//
//  YSCameraResultView.swift
//  YSViewsCollector
//
//  Created by 葛燕生 on 2019/12/20.
//  Copyright © 2019 葛燕生. All rights reserved.
//

import UIKit

class YSCameraResultView: UIView {

  var hiddenCameraResultBlock: (() -> Void)?
  var image: UIImage? {
    didSet {
      imageView.image = image
    }
  }
  
  private lazy var flashView: UIView = UIView().then { (flashView) in
    flashView.isHidden = true
    flashView.backgroundColor = UIColor.white.withAlphaComponent(0)
  }
  private lazy var imageView: UIImageView = UIImageView().then { (imageView) in
    imageView.contentMode = .scaleAspectFill
  }
  private lazy var quitSaveImageButton: UIButton = UIButton().then { (quitBtn) in
    quitBtn.setTitle("放弃", for: .normal)
    quitBtn.backgroundColor = UIColor.blue
    quitBtn.layer.cornerRadius = 22.5
    quitBtn.layer.masksToBounds = true
    quitBtn.addTarget(self, action: #selector(hiddenShowView), for: .touchUpInside)
  }
  private lazy var confirmSaveImageButton: UIButton = UIButton().then { (confirmBtn) in
    confirmBtn.setTitle("确认", for: .normal)
    confirmBtn.backgroundColor = UIColor.blue
    confirmBtn.layer.cornerRadius = 22.5
    confirmBtn.layer.masksToBounds = true
  }
  
  convenience init() {
    self.init(frame: .zero)
    backgroundColor = UIColor.black
    initSubviews()
    imageView.image = image
  }
  
  // MARK: action methods
  
  @objc func hiddenShowView() {
    hiddenCameraResultBlock?()
    isHidden = true
  }
  
  // MARK: private methods
  
  func showEffect(_ flash: Bool, completion: (() -> Void)?) {
    if !flash {
      return
    }
    flashView.isHidden = false
    flashView.backgroundColor = UIColor.white.withAlphaComponent(0)
    UIView.animate(withDuration: 0.3, animations: {
      self.flashView.backgroundColor = UIColor.white.withAlphaComponent(1)
    }) { (isFinish) in
      if isFinish {
        self.flashView.isHidden = true
        completion?()
      }
    }
  }
  
  // MARK: init subviews
  
  func initSubviews() {
    addSubview(imageView)
    addSubview(quitSaveImageButton)
    addSubview(confirmSaveImageButton)
    addSubview(flashView)
    
    imageView.snp.makeConstraints { (make) in
      if #available(iOS 11, *) {
        make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(50)
      } else {
        make.top.equalToSuperview().inset(50)
      }
      make.left.equalToSuperview().inset(25)
      make.centerX.equalToSuperview()
      make.bottom.equalTo(quitSaveImageButton.snp.top).offset(-50)
    }
    
    quitSaveImageButton.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(25)
      make.bottom.equalToSuperview().inset(45)
      make.height.equalTo(45)
      make.right.equalTo(confirmSaveImageButton.snp.left).offset(-50)
      make.width.equalTo(confirmSaveImageButton)
    }
    
    confirmSaveImageButton.snp.makeConstraints { (make) in
      make.right.equalToSuperview().inset(25)
      make.bottom.equalToSuperview().inset(45)
      make.height.equalTo(45)
    }
    
    flashView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
}
