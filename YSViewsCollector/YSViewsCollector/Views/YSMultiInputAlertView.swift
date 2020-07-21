//
//  YSMultiInputAlertView.swift
//  YSViewsCollector
//
//  Created by 葛燕生 on 2020/7/21.
//  Copyright © 2020 葛燕生. All rights reserved.
//

import UIKit
import SnapKit

enum YQGMultiInputViewEditMode {
  case edit
  case delete
}

class YSMultiInputAlertView: UIView {
  
  let inputTag: Int = 10_000
  let sideMargin: CGFloat = 20
  var inputCount: Int = 6
  var inputSize: CGSize = CGSize(width: 20, height: 40)
  var inputArray: [YSMultiInputTextField] = []
  
  var inputValues: [Int] = []
  
  var editMode: YQGMultiInputViewEditMode = .edit
  
  convenience init(_ editCount: Int) {
    self.init(frame: .zero)
    inputCount = editCount
  }
  
  // MARK: private method
  
  @objc func textFieldDidChange(_ textField: YSMultiInputTextField) {
    if editMode == .delete && textField.tag == inputTag + inputArray.count - 1 {
      return
    }
    let cursorFlag: Int = editMode == .edit ? 1 : -1
    let nextTag = textField.tag + cursorFlag
    let nextInputView: YSMultiInputTextField? = viewWithTag(nextTag) as? YSMultiInputTextField
    nextInputView?.becomeFirstResponder()
  }
  
  func reloadData() {
    for (index, item) in inputArray.enumerated() {
      if index <= inputValues.count - 1 {
        let content = "\(inputValues[index])"
        item.text = content
      } else {
        item.text = ""
      }
    }
  }
  
  // MARK: public method
  
  func configInputView() {

    let padding: CGFloat = ((UIScreen.main.bounds.size.width - (20 + 40) * 2) / CGFloat(inputCount)) - inputSize.width
    let leftDistance: CGFloat = sideMargin
    
    for index in 0..<inputCount {
      let inputItem = YSMultiInputTextField()
      inputItem.textAlignment = .center
      inputItem.keyboardType = .numberPad
      inputItem.layer.borderWidth = 1
      inputItem.layer.borderColor = UIColor.black.cgColor
      inputItem.layer.cornerRadius = 3
      inputItem.layer.masksToBounds = true
      inputItem.tag = inputTag + index
      inputItem.delegate = self
      inputItem.deleteProtocol = self
      inputItem.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
      addSubview(inputItem)
      inputArray.append(inputItem)
      
      let itemPadding = leftDistance + (padding + inputSize.width) * CGFloat(index)
      inputItem.snp_makeConstraints { (make) in
        make.left.equalToSuperview().offset(itemPadding)
        make.centerY.equalToSuperview()
        make.size.equalTo(inputSize)
      }
    }
  }
}

extension YSMultiInputAlertView: YSMultiInputTextFieldDelegate {
  
  func YSDelegateBackward(_ textField: YSMultiInputTextField) {
    editMode = .delete
    
    if textField.tag == inputTag + inputArray.count - 1 {
      if inputValues.count > textField.tag - inputTag {
        inputValues.remove(at: textField.tag - inputTag)
        return
      }
    }
    let nextTag = textField.tag - 1
    if nextTag >= inputTag {
      let nextInputView: YSMultiInputTextField? = viewWithTag(nextTag) as? YSMultiInputTextField
      inputValues.remove(at: nextTag - inputTag)
      reloadData()
      nextInputView?.becomeFirstResponder()
    }
    print("\(inputValues)")
  }
}

extension YSMultiInputAlertView: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    editMode = string == "" ? .delete : .edit
    
    let currentTag = textField.tag
    if currentTag == inputTag + inputCount - 1 {
      if range.location == 1 {
        return false
      }
    }
    if let intValue = Int(string) {
      inputValues.append(intValue)
    }
    print("\(inputValues)")
    return true
  }
}
