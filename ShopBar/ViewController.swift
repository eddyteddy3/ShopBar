//
//  ViewController.swift
//  ShopBar
//
//  Created by Moazzam Tahir on 15/09/2019.
//  Copyright © 2019 Moazzam Tahir. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var priceTextField: UITextField!
    
    @IBOutlet var status: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    
    var managedContext: NSManagedObjectContext? //to obtain the reference of entity
    
    override func viewDidLoad() {
        super.viewDidLoad()
        status.text = ""
        status.textColor = .red
        initPersistentContainer()
    }
    
    func initPersistentContainer() {
        //the name should be as same as xcdatamodel file
        let container = NSPersistentContainer(name: "ShopBar")
        
        container.loadPersistentStores { (description, error) in
            
            if let error = error {
                fatalError("Error loading the container \(error)")
            } else {
                self.managedContext = container.viewContext
                //view Context is read-only data storage
            }
        }
    }

    @IBAction func datePicker(_ sender: Any) {
        
    }
    
    @IBAction func saveRecord(_ sender: Any) {
        //entity desciption to access the tables from ShopBar
        if let context = managedContext, let entityDesc = NSEntityDescription.entity(forEntityName: "Product", in: context) {
            let product = Product(entity: entityDesc, insertInto: managedContext)
            //this is the object for table to insert the record
            product.id += 1
            product.name = nameTextField.text
            product.price = Double(priceTextField.text!)!
            product.dateOfPurchase = datePicker.date
            
            do {
                try context.save()
                nameTextField.text = ""
                priceTextField.text = ""
                status.text = "Data saved!"
            } catch {
                status.text = "Data not saved!"
                print("Error saving data \(error.localizedDescription)")
            }
        }
        
    }
    
    @IBAction func fetchRecord(_ sender: Any) {
        if let entityDesc = NSEntityDescription.entity(forEntityName: "Product", in: managedContext!) {
            let product = Product(entity: entityDesc, insertInto: managedContext)
            
            let request: NSFetchRequest<Product> = Product.fetchRequest()
            request.entity = entityDesc
            
            if let name = nameTextField.text {
                //defining the predicate to search for the matching results for given name
                let pred = NSPredicate(format: "(name = %@)", name)
                request.predicate = pred
            }
            
            do {
                var results = try managedContext?.fetch(request as! NSFetchRequest<NSFetchRequestResult>)
                
                if results!.count > 0 {
                    let match = results![0] as! NSManagedObject
                    
                    nameTextField.text = match.value(forKey: "name") as? String
                    priceTextField.text = match.value(forKey: "price") as? String
                    status.text = "record found!"
                }
            } catch {
                status.text = "Could not load"
                print("Could load the record")
            }
        }
    }
    
}

