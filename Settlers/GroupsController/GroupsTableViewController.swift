//
//  GroupsTableViewController.swift
//  Settlers
//
//  Created by Tyler Kaye on 8/27/18.
//  Copyright © 2018 Tyler Kaye. All rights reserved.
//

import UIKit
import StitchCore
import StitchRemoteMongoDBService
//import FacebookLogin
import FBSDKLoginKit
class GroupsTableViewController: UITableViewController {
    
    private var groups: [Document] = []
    private var stitchClient: StitchAppClient?
    private var mongoClient: RemoteMongoClient?
    private var groupCollection: RemoteMongoCollection<Document>?

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        stitchClient = appDelegate.stitchClient
        mongoClient = stitchClient?.serviceClient(fromFactory: remoteMongoClientFactory, withName: "mongodb-atlas")
        groupCollection = mongoClient?.db("settlers").collection("groups")

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        groupCollection?.find().asArray({ result in
            switch result {
            case .success(let result):
                self.groups = result
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Error in finding documents: \(error)")
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addGroup(gName: String, gDesc: String) {
        var itemDoc = Document()
        var memDoc = Document()
        memDoc["name"] = stitchClient?.auth.currentUser?.profile.name! as! String
        memDoc["user_id"] = self.stitchClient!.auth.currentUser!.id
        itemDoc["members"] = [memDoc]
        itemDoc["title"] = gName
        itemDoc["description"] = gDesc
        itemDoc["transactions"] = []
        self.groupCollection?.insertOne(itemDoc, {result in
            switch result {
            case .success(_):
                self.viewWillAppear(true)
            case .failure(let error):
                print("failed logging out: \(error)")
            }
        })
    }
    
    // MARK: TABLEVIEW METHODS
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(groups.count)
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupsTableViewCell
        let doc = groups[indexPath.row]
        cell.groupName.text = doc["title"] as? String
        let members = doc["members"] as! [Document]
        cell.numMembers.text = String(members.count) + " Members"
        cell.totalSpent.text = "$"
        let transactions = doc["transactions"] as! [Document]
        cell.numTransactions.text = String(transactions.count) + " Transactions"
        var total = 0.0
        for t in transactions {
            let t_amt = t["amount"] as! Double
            total += t_amt
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
        if segue.identifier == "ToTransactions" {
            let newVC = segue.destination as! TransactionsTableViewController
            newVC.group = groups[(self.tableView.indexPathForSelectedRow?.row)!]
        }
    }
 
    
    
    
    // MARK: BUTTON HANDLERS
    @IBAction func signOutClicked(_ sender: Any) {
        // Sign Out
        print("Stitch UUID (LOGOUT): " + self.stitchClient!.auth.currentUser!.id)
        stitchClient?.auth.logout({result in
            switch result {
            case .success(_):
                print("SUCCESSFULLY LOGGED OUT")
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
