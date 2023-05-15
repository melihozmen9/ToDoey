//
//  CategoryTableViewController.swift
//  ToDoey
//
//  Created by Kullanici on 31.01.2023.
//

import UIKit
import CoreData
class CategoryTableViewController: UITableViewController {

    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        tableView.rowHeight = 50
     loadCategories()
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return categoryArray.count
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
        let category = categoryArray[indexPath.row]
        cell.CategoryLabel.text = category.name
        return cell
    }
    //MARK:- TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToItems"{
            let destinationVC = segue.destination as! ViewController
            if let indexpath = tableView.indexPathForSelectedRow	{
                destinationVC.selectedCategory  = categoryArray[indexpath.row]
            }
        }
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            context.delete(categoryArray[indexPath.row])
            categoryArray.remove(at: indexPath.row)
            saveCategories()
        }
    }
    //MARK: - Manipulation

    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        //UITextField'ı atamak için textFieldDEğişkeni oluşturuyorum.
        var textField = UITextField()
        // Alert Oluşturma
        let alert = UIAlertController(title: "Category Ekle", message: "Lütfen Bir Categori ekleyiniz.", preferredStyle: .alert)
        // Alert Text field
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Buraya Yazın."
            textField = alertTextField
        }
        // alert'te action oluşturma
        let action = UIAlertAction(title: "Ekle", style: .default) { (action) in
            // Action içinde istediğim entity tipinde değişken oluşturucam.
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text
            self.categoryArray.append(newCategory)
            self.tableView.reloadData()
            self.saveCategories()
        }
        //oluşturugumuz action'ı alert'e ekledik.
        alert.addAction(action)
        // alert'i gösterme
        present(alert, animated: true, completion: nil)
    }
    func saveCategories(){
        do {
            try context.save()
        } catch  {
            print("errors = \(error)")
        }
    }
    func loadCategories(request:NSFetchRequest<Category> = Category.fetchRequest()){
        do {
            categoryArray = try context.fetch(request)
        } catch  {
            print("Load Error'u : \(error)")
        }
        
    }
    

}

