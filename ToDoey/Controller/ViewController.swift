//
//  ViewController.swift
//  ToDoey
//
//  Created by Kullanici on 24.01.2023.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
            loadData()
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        if let item = defaults.array(forKey: "arrayDizisi") as? [Item] {
//            itemArray = item
//        }
       // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        searchBar.delegate = self
      loadData()
        
        
    }
    //MARK:- DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoeyCell", for: indexPath) as! CustomTableViewCell
        let item = itemArray[indexPath.row]
        cell.label?.text = item.title
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
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
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
    //MARK: - Save Fucntion
    func saveData(){
        do{
            try context.save()
        } catch {
         print(error)
        }
        self.tableView.reloadData()
    }
    //MARK: - Load Function
    func loadData(with request : NSFetchRequest<Item> = Item.fetchRequest(),predicate : NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate,categoryPredicate])
        } else {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate])
        }
       
            do {
                itemArray = try context.fetch(request)
            } catch  {
                print(error)
            }
        self.tableView.reloadData()
        }
    }
//MARK:- SearchBar Delegate
extension ViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        print(searchBar.text!)
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
         
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
     loadData(with: request, predicate: predicate)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
           
        }
    }
}
    


