//
//  OldUserViewController.swift
//  占卜小遊戲
//
//  Created by 鄭涵嚴 on 2016/2/15.
//  Copyright © 2016年 鄭涵嚴. All rights reserved.
//

import UIKit

class OldUserViewController: UIViewController,UITextFieldDelegate {
    var homeController:HomeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        if
            homeController!.loginStatus == "YES"
        {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }


    @IBAction func login(sender: UIButton) {
        let textAccount = self.view.viewWithTag(1)as! UITextField
        let textPassword = self.view.viewWithTag(2)as! UITextField
        let noSpaceAccount = textAccount.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let noSpacePassword = textPassword.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if
            noSpaceAccount == "" || noSpacePassword == ""
        {
            self.showMessage("輸入錯誤", detailText: "帳號或密碼不可為空白")
        }
        else
        {
            SVProgressHUD.show()
            PFUser.logInWithUsernameInBackground(textAccount.text!, password:textPassword.text!) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    // Do stuff after successful login.
                    self.homeController!.loginStatus = "YES"
                    self.homeController!.checkUserSet()
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    self.showMessage("輸入錯誤", detailText: "帳號/密碼輸入錯誤！")
                    self.homeController!.loginStatus = "NO"
                    // The login failed. Check error to see why.
                }
                SVProgressHUD.dismiss()
            }

        }
    }
    @IBAction func back(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let noSpaceString = textField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if
                noSpaceString == ""
            {
                self.showMessage("輸入錯誤", detailText: "帳號或密碼不可為空白")
            }
        return true
    }
    func showMessage(title:String,detailText detail:String)
    {
    let alertController = UIAlertController(title: title, message: detail, preferredStyle: .Alert)
    
    // Create the actions
    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
        UIAlertAction in
    }
    
    // Add the actions
    alertController.addAction(okAction)
    
    // Present the controller
    self.presentViewController(alertController, animated: true, completion: nil)
    
    }


}
