//
//  AddMemberTableViewController.swift
//  Settlers
//
//  Created by Tyler Kaye on 10/16/18.
//  Copyright © 2018 Tyler Kaye. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import StitchRemoteMongoDBService
import StitchCore

class AddMemberTableViewController: UITableViewController {
    
    private lazy var stitchClient = Stitch.defaultAppClient!
    private var mongoClient: RemoteMongoClient?
    private var profileCollection: RemoteMongoCollection<Document>?
    private var groupCollection: RemoteMongoCollection<Document>?

    
    var names: [String] = []
    var ids: [String] = []
    var group: Group?

    override func viewDidLoad() {
        mongoClient = stitchClient.serviceClient(fromFactory: remoteMongoClientFactory, withName: "mongodb-atlas")
        profileCollection = mongoClient?.db("settlers").collection("profiles")
        groupCollection = mongoClient?.db("settlers").collection("groupstO")
        
        if FBSDKAccessToken.current() != nil {
            FBSDKGraphRequest(graphPath: "/me/friends", parameters: nil)
                .start(completionHandler:  { (connection, result, error) in
                    if error == nil {
                        let resultDict = result as! Dictionary<String, Any>
                        let data = resultDict["data"] as! Array<Any>
                        for dat in data {
                            let prof = dat as! Dictionary<String, String>
                            self.names.append(prof["name"] ?? "")
                            self.ids.append(prof["id"] ?? "")
                        }
                        DispatchQueue.main.async{
                            self.tableView.reloadData()
                        }
                    } else {
                        print(error!)
                    }
                })
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath)
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var newMem = Document(["name": names[indexPath.row], "user_id": ids[indexPath.row]])
//        newMem["name"] = names[indexPath.row]
//        newMem["user_id"] = ids[indexPath.row]
        var uFilt = Document(["$push": Document(["members": newMem])])
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
                    let alert = UIAlertController(title: "New Member Failed", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alert, animated: true)
                }
        })
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

}
