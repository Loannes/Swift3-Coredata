//
//  ViewController.swift
//  swift3-coredata
//
//  Created by Loannes on 2016. 10. 16..
//  Copyright © 2016년 Loannes. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var fetchData : NSArray = AICoreData.fetchedData()

    @IBOutlet weak var tableview: UITableView!
    
    @IBAction func alertTextField(_ sender: AnyObject) {

        let alert = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Some default text."
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            
            // Check TextField Value : if value is nil, return
            guard let text = alert.textFields![0].text, alert.textFields![0].text != "" else {
                return
            }
            
            let proc = AICoreData.saveData(saveText: text)
            if proc == "success" {
                self.fetchData = AICoreData.fetchedData()
                self.tableview.reloadData()
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let record = fetchData.object(at: indexPath.row)
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")

        if let attr = (record as AnyObject).value(forKey: "attr1") as? String {
            cell.textLabel?.text = attr
        }
        
        return cell
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let indexPath = tableView.indexPathForSelectedRow {

            let record = fetchData.object(at: indexPath.row)
            
            let alert = UIAlertController(title: "edit Title", message: "edit a text", preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                if let attr = (record as AnyObject).value(forKey: "attr1") as? String {
                    textField.text = attr
                }
            }

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in

                guard let text = alert.textFields![0].text, alert.textFields![0].text != "" else {
                    return
                }
                
                let proc = AICoreData.updateData(record: record as AnyObject, updateData: text)
                if proc == "success" {
                    self.fetchData = AICoreData.fetchedData()
                    self.tableview.reloadData()
                }

            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
}

