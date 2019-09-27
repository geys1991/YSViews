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
}

class ViewController: UIViewController {
  
  private lazy var dataSource: [YSViewTitle] = [.menuView]
  
  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "kUITableViewCell")
    return tableView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
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
    cell.textLabel?.text = viewTitle
    return cell
  }
}
