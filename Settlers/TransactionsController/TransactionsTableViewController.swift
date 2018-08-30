//
//  TransactionsTableViewController.swift
//  Settlers
//
//  Created by Tyler Kaye on 8/27/18.
//  Copyright © 2018 Tyler Kaye. All rights reserved.
//

import UIKit
import StitchCore

class TransactionsTableViewController: UITableViewController {
    let names = ["Acai Bowls", "Flights", "Hostile in Argentina", "Coffee"]
    let amounts = [20.33, 400, 120, 23.45]
    let splits = [4, 6, 2, 4]
    let payers = ["Tyler", "Ted", "Drew", "Tyler"]
    let groupName = "Argentina"
    var group: Document = Document()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = groupName + " Transactions"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(group)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionTableViewCell
        cell.transactionName.text = names[indexPath.row]
        cell.transactionSplit.text = String(splits[indexPath.row]) + " other members"
        cell.transactionAmount.text = "$" + String(amounts[indexPath.row])
        cell.transactionPayer.text = payers[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO SEND PROPER INFORMATION THROUGH
        self.performSegue(withIdentifier: "ToTransactionDetail", sender: self)
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier! == "ToTransactionDetail" {
            let ctrl = segue.destination as! TransactionDetailViewController
            ctrl.amt = 20
            ctrl.descr = "For the children"
            ctrl.names = ["Tyler", "Drew", "Ted", "Nicole", "Gordon"]
            ctrl.titleS = "Cookies"
        } else if segue.identifier! == "ToAddNewTransaction" {
            let ctrl = segue.destination as! NewTransactionViewController
            ctrl.groupDoc = group
        }
    }
 

    @IBAction func addTransaction(_ sender: Any) {
        self.performSegue(withIdentifier: "ToAddNewTransaction", sender: self)
    }
    
    @IBAction func addMember(_ sender: Any) {
        
    }
}
