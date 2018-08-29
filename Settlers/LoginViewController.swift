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

class LoginViewController: UIViewController {
    
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var appDescr: UILabel!
    @IBOutlet weak var loginView: UIView!
    private var stitchClient: StitchAppClient?
    static var provider: StitchProviderType?

    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends ])
        loginButton.center = view.center
        view.addSubview(loginButton)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        stitchClient = appDelegate.stitchClient
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let accessToken = FBSDKAccessToken.current() {
            print(accessToken.userID)
            let credential = FacebookCredential.init(withAccessToken: accessToken.tokenString)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if let stitchClient = appDelegate.stitchClient {
                stitchClient.auth.login(withCredential: credential) {result in
                    switch result {
                    case .success(_):
                        print("Stith UUID: " + stitchClient.auth.currentUser!.id)
                        self.performSegue(withIdentifier: "ToGroups", sender: self)
                    case .failure(let error):
                        print("failed logging in Stitch with Facebook. error: \(error)")
                    }
                }
            }
        }
//        self.performSegue(withIdentifier: "ToGroups", sender: self)
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

}
