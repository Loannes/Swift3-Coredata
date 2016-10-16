//
//  ViewController.swift
//  swift3-coredata
//
//  Created by Loannes on 2016. 10. 16..
//  Copyright © 2016년 Loannes. All rights reserved.
//

import UIKit
import CoreData

//coredata to jsom
class ManagedParser: NSObject {
    class func convertToArray(managedObjects:NSArray?, parentNode:String? = nil) -> NSArray {
        
        let rtnArr:NSMutableArray = NSMutableArray();
        //--
        if let managedObjs:[NSManagedObject] = managedObjects as? [NSManagedObject] {
            for managedObject:NSManagedObject in managedObjs {
                rtnArr.add(self.convertToDictionary(managedObject: managedObject, parentNode: parentNode));
            }
        }
        
        return rtnArr;
    } //F.E.
    
    class func convertToDictionary(managedObject:NSManagedObject, parentNode:String? = nil) -> NSDictionary {
        
        let rtnDict:NSMutableDictionary = NSMutableDictionary();
        //-
        let entity:NSEntityDescription = managedObject.entity;
        let properties:[String] = (entity.propertiesByName as NSDictionary).allKeys as! [String];
        //--
        let parentNode:String = parentNode ?? managedObject.entity.name!;
        for property:String in properties  {
            if (property.caseInsensitiveCompare(parentNode) != ComparisonResult.orderedSame)
            {
                let value: AnyObject? = managedObject.value(forKey: property) as AnyObject?;
                //--
                if let set:NSSet = value as? NSSet  {
                    rtnDict[property] = self.convertToArray(managedObjects: set.allObjects as NSArray?, parentNode: parentNode);
                } else if let vManagedObject:NSManagedObject = value as? NSManagedObject {
                    
                    if (vManagedObject.entity.name != parentNode) {
                        rtnDict[property] = self.convertToDictionary(managedObject: vManagedObject, parentNode: parentNode);
                    }
                } else  if let vData:AnyObject = value {
                    rtnDict[property] = vData;
                }
            }
        }
        
        return rtnDict;
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var fetchData : NSArray = Entity.getFetchedResults()

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
            
            let proc = Entity.saveContext(saveText: text)
            if proc == "success" {
                self.fetchData = Entity.getFetchedResults()
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

        if let attr = (record as AnyObject).value(forKey: "attr1") {
            cell.textLabel?.text = attr as? String
        }
        
        return cell
    }
  
    // ///////////////////////////////////
    // 수정 뷰 나와서 수정하는 부분 구현하면 될듯
    // ///////////////////////////////////
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if let indexPath = tableView.indexPathForSelectedRow {
//            // Fetch Record
//            let record = fetchedResultsController.object(at: indexPath) as! NSManagedObject
//            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let enterViewController = storyboard.instantiateViewController(withIdentifier: "UPDATE_VIEW") as! UpdateViewController
//            enterViewController.record = record
//            self.navigationController?.pushViewController(enterViewController, animated: true)
//        }
    }
    
}

