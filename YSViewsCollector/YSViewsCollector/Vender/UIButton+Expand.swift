//
//  UIButton+Expand.swift
//  YSViewsCollector
//
//  Created by 葛燕生 on 2020/8/27.
//  Copyright © 2020 葛燕生. All rights reserved.
//

import UIKit

extension UIButton{
  
  // 改进写法【推荐】
  private struct RuntimeKey {
    static let clickEdgeInsets = UnsafeRawPointer(bitPattern: "UnsafeRawPointer".hashValue)
  }
  /// 需要扩充的点击边距
  public var hw_clickEdgeInsets: UIEdgeInsets? {
    set {
      objc_setAssociatedObject(self, UIButton.RuntimeKey.clickEdgeInsets!, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
    }
    get {
      return objc_getAssociatedObject(self, UIButton.RuntimeKey.clickEdgeInsets!) as? UIEdgeInsets ?? UIEdgeInsets.zero
    }
  }
  // 重写系统方法修改点击区域
  open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    super.point(inside: point, with: event)
    var bounds = self.bounds
    if (hw_clickEdgeInsets != nil) {
      let x: CGFloat = -(hw_clickEdgeInsets?.left ?? 0)
      let y: CGFloat = -(hw_clickEdgeInsets?.top ?? 0)
      let width: CGFloat = bounds.width + (hw_clickEdgeInsets?.left ?? 0) + (hw_clickEdgeInsets?.right ?? 0)
      let height: CGFloat = bounds.height + (hw_clickEdgeInsets?.top ?? 0) + (hw_clickEdgeInsets?.bottom ?? 0)
      bounds = CGRect(x: x, y: y, width: width, height: height) //负值是方法响应范围
    }
    return bounds.contains(point)
  }
}
