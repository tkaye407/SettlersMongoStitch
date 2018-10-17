//
//  TransactionsTableViewController.swift
//  Settlers
//
//  Created by Tyler Kaye on 8/27/18.
//  Copyright © 2018 Tyler Kaye. All rights reserved.
//

import UIKit
import StitchCore
import StitchRemoteMongoDBService

class TransactionsTableViewController: UITableViewController {
    var group: Group?
    var idToName: [String: String] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        reverseEngineerNames()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadGroupData()
    }
    
    func reloadGroupData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let mongoClient = appDelegate.stitchClient?.serviceClient(fromFactory: remoteMongoClientFactory, withName: "mongodb-atlas")
        let groupCollection = mongoClient?.db("settlers").collection("groups")
        groupCollection?.find(["_id": group?.objectID], options: nil).asArray({result in
            switch result {
            case .success(let result):
                if result.count <= 0 {
                    self.navigationController?.popViewController(animated: true)
                }
                self.group = Group(document: result[0])!
                (DispatchQueue.main.async{
                    self.tableView.reloadData()
                })
            case .failure(let error):
                print("Error in finding documents: \(error)")
            }
        })
        
    }
    
    func reverseEngineerNames() {
        var dict: [String: String] = [:]
        for m in (group?.members)! {
            dict[m.id] = m.name as? String
        }
        idToName = dict
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
        return (group?.transactions.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionTableViewCell
        let t = group?.transactions[indexPath.row]
        cell.transactionName.text = t?.title
        
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        if let fNum = formatter.string(for: t?.amount) {
            cell.transactionAmount.text = "\(fNum)"
        }
        
        cell.transactionSplit.text = String((t?.payee.count)!) + " other members"
        cell.transactionPayer.text = idToName[(t?.payer)!]
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
            ctrl.transaction = group?.transactions[(tableView.indexPathForSelectedRow?.row)!]
            ctrl.idToName = self.idToName
            ctrl.names = ["Tyler", "Drew", "Ted", "Nicole", "Gordon"]
        } else if segue.identifier! == "ToAddNewTransaction" {
            let ctrl = segue.destination as! NewTransactionViewController
            ctrl.group = self.group
        } else if segue.identifier! == "ToAddNewMember" {
            let ctrl = segue.destination as! AddMemberTableViewController
            ctrl.group = self.group
        }
    }
 
    @IBAction func analysisTouched(_ sender: Any) {
        
    }
    
    @IBAction func addMemberTouched(_ sender: Any) {
        self.performSegue(withIdentifier: "ToAddNewMember", sender: self)
        
    }
    @IBAction func addPaymentTouched(_ sender: Any) {
        self.performSegue(withIdentifier: "ToAddNewTransaction", sender: self)
    }
}
