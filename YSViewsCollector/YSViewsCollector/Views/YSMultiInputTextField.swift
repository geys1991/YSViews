//
//  YSMultiInputTextField.swift
//  YSViewsCollector
//
//  Created by 葛燕生 on 2020/7/21.
//  Copyright © 2020 葛燕生. All rights reserved.
//

import UIKit

protocol YSMultiInputTextFieldDelegate {
  func YSDelegateBackward(_ textField: YSMultiInputTextField)
}

class YSMultiInputTextField: UITextField {
  
  var deleteProtocol: YSMultiInputTextFieldDelegate?
  
  override func deleteBackward() {
    super.deleteBackward()
    deleteProtocol?.YSDelegateBackward(self)
  } 
}
