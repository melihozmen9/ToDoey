//
//  ViewController.swift
//  ToDoey
//
//  Created by Kullanici on 24.01.2023.
//

import UIKit

class ViewController: UITableViewController {
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("itemPlist")
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        if let item = defaults.array(forKey: "arrayDizisi") as? [Item] {
//            itemArray = item
//        }
     
        print(dataFilePath)
        
        let newItem = Item()
        newItem.toDo = "a"
        newItem.done = true
        itemArray.append(newItem)
        let newItem2 = Item()
        newItem.toDo = "b"
        itemArray.append(newItem2)
        let newItem3 = Item()
        newItem.toDo = "c"
        itemArray.append(newItem3)
        
        
    }
    //MARK:- DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoeyCell", for: indexPath) as! CustomTableViewCell
        let item = itemArray[indexPath.row]
        cell.label?.text = item.toDo
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    //MARK:-Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        self.saveData()
        tableView.deselectRow(at: indexPath, animated: true )
    }
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add New Item", style: .default) { (action) in
            let newItem = Item()
            newItem.toDo = textField.text!
            self.itemArray.append(newItem)
            self.saveData()
            print("success")
        }
        alert.addAction(action)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "buraya yazabilirsin."
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    func saveData(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print(error)
        }
        self.tableView.reloadData()
    }
    
}

