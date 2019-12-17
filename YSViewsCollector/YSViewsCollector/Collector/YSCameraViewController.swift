//
//  YSCameraViewController.swift
//  YSViewsCollector
//
//  Created by 葛燕生 on 2019/12/11.
//  Copyright © 2019 葛燕生. All rights reserved.
//

import UIKit
import AVFoundation

class YSCameraViewController: UIViewController {
  
  // MARK: camera property
  private var device: AVCaptureDevice?
  private var input: AVCaptureDeviceInput?
  private var output: AVCaptureMetadataOutput?
  private var imageOutPut: AVCaptureStillImageOutput?
  private var session: AVCaptureSession?
  private var previewLayer: AVCaptureVideoPreviewLayer?
  private var position: AVCaptureDevice.Position = .back
  private var focusCursor: UIView?
  private var torchMode: AVCaptureDevice.TorchMode = .off

  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  // MARK: public methods
  
  func start() {
    if session != nil {
      session?.startRunning()
    } else {
      configCameraSetting()
      session?.startRunning()
    }
  }
  
  func stop() {
    if session != nil {
      session?.stopRunning()
      session = nil
      position = .back
    }
  }
  
  func isRunning() -> Bool {
    if session != nil {
      return session?.isRunning ?? false
    }
    return false
  }
  
  func changeCameraPosition() {
    guard let currentSession = session, let currentInput = input else {
      return
    }
    let changedToPosition: AVCaptureDevice.Position = position == AVCaptureDevice.Position.back ? AVCaptureDevice.Position.front : AVCaptureDevice.Position.back
    
    if session == nil ||
      (position == .back && !isRearCameraAvailable()) ||
      (position == .front && !isFrontCameraAvailable()) {
      return
    }
    
    currentSession.beginConfiguration()
    currentSession.removeInput(currentInput)
    
    var newDevice: AVCaptureDevice?
    if currentInput.device.position == .back {
      newDevice = cameraPosition(.front)
    } else {
      newDevice = cameraPosition(.back)
    }
    
    guard let changedDevice = newDevice else {
      return
    }
    
    do {
      let newInput = try AVCaptureDeviceInput(device: changedDevice)
      position = changedToPosition
      currentSession.addInput(newInput)
      currentSession.commitConfiguration()
      
      device = changedDevice
      input = newInput
      
    } catch {
      currentSession.commitConfiguration()
      return
    }
    
  }
  
  func changeFlashModeStatus(_ completion: ((_ torchMode: AVCaptureDevice.TorchMode) -> Void)? ) {
    
    var flashMode: AVCaptureDevice.FlashMode = .off
    switch torchMode {
    case .off:
      torchMode = .on
      flashMode = .on
    case .on:
      torchMode = .auto
      flashMode = .auto
    case .auto:
      torchMode = .off
      flashMode = .off
    }
    
    if let currentDevice = device {
      if currentDevice.hasTorch && currentDevice.hasFlash {
        do {
          try currentDevice.lockForConfiguration()
          currentDevice.flashMode = flashMode
          currentDevice.torchMode = torchMode
          currentDevice.unlockForConfiguration()
          completion?(torchMode)
        } catch {
          
        }
      }
    }
  }
  
  // MARK: private methods
  
  func configCameraSetting() {
    
    device = cameraPosition(position)
    
    guard let currentDevice = device else {
      return
    }
    
    input = try? AVCaptureDeviceInput(device: currentDevice)
    output = AVCaptureMetadataOutput()
    imageOutPut = AVCaptureStillImageOutput()
    
    session = AVCaptureSession()
    
    guard let currentSession = session,
      let currentInput = input,
      let currentImageOutput = imageOutPut else {
      return
    }
    
    if currentSession.canSetSessionPreset(.photo) {
      currentSession.sessionPreset = .photo
    }
    
    if currentSession.canAddInput(currentInput) {
      currentSession.addInput(currentInput)
    }
    
    if currentSession.canAddOutput(currentImageOutput) {
      currentSession.addOutput(currentImageOutput)
    }
    
    previewLayer = AVCaptureVideoPreviewLayer(session: currentSession)
    previewLayer?.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height)
    previewLayer?.videoGravity = .resizeAspectFill
    guard let currentPreviewLayer = previewLayer else {
      return
    }
    view.layer.addSublayer(currentPreviewLayer)
    view.layer.masksToBounds = true
    view.clipsToBounds = true
    
    //修改设备的属性
    do {
      try currentDevice.lockForConfiguration()
      if currentDevice.isFlashModeSupported(.auto) {
        currentDevice.flashMode = .auto
      }
      if currentDevice.isWhiteBalanceModeSupported(.autoWhiteBalance) {
        currentDevice.whiteBalanceMode = .autoWhiteBalance
      }
      currentDevice.unlockForConfiguration()
    } catch {
      return
    }
    
  }
  
  func cameraPosition(_ position: AVCaptureDevice.Position) -> AVCaptureDevice? {
    let devices = AVCaptureDevice.devices(for: .video)
    for captureDevice in devices {
      if captureDevice.position == position {
        return captureDevice
      }
    }
    return nil
  }
  
  func isRearCameraAvailable() -> Bool {
    return UIImagePickerController.isCameraDeviceAvailable(.rear)
  }
  
  func isFrontCameraAvailable() -> Bool {
    return UIImagePickerController.isCameraDeviceAvailable(.front)
  }
  
}
