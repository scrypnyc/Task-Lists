//
//  TableViewController.swift
//  Task-Lists-for-Realm
//
//  Created by Alexander Skrypnyk on 4/30/19.
//  Copyright © 2019 skrypnyk. All rights reserved.
//

import UIKit
import RealmSwift

class TasksList: Object {
  @objc dynamic var task = ""
  @objc dynamic var completed = false
}

class TableViewController: UITableViewController {
  
  let realm = try! Realm() // - Доступ к хранилищу
  var items: Results<TasksList>! // - Контейнер со свойствами объекта TaskList
  
  var cellId = "Cell" // - Идентификатор ячейки
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Цвет заливки вью
    view.backgroundColor = .white
    
    // Цвет навигейшин бара
    navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 21/255,
                                                               green: 101/255,
                                                               blue: 192/255,
                                                               alpha: 1)
    // Цвет текста для кнопки
    navigationController?.navigationBar.tintColor = .white
    
    // Добавляем кнопку "Добавить" в навигейшин бар
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+",
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(addItem)) // Вызов метода для кнопки
    
    // Присваиваем ячейку для TableView с иднетифиактором "Cell"
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    
    items = realm.objects(TasksList.self)
  }
  
  // Действие при нажатии на кнопку "Добавить"
  @objc func addItem(_ sender: AnyObject) {
    
    addAlertForNewItem()
  }
  
  func addAlertForNewItem() {
    
    // Создание алёрт контроллера
    let alert = UIAlertController(title: "New Task", message: "Please enter text", preferredStyle: .alert)
    
    // Создание текстового поля
    var alertTextField: UITextField!
    alert.addTextField { textField in
      alertTextField = textField
      textField.placeholder = "New task"
    }
    
    // Создание кнопки для сохранения новых значений
    let saveAction = UIAlertAction(title: "Save", style: .default) { action in
      
      // Проверяем не является ли текстовое поле пустым
      guard let text = alertTextField.text , !text.isEmpty else { return }
      
      let task = TasksList()
      task.task = text
      
      try! self.realm.write {
        self.realm.add(task)
      }
      
      // Обновление таблицы
      self.tableView.insertRows(at: [IndexPath.init(row: self.items.count-1, section: 0)], with: .automatic)
    }
    
    // Создаем кнопку для отмены ввода новой задачи
    let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
    
    alert.addAction(saveAction) // Присваиваем алёрту кнопку для сохранения результата
    alert.addAction(cancelAction) // Присваиваем алерут кнопку для отмены ввода новой задачи
    
    present(alert, animated: true, completion: nil) // Вызываем алёрт контроллер
  }
  
  //MARK: Table View Data Source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if items.count != 0 {
      return items.count
    }
    return 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    let item = items[indexPath.row]
    cell.textLabel?.text = item.task
    return cell
  }
  
  //MARK: Table View Delegate
  
  override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    
    let editingRow = items[indexPath.row]
    
    let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { _,_ in
      try! self.realm.write {
        self.realm.delete(editingRow)
        tableView.reloadData()
      }
      
    }
    
    return [deleteAction]
  }
}
