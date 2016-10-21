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

    var fetchData : NSArray = Entity.fetchedData()

    @IBOutlet weak var tableview: UITableView!
    
    @IBAction func alertTextField(_ sender: AnyObject) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Some default text."
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            
            // Check TextField Value : if value is nil, return
            guard let text = alert.textFields![0].text, alert.textFields![0].text != "" else {
                return
            }
            
            let proc = Entity.saveData(saveText: text)
            if proc == "success" {
                self.fetchData = Entity.fetchedData()
                self.tableview.reloadData()
            }
            
        }))
        
        // 4. Present the alert.
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
    // 테이블 행수 얻기 (tableView 구현 필수)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchData.count
    }
    
    // 셀 내용 변경하기 (tableView 구현 필수)
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
            // Fetch Record
            let record = fetchData.object(at: indexPath.row)
            
            //1. Create the alert controller.
            let alert = UIAlertController(title: "edit Title", message: "edit a text", preferredStyle: .alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                if let attr = (record as AnyObject).value(forKey: "attr1") as? String {
                    textField.text = attr
                }
            }
            
            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                
                // Check TextField Value : if value is nil, return
                guard let text = alert.textFields![0].text, alert.textFields![0].text != "" else {
                    return
                }
                
                let proc = Entity.updateData(record: record as AnyObject, updateData: text)
                if proc == "success" {
                    self.fetchData = Entity.fetchedData()
                    self.tableview.reloadData()
                }
                
            }))
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
}

