//
//  ViewController.swift
//  DiffableDataSource
//
//  Created by 구본의 on 2023/04/16.
//

import UIKit

enum Section {
  case Num
}

//class Num: Hashable {
//
//  let uuid: UUID = UUID()
//  var row: Int
//
//  init(row: Int) {
//    self.row = row
//  }
//
//  static func == (lhs: Num, rhs: Num) -> Bool {
//    lhs.uuid == rhs.uuid
//  }
//
//  func hash(into hasher: inout Hasher) {
//    hasher.combine(uuid)
//  }
//}

struct Num: Hashable {
  var row: Int
}

class ViewController: UIViewController {

  private let addButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Add", for: .normal)
    button.backgroundColor = .gray
    return button
  }()
  
  private let deleteButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Delete", for: .normal)
    button.backgroundColor = .gray
    return button
  }()
  
  private lazy var mainTableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.backgroundColor = .yellow
    return tableView
  }()
  
  private var dataSouce: UITableViewDiffableDataSource<Section, Num>!
  private var snapShot: NSDiffableDataSourceSnapshot<Section, Num>!
  
  private var array: [Num] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.setupLayouts()
    self.setupGesture()
    self.setupTableViewDataSource()
  }
  
  private func setupLayouts() {
    view.addSubview(addButton)
    view.addSubview(deleteButton)
    view.addSubview(mainTableView)
    NSLayoutConstraint.activate([
      addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      addButton.trailingAnchor.constraint(equalTo: view.centerXAnchor),
      addButton.heightAnchor.constraint(equalToConstant: 60),
      
      
      deleteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      deleteButton.leadingAnchor.constraint(equalTo: view.centerXAnchor),
      deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      deleteButton.heightAnchor.constraint(equalToConstant: 60),
      
      mainTableView.topAnchor.constraint(equalTo: addButton.bottomAnchor),
      mainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      mainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      mainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
  private func setupTableViewDataSource() {
    dataSouce = UITableViewDiffableDataSource<Section, Num>(tableView: mainTableView) { (tableView, indexPath, identifier) in
      let cell = UITableViewCell()
      cell.textLabel?.text = "\(identifier.row)"
      return cell
    }
  }
  
  private func setupGesture() {
    addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
    deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
  }
  
  @objc private func didTapAddButton() {
    self.array.append(Num(row: array.count))
    self.updateTableViewSnapshot()
  }
  
  @objc private func didTapDeleteButton() {
    self.array.removeLast()
    self.updateTableViewSnapshot()
  }
  
  func updateTableViewSnapshot() {
    snapShot = NSDiffableDataSourceSnapshot<Section, Num>()
    snapShot.appendSections([.Num])
    snapShot.appendItems(array, toSection: .Num)
    dataSouce.apply(snapShot, animatingDifferences: true)
  }
}

