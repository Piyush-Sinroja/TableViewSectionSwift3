//
//  AppDelegate.swift
//  TableViewSectionSwift3
//
//  Created by piyush sinroja on 10/04/17.
//  Copyright © 2017 Piyush. All rights reserved.
//


import UIKit

class ContactsViewController: UIViewController {
    
    @IBOutlet weak var tblContact: UITableView!
    @IBOutlet weak var searchbarContact: UISearchBar!
    
    // Static contact array
    var contactArray : Array = [
    ["firstname":"Alpesh","lastname":"P","email":"","department":"ios","birthday":"09/03/1990","contact":"0000000000"],
    ["firstname":"Bhavik","lastname":"S","email":"","department":"ios","birthday":"09/03/1990","contact":"0000000000"],
    ["firstname":"Piyush","lastname":"S","email":"","department":"ios","birthday":"09/03/1990","contact":"0000000000"],
    ["firstname":"Ramesh","lastname":"C","email":"","department":"ios","birthday":"09/03/1990","contact":"0000000000"],
    ["firstname":"Mahipal","lastname":"R","email":"","department":"ios","birthday":"09/03/1990","contact":"0000000000"],
    ["firstname":"Hemant","lastname":"M","email":"","department":"ios","birthday":"09/03/1990","contact":"0000000000"],
    ["firstname":"Chirag","lastname":"P","email":"","department":"ios","birthday":"09/03/1990","contact":"0000000000"],
    
        ["firstname":"Jignesh","lastname":"P","email":"","department":"ios","birthday":"","contact":"123456789"],
    ["firstname":"Montu","lastname":"P","email":"","department":"android","birthday":"","contact":"0000000000"],
        
        ["firstname":"Dipesh","lastname":"G","email":"","department":"php","birthday":"","contact":"0000000000"],
    
    ["firstname":"Sahil","lastname":"P","email":"","department":"designer","birthday":"","contact":"0000000000"]
    ]
    var dicKeysAndValues : [String:NSMutableArray] = [String:NSMutableArray]()
    var arraySectionTitle : [String] = [String]()

    // Table section array
    var contactSecionArray = [Character]()
    
    // search array
    var searchArray : Array = [["":""]]
    var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sortAsce = NSSortDescriptor(key: "firstname", ascending: true)
       // let sortAsarray = (contactArray as! NSMutableArray).sortedArray(using: [sortAsce])
        
        let sortAsarray = NSMutableArray(array: (contactArray as NSArray).sortedArray(using: [sortAsce]))
        
        let arrayAToZ  = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
        for charactervalue in arrayAToZ {
            var filteredListarr: NSMutableArray?
            filteredListarr = nil
            var predicate: NSPredicate?
            filteredListarr = NSMutableArray.init(array: sortAsarray)
            predicate = NSPredicate(format: "%K BEGINSWITH[cd]%@", "firstname", charactervalue)
            filteredListarr?.filter(using: predicate!)
            if (filteredListarr?.count)! > 0 {
                dicKeysAndValues[charactervalue] = filteredListarr
            }
        }
        arraySectionTitle = [String](dicKeysAndValues.keys)
        arraySectionTitle = arraySectionTitle.sorted { $0 < $1 }
        
        searchbarContact.delegate = self
        searchActive = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: - TableViewDatasource
extension ContactsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return searchArray.count
        } else {
            let stringTitle = arraySectionTitle[section]
            let sectionAnimals = dicKeysAndValues[stringTitle]
            return sectionAnimals!.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchActive {
            return 1
        } else {
            return arraySectionTitle.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchActive {
            return nil
        } else {
            return arraySectionTitle[section]
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let strIdentifier = "ContactCell"
        let cell:ContactTableViewCell = tableView.dequeueReusableCell(withIdentifier: strIdentifier as String) as! ContactTableViewCell
        
        var dataDict : NSDictionary
        if searchActive {
            dataDict  = searchArray[indexPath.row] as NSDictionary
            cell.contactName.text = (dataDict.object(forKey: "firstname") as? String)! + (" ") + (dataDict.object(forKey: "lastname") as? String)!
        } else {
            let stringTitle = arraySectionTitle[indexPath.section]
            let sectionAnimals = dicKeysAndValues[stringTitle]! as NSArray
            
            let dicDetails = sectionAnimals[indexPath.row] as! NSDictionary
            let strFirstName = dicDetails.object(forKey: "firstname") as! String
            let strLastName = dicDetails.object(forKey: "lastname") as! String
            cell.contactName.text = strFirstName + " " + strLastName
        }
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if searchActive {
            return nil
        } else {
             return arraySectionTitle
        }
    }
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if searchActive {
            return 0
        } else {
            return arraySectionTitle.firstIndex(of: title)!
        }
    }
}
//MARK: - SearchbarDelegate
extension ContactsViewController: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = true
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancel called")
        searchBar.showsCancelButton = false
        searchActive = false
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchBar.showsCancelButton = false
            searchActive = false
            searchBar.resignFirstResponder()
        } else {
            searchActive = true
            // let namePredicate = NSPredicate(format: "firstname  BEGINSWITH[cd] %@",searchText)
            let namePredicate = NSPredicate(format: "firstname  CONTAINS[cd] %@",searchText)
            searchArray.removeAll()
            searchArray = contactArray.filter { namePredicate.evaluate(with: $0) }
            print(searchArray)
        }
        tblContact.reloadData()
    }
}
