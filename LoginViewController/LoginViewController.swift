//
//  LoginViewController.swift
//  Settlers
//
//  Created by Tyler Kaye on 8/28/18.
//  Copyright © 2018 Tyler Kaye. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit
import StitchCore
import StitchRemoteMongoDBService


class LoginViewController: UIViewController {
    
    // UI Elements
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var appDescr: UILabel!
    @IBOutlet weak var loginView: UIView!
    
    // Stitch Variables
    static var provider: StitchProviderType?
    private lazy var stitchClient = Stitch.defaultAppClient!
    private var mongoClient: RemoteMongoClient?
    private var profileCollection: RemoteMongoCollection<Document>?

    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends ])
        loginButton.center = view.center
        view.addSubview(loginButton)
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let accessToken = FBSDKAccessToken.current() {
            let credential = FacebookCredential.init(withAccessToken: accessToken.tokenString)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if let stitchClient = appDelegate.stitchClient {
                stitchClient.auth.login(withCredential: credential) {result in
                    switch result {
                    case .success(_):
                        self.checkProfileStatus()
                    case .failure(let error):
                        print("failed logging in Stitch with Facebook. error: \(error)")
                    }
                }
            }
        }
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
    
    func checkProfileStatus() {
        mongoClient = stitchClient.serviceClient(fromFactory: remoteMongoClientFactory, withName: "mongodb-atlas")
        profileCollection = mongoClient?.db("settlers").collection("profiles")
        profileCollection?.find().asArray({ result in
            switch result {
            case .success(let result):
                if result.count == 0 {
                    self.performSegue(withIdentifier: "ToNewProfile", sender: self)
                } else {
                    self.performSegue(withIdentifier: "ToGroups", sender: self)
                }
            case .failure(let error):
                print("Error in finding documents: \(error)")
            }
        })
    }

}
