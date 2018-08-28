//
//  GroupsTableViewController.swift
//  Settlers
//
//  Created by Tyler Kaye on 8/27/18.
//  Copyright © 2018 Tyler Kaye. All rights reserved.
//

import UIKit

class GroupsTableViewController: UITableViewController {
    
    let names = ["Argentina", "Soccer Team", "Roomates"]
    let numMems = [12, 13, 5]
    let total = [456, 555, 1200]
    let numTrans = [22, 32, 12]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return names.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupsTableViewCell
        cell.groupName.text = names[indexPath.row]
        cell.numMembers.text = String(numMems[indexPath.row]) + " Members"
        cell.totalSpent.text = "$" + String(total[indexPath.row])
        cell.numTransactions.text = String(numTrans[indexPath.row]) + " Transactions"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Send the document through
        self.performSegue(withIdentifier: "ToTransactions", sender: self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func signOutClicked(_ sender: Any) {
        // Sign Out
        
        self.performSegue(withIdentifier: "toSignIn", sender: self)
        
    }
    
    @IBAction func newGroupClicked(_ sender: Any) {
        let alertController = UIAlertController(title: "Create New Group", message: "Please enter group name and description", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Create", style: .default, handler: {
            alert -> Void in
            let groupName = alertController.textFields![0] as UITextField
            let groupDescription = alertController.textFields![1] as UITextField
            
            if groupName.text != "", groupDescription.text != "" {
                //TODO: Create new group and navigate to it
                print(groupName.text!)
                print(groupDescription.text!)
                
            } else {
                let errorAlert = UIAlertController(title: "Error", message: "Please input both a group name and description", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
                    alert -> Void in
                    self.present(alertController, animated: true, completion: nil)
                }))
                self.present(errorAlert, animated: true, completion: nil)
            }
        }))
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Spain Travelers...."
            //textField.textAlignment = .center
        })
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Description of Group..."
            //textField.textAlignment = .center
        })
        
        self.present(alertController, animated: true, completion: nil)
    }
    

}
