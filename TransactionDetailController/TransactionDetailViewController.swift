//
//  TransactionDetailViewController.swift
//  Settlers
//
//  Created by Tyler Kaye on 8/27/18.
//  Copyright © 2018 Tyler Kaye. All rights reserved.
//

import UIKit
import StitchCore

class TransactionDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var descrField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var payerField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var memberTableView: UITableView!
    
    var members: [Member] = []
    var transaction: Transaction?
    var idToName: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memberTableView.delegate = self
        memberTableView.dataSource = self
        memberTableView.reloadData()

        titleField.isUserInteractionEnabled = false
        titleField.text = transaction?.title
        
        amountField.isUserInteractionEnabled = false
        amountField.text = String(transaction!.amount)
        
        payerField.isUserInteractionEnabled = false
        payerField.text = idToName[(transaction?.payer)!]
        
        descrField.isUserInteractionEnabled = false
        descrField.text = transaction?.description
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TMemberCell", for: indexPath) as! TMemberTableViewCell
        cell.title.text = members[indexPath.row].name
        return cell
    }

}
