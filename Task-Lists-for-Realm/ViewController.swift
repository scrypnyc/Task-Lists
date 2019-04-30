//
//  ViewController.swift
//  Task-Lists-for-Realm
//
//  Created by Alexander Skrypnyk on 4/30/19.
//  Copyright © 2019 skrypnyk. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UITableViewController {
  
  // - контейнер со свойствами объекта TaskList
  var items = [String]()
  // - идентификатор ячейки
  var cellId = "Cell"
  

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // - цвет view
    view.backgroundColor = .brown
    // - цвет navigation bar
    navigationController?.navigationBar.barTintColor = .white
    // - цвет текста для кнопки
    navigationController?.navigationBar.tintColor = .white
    
    // - конопка "добавить" n-bar
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(addItem)) // - вызов метода для кнопки
    
    // - ячейка для TableView c индификатором "Cell"
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
  }
  // - Действие при нажатии на кнопку "Add"
  @objc func addItem(_ sender: AnyObject) {
    
    addAlertForNewItem()
  }

  func addAlertForNewItem() {
    
    // - alert
    let alert = UIAlertController(title: "New Task", message: "Please enter text", preferredStyle: .alert)
    // - создание текстового поля
    var alertTextField: UITextField!
    alert.addTextField { TextField in
      alertTextField = TextField
      TextField.placeholder = "New Task"
  }

    // - создание кнопки для сохранения новых значений
    let saveAction = UIAlertAction(title: "Save", style: .default) { action in
      // проверяем не является ли поле пустым
      guard let text = alertTextField.text, !text.isEmpty else { return }
      // добавление новоего элемента в массив задач
      self.items.append(text)
      // обновение таблицы
    }

}

}
