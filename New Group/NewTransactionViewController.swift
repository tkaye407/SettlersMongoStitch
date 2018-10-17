//
//  NewTransactionViewController.swift
//  Settlers
//
//  Created by Tyler Kaye on 8/27/18.
//  Copyright © 2018 Tyler Kaye. All rights reserved.
//

import UIKit
import StitchCore
import StitchRemoteMongoDBService

class NewTransactionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // UI Elements
    @IBOutlet weak var memberTableView: UITableView!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    
    // Stitch variables
    private var stitchClient: StitchAppClient?
    private var mongoClient: RemoteMongoClient?
    private var groupCollection: RemoteMongoCollection<Document>?
    
    // Group Variable
    var group: Group?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memberTableView.delegate = self
        memberTableView.dataSource = self
        descriptionField.delegate = self
        amountField.delegate = self
        titleField.delegate = self
        
        // Set above mongo / stitch variables
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        stitchClient = appDelegate.stitchClient
        mongoClient = stitchClient?.serviceClient(fromFactory: remoteMongoClientFactory, withName: "mongodb-atlas")
        groupCollection = mongoClient?.db("settlers").collection("groups")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addTransaction(transTitle: String, transDescr: String, transAmt: Double) {
        let newTrans = Transaction.newTransaction(title: transTitle, description: transDescr, amount: transAmt, payee: [self.stitchClient!.auth.currentUser!.id])
        let uFilt = Document(["$push": Document(["transactions": newTrans])])
        groupCollection?.updateOne(
            filter: ["_id": group?.objectID],
            update: uFilt,
            options: nil,
            {result in
                switch result {
                case .success(_):
                    DispatchQueue.main.async{
                        self.navigationController?.popViewController(animated: true)
                    }
                case .failure(let error):
                    let alert = UIAlertController(title: "New Transaction Failed", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alert, animated: true)
                }
            })
    }
    @IBAction func addTransactionPressed(_ sender: Any) {
        if titleField.text != "" {
            if descriptionField.text != "" {
                if amountField.text != "", let tAmt = Double(amountField.text!) {
                    addTransaction(transTitle: titleField.text!, transDescr: descriptionField.text!, transAmt: tAmt)
                } else {
                    let alert = UIAlertController(title: "Invalid Input", message: "Please enter a valid amount", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alert, animated: true)
                }
            } else {
                let alert = UIAlertController(title: "Invalid Input", message: "Please do not leave the description field blank", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                self.present(alert, animated: true)
            }
            
        } else {
            let alert = UIAlertController(title: "Invalid Input", message: "Please do not leave the title field blank", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            self.present(alert, animated: true)
        }
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
        return (group?.members.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! MemberTableViewCell
        cell.name.text = group?.members[indexPath.row].name
        return cell
    }

}
