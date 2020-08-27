//
//  ViewController.swift
//  YSViewsCollector
//
//  Created by 葛燕生 on 2019/9/27.
//  Copyright © 2019 葛燕生. All rights reserved.
//

import UIKit
import SnapKit

enum YSViewTitle: String {
  case menuView = "YSMenuView"
  case doubleSideSliderView = "YSDoubleSideSliderView"
  case scaleScrollImageView = "YSScaleImageView"
  case cameraView = "YSCameraView"
  case multiInputView = "YSMultiInputView"
  case doubleWave = "YSDoubleWaveView"
}

class ViewController: UIViewController {
  
  private lazy var dataSource: [YSViewTitle] = [.menuView,
                                                .doubleSideSliderView,
                                                .scaleScrollImageView,
                                                .cameraView,
                                                .multiInputView,
                                                .doubleWave]
  
  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "kUITableViewCell")
    return tableView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "首页"
    view.backgroundColor = UIColor.white
    initSubviews()
  }
  
  // MARK: init subviews
  
  func initSubviews() {
    view.addSubview(tableView)
    tableView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
}

extension ViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let index = indexPath.row
    switch index {
    case 0:
      let menuItemVC = YSMenuItemViewController()
      navigationController?.pushViewController(menuItemVC, animated: true)
    case 1:
      let doubleSlidlerVC = YSDoubleSideSliderViewController()
      navigationController?.pushViewController(doubleSlidlerVC, animated: true)
    case 2:
      let scaleImageVC = YSScaleImageViewController()
      navigationController?.pushViewController(scaleImageVC, animated: true)
    case 3:
      let cameraVC = YSCameraCustomViewController()
      navigationController?.pushViewController(cameraVC, animated: true)
    case 4:
      let multiInputVC = YSMultiInputViewController()
      navigationController?.pushViewController(multiInputVC, animated: true)
    case 5:
      let douwaveVC = YSDoubleWaveViewController()
      navigationController?.pushViewController(douwaveVC, animated: true)
    default:
      return
    }
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return UIView(frame: .zero)
  }
  
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "kUITableViewCell", for: indexPath)
    let viewTitle = dataSource[indexPath.row].rawValue
    cell.selectionStyle = .none
    cell.textLabel?.text = viewTitle
    return cell
  }
}
