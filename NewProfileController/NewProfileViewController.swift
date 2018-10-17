//
//  NewProfileViewController.swift
//  Settlers
//
//  Created by Tyler Kaye on 10/16/18.
//  Copyright © 2018 Tyler Kaye. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import StitchRemoteMongoDBService
import StitchCore

class NewProfileViewController: UIViewController, UITextFieldDelegate {

    // UI Elements
    @IBOutlet weak var nameBox: UITextField!
    @IBOutlet weak var emailBox: UITextField!
    @IBOutlet weak var venmoBox: UITextField!
    
    // Stitch Variables
    private lazy var stitchClient = Stitch.defaultAppClient!
    private var mongoClient: RemoteMongoClient?
    private var profileCollection: RemoteMongoCollection<Document>?

    
    override func viewWillAppear(_ animated: Bool) {
        nameBox.delegate = self
        emailBox.delegate = self
        venmoBox.delegate = self
        let permissionDictionary = ["fields" : "id,name,first_name,last_name,gender,email,birthday,picture.type(large)"]
        if FBSDKAccessToken.current() != nil {
            FBSDKGraphRequest(graphPath: "/me", parameters: permissionDictionary)
                .start(completionHandler:  { (connection, result, error) in
                    if error == nil {
                        let dict = result as? Dictionary<String, AnyObject>
                        self.nameBox.text = dict?["name"] as! String
                        self.emailBox.text = dict?["email"] as! String
                    } else {
                        print(error)
                    }
                })
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    @IBAction func createProfile(_ sender: Any) {
        if venmoBox.text == "" {
            let errorAlert = UIAlertController(title: "Error", message: "Please input both a valid venmo username", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
                alert -> Void in
                self.present(errorAlert, animated: true, completion: nil)
            }))
            self.present(errorAlert, animated: true, completion: nil)
        } else {
            mongoClient = stitchClient.serviceClient(fromFactory: remoteMongoClientFactory, withName: "mongodb-atlas")
            profileCollection = mongoClient?.db("settlers").collection("profiles")
            var newProfile = Document()
            newProfile["name"] = nameBox.text ?? ""
            newProfile["email"] = emailBox.text ?? ""
            newProfile["venmo"] = venmoBox.text ?? ""
            newProfile["user_id"] = stitchClient.auth.currentUser?.id
            self.profileCollection?.insertOne(newProfile, {result in
                switch result {
                case .success(_):
                    self.performSegue(withIdentifier: "ToGroups", sender: self)
                case .failure(let error):
                    print("failed logging out: \(error)")
                }
            })
        }
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}
