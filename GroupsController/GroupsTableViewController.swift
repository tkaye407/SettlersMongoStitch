//
//  GroupsTableViewController.swift
//  Settlers
//
//  Created by Tyler Kaye on 8/27/18.
//  Copyright © 2018 Tyler Kaye. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import StitchCore
class GroupsTableViewController: UITableViewController {
    
    private var groups: [Group] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        stitchClient.callFunction(withName: "getNameAndDescription", withArgs: ["args"], withRequestTimeout: 5.0)
//        {(result: StitchResult<String>) in
//            switch result {
//            case .success(let stringResult):
//                print("String result: \(stringResult)")
//            case .failure(let error):
//                print("Error retrieving String: \(String(describing: error))")
//            }
//        }
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        GroupService.get{ (groupData) in
            self.groups = groupData
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addGroup(gName: String, gDesc: String) {
        let group = Group.newGroup(title: gName, description: gDesc)
        let handler: () -> Void = {self.viewWillAppear(true)}
        GroupService.insert(group: group, doneHandler: handler)
    }
    
    // MARK: TABLEVIEW METHODS
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete immentation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupsTableViewCell
        let group = groups[indexPath.row]
        cell.groupName.text = group.title
        cell.numMembers.text = String(group.members.count) + " Members"
        cell.numTransactions.text = String(group.transactions.count) + " Transactions"

        var total: Float = 0.0
        for t in group.transactions {
          total += t.amount
        }
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        if let formattedTipAmount = formatter.string(from: total as NSNumber) {
            cell.totalSpent.text = "\(formattedTipAmount)"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("In prepare")
        if segue.identifier == "ToTransactions" {
            let newVC = segue.destination as! TransactionsTableViewController
            print("group in prepare")
            print(groups[(self.tableView.indexPathForSelectedRow?.row)!])
            newVC.group = groups[(self.tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    // MARK: BUTTON HANDLERS
    @IBAction func signOutClicked(_ sender: Any) {
        // Sign Out
        Stitch.defaultAppClient?.auth.logout({result in
            switch result {
            case .success(_):
                let loginManager: FBSDKLoginManager = FBSDKLoginManager()
                loginManager.logOut()
                self.performSegue(withIdentifier: "unwindToLogin", sender: self)
            case .failure(let error):
                print("failed logging out: \(error)")
            }
        });
    }
    
    @IBAction func newGroupClicked(_ sender: Any) {
        let alertController = UIAlertController(title: "Create New Group", message: "Please enter group name and description", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Create", style: .default, handler: {
            alert -> Void in
            let groupName = alertController.textFields![0] as UITextField
            let groupDescription = alertController.textFields![1] as UITextField
            if groupName.text != "", groupDescription.text != "" {
                self.addGroup(gName: groupName.text!, gDesc: groupDescription.text!)
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
