//
//  LoginViewController.swift
//  占卜小遊戲
//
//  Created by 鄭涵嚴 on 2015/12/17.
//  Copyright © 2015年 鄭涵嚴. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
//        PFFacebookUtils.logInInBackgroundWithReadPermissions(){
        // Do any additional setup after loading the view.
        let LoginButton = FBSDKLoginButton.init()
        LoginButton.center = self.view.center
        LoginButton.delegate = self
        LoginButton.readPermissions = ["public_profile", "email", "user_friends"]
//        self.view .addSubview(LoginButton)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {

    }
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
