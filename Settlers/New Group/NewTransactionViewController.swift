//
//  NewTransactionViewController.swift
//  Settlers
//
//  Created by Tyler Kaye on 8/27/18.
//  Copyright © 2018 Tyler Kaye. All rights reserved.
//

import UIKit

class NewTransactionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    let members = ["Tyler", "Drew", "Ted", "TK", "Nicole", "Gordon"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! MemberTableViewCell
        cell.name.text = members[indexPath.row]
        return cell
    }
    

    @IBOutlet weak var memberTableView: UITableView!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        memberTableView.delegate = self
        memberTableView.dataSource = self
        descriptionField.delegate = self
        amountField.delegate = self
        titleField.delegate = self

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addTransactionPressed(_ sender: Any) {
        addTransaction()
    }
    
    func addTransaction() {
        print("HI")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
