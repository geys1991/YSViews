//
//  YSCameraCustomViewController.swift
//  YSViewsCollector
//
//  Created by 葛燕生 on 2019/12/11.
//  Copyright © 2019 葛燕生. All rights reserved.
//

import UIKit

class YSCameraCustomViewController: UIViewController {
  
  private lazy var cameraVC = YSCameraViewController()
  private lazy var preview: UIView = UIView().then { (view) in
    view.clipsToBounds = true
  }
  
  private lazy var switchFlashButton: UIButton = UIButton().then { (switchButton) in
    switchButton.setTitleColor(UIColor.white, for: .normal)
    switchButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    switchButton.setTitle("闪光 关", for: .normal)
    switchButton.addTarget(self, action: #selector(switchFlashAction), for: .touchUpInside)
  }
  
  private lazy var changeCameraPositionButton: UIButton = UIButton().then { (changePosition) in
    changePosition.setTitleColor(UIColor.white, for: .normal)
    changePosition.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    changePosition.setTitle("前置", for: .normal)
    changePosition.setTitle("后置", for: .selected)
    changePosition.addTarget(self, action: #selector(changeCameraPositionAction), for: .touchUpInside)
  }
  
  private lazy var takePicButton: UIButton = UIButton().then { (takePic) in
    takePic.setTitleColor(UIColor.red, for: .normal)
    takePic.titleLabel?.font = UIFont.systemFont(ofSize: 20)
    takePic.setTitle("Take", for: .normal)
    takePic.addTarget(self, action: #selector(takePictureAction), for: .touchUpInside)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initSubvies()
    autoStartRunning()
  }
  
  func autoStartRunning() {
    if !cameraVC.isRunning() {
      cameraVC.start()
    }
  }
  
  // MARK: action methods
  
  @objc func takePictureAction() {
    print("__\(#function)__")
  }
  
  @objc func switchFlashAction() {
    print("__\(#function)__")
    cameraVC.changeFlashModeStatus { (torchMode) in
      switch torchMode {
      case .off:
        self.switchFlashButton.setTitle("闪光 关", for: .normal)
      case .on:
        self.switchFlashButton.setTitle("闪光 开", for: .normal)
      case .auto:
        self.switchFlashButton.setTitle("闪光 自动", for: .normal)
      }
    }
  }
  
  @objc func changeCameraPositionAction() {
    print("__\(#function)__")
    cameraVC.changeCameraPosition()
  }
  
  // MARK: init subviews
  
  func initSubvies() {
    
    view.addSubview(preview)
    preview.addSubview(self.cameraVC.view)
    
    preview.addSubview(switchFlashButton)
    preview.addSubview(takePicButton)
    preview.addSubview(changeCameraPositionButton)
    
    switchFlashButton.snp.makeConstraints { (make) in
      make.size.equalTo(CGSize(width: 50, height: 30))
      make.right.equalToSuperview().inset(40)
      make.top.equalToSuperview().inset(40)
    }
    
    takePicButton.snp.makeConstraints { (make) in
      make.size.equalTo(CGSize(width: 50, height: 30))
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview().inset(80)
    }
    
    changeCameraPositionButton.snp.makeConstraints { (make) in
      make.size.equalTo(CGSize(width: 50, height: 30))
      make.right.equalTo(switchFlashButton.snp.left).offset(-20)
      make.centerY.equalTo(switchFlashButton)
    }

    preview.snp.makeConstraints { (make) in
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
    cameraVC.view.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
}

