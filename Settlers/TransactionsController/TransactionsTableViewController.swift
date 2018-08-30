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
    var group: Document = Document()
    var transactions: [Document] = []
    var idToName: [String: String] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        transactions = group["transactions"] as! [Document]
        self.title = (group["title"] as! String)
        reverseEngineerNames()
        print(idToName)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("RUNNING VIEW WILL APPEAR")
        reloadGroupData()
    }
    
    func reloadGroupData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let mongoClient = appDelegate.stitchClient?.serviceClient(fromFactory: remoteMongoClientFactory, withName: "mongodb-atlas")
        let groupCollection = mongoClient?.db("settlers").collection("groups")
        let oid = group["_id"] as! ObjectId
        groupCollection?.find(["_id": oid], options: nil).asArray({result in
            switch result {
            case .success(let result):
                print("NEW RELOAD")
                self.group = result[0]
                self.transactions = self.group["transactions"] as! [Document]
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Error in finding documents: \(error)")
            }
        })
        
    }
    
    func reverseEngineerNames() {
        let members = group["members"] as! [Document]
        var dict: [String: String] = [:]
        for m in members {
            dict[m["user_id"] as! String] = m["name"] as? String
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
        return transactions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionTableViewCell
        let t = transactions[indexPath.row]
        cell.transactionName.text = t["title"] as! String
        
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        if let formattedTipAmount = formatter.string(from: t["amount"] as! NSNumber) {
            cell.transactionAmount.text = "\(formattedTipAmount)"
        }
        
        let payees = t["payee_id"] as! [String]
        cell.transactionSplit.text = String(payees.count) + " other members"
        cell.transactionPayer.text = "Tyler"
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
            ctrl.transaction = transactions[(tableView.indexPathForSelectedRow?.row)!]
            ctrl.idToName = self.idToName
            ctrl.names = ["Tyler", "Drew", "Ted", "Nicole", "Gordon"]
        } else if segue.identifier! == "ToAddNewTransaction" {
            let ctrl = segue.destination as! NewTransactionViewController
            ctrl.groupDoc = group
        }
    }
 
    @IBAction func analysisTouched(_ sender: Any) {
        
    }
    
    @IBAction func addMemberTouched(_ sender: Any) {
        
    }
    @IBAction func addPaymentTouched(_ sender: Any) {
        self.performSegue(withIdentifier: "ToAddNewTransaction", sender: self)
    }
}
