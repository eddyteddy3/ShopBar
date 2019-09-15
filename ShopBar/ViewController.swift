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
    
    var managedContext: NSManagedObjectContext? //to obtain the reference of entity
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
            product.id += 1
            product.name = nameTextField.text
            product.price = Double(priceTextField.text!)!
            
            do {
                try managedContext?.save()
                nameTextField.text = ""
                priceTextField.text = ""
                
            } catch {
                print("Error saving data \(error.localizedDescription)")
            }
        }
        
    }
    
    @IBAction func fetchRecord(_ sender: Any) {
    }
    
}

