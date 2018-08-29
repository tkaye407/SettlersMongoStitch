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
    
    private var stitchClient: StitchAppClient?
    static var provider: StitchProviderType?

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            stitchClient = try Stitch.initializeAppClient(withClientAppID: "settlers-wwwep")
        } catch {
            print("ERROR")
        }
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends ])
        loginButton.center = view.center
        view.addSubview(loginButton)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let accessToken = FBSDKAccessToken.current() {
            print("WE MADE IT")
            print(accessToken.userID)
            let credential = FacebookCredential.init(withAccessToken: accessToken.tokenString)
            stitchClient!.auth.login(withCredential: credential) {result in
                switch result {
                case .success(_):
                    print("LOGGED IN WITH STITCH")
                    print(self.stitchClient!.auth.currentUser!.id)
                case .failure(let error):
                    print("failed logging in Stitch with Facebook. error: \(error)")
                    LoginManager().logOut()
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
