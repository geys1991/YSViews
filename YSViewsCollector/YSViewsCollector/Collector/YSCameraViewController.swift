//
//  YSCameraViewController.swift
//  YSViewsCollector
//
//  Created by 葛燕生 on 2019/12/11.
//  Copyright © 2019 葛燕生. All rights reserved.
//

import UIKit
import AVFoundation
import CoreGraphics

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
  
  func changeCameraPosition(_ completion: ((_ position: AVCaptureDevice.Position) -> Void)?) {
    
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
      
      completion?(position)
      
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
  
  func takePicture(_ completion: ((_ takenImage: UIImage?) -> Void)?) {
    guard let _ = session else {
      return
    }
    if let videoConnection = captureConnection() {
      videoConnection.videoOrientation = orientationForConnection()
      imageOutPut?.captureStillImageAsynchronously(from: videoConnection, completionHandler: { [weak self] (sampleBuffer, error) in
        if let strongSelf = self {
          if let buffer = sampleBuffer {
            if let imageData: Data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer) {
              if let image = UIImage(data: imageData),
                let takenImage = strongSelf.crop(image) {
                let resImage = takenImage.fixOrientation()
                completion?(resImage)
              }
            }
          }
        }
      })
    }
  }
  
  // MARK: private methods
  
  func crop(_ image: UIImage) -> UIImage? {
    guard let currentPreviewLayer = previewLayer else {
      return nil
    }
    guard let bounds = currentPreviewLayer.superlayer?.bounds else {
      return nil
    }
    let outputRect = currentPreviewLayer.metadataOutputRectConverted(fromLayerRect: bounds)
    
    if let takenCGImage: CGImage = image.cgImage {
      let cropRect = CGRect(x: outputRect.origin.x * CGFloat(takenCGImage.width),
                            y: outputRect.origin.y * CGFloat(takenCGImage.height),
                            width: outputRect.size.width * CGFloat(takenCGImage.width),
                            height: outputRect.size.height * CGFloat(takenCGImage.height))
      if let cropedImage: CGImage = takenCGImage.cropping(to: cropRect) {
        let resImage = UIImage(cgImage: cropedImage, scale: 1, orientation: image.imageOrientation)
        return resImage
      }
    }
    return nil
  }
  
  func captureConnection() -> AVCaptureConnection? {
    guard let currentImageOutPut = imageOutPut else {
      return nil
    }
    var videoConnection: AVCaptureConnection?
    for connection in currentImageOutPut.connections {
      for port in connection.inputPorts {
        if port.mediaType == .video {
          videoConnection = connection
          break
        }
      }
      if videoConnection != nil {
        break
      }
    }
    return videoConnection
  }
  
  func orientationForConnection() -> AVCaptureVideoOrientation {
    var videoOrientation: AVCaptureVideoOrientation = .portrait
    
    let statusBarOrientation = UIApplication.shared.statusBarOrientation
    switch statusBarOrientation {
    case .landscapeLeft:
      videoOrientation = .landscapeLeft
    case .landscapeRight:
      videoOrientation = .landscapeRight
    case .portraitUpsideDown:
      videoOrientation = .portraitUpsideDown
    default:
      videoOrientation = .portrait
    }
    
    return videoOrientation
  }
  
  func fixImageOrientation(_ image: UIImage) -> UIImage? {
    let orientation: UIImage.Orientation = image.imageOrientation
    if orientation == .up {
      return image
    }
    var transform = CGAffineTransform.identity
    switch orientation {
    case .down, .downMirrored:
      transform = CGAffineTransform(translationX: image.size.width, y: image.size.height)
      transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    case .left, .leftMirrored:
      transform = CGAffineTransform(translationX: image.size.width, y: 0)
      transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    case .right, .rightMirrored:
      transform = CGAffineTransform(translationX: 0, y: image.size.height)
      transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
    case .up, .upMirrored:
      break
    }
    switch orientation {
    case .upMirrored, .downMirrored:
      transform = CGAffineTransform(translationX: image.size.width, y: 0)
      transform = CGAffineTransform(scaleX: -1, y: 1)
    case .leftMirrored, .rightMirrored:
      transform = CGAffineTransform(translationX: image.size.height, y: 0)
      transform = CGAffineTransform(scaleX: -1, y: 1)
    case .up, .down, .left, .right:
      break
    }
    
    if let cgImage = image.cgImage,
      let colorSpace = cgImage.colorSpace {
      let ctx = CGContext(data: nil,
                          width: Int(image.size.width),
                          height: Int(image.size.height),
                          bitsPerComponent: cgImage.bitsPerComponent,
                          bytesPerRow: cgImage.bytesPerRow,
                          space: colorSpace,
                          bitmapInfo: cgImage.bitmapInfo.rawValue)
      
      ctx?.concatenate(transform)
      switch image.imageOrientation {
      case .left, .leftMirrored, .right, .rightMirrored:
        ctx?.draw(cgImage, in: CGRect(x: 0, y: 0, width: image.size.height, height: image.size.width))
        break
      default:
        ctx?.draw(cgImage, in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        break
      }
      
      if let makedCGImage = ctx?.makeImage() {
        let resImage = UIImage(cgImage: makedCGImage)
        return resImage
      }
    }
    return nil
  }
  
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
