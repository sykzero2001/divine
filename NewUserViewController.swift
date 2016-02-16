//
//  NewUserViewController.swift
//  占卜小遊戲
//
//  Created by 鄭涵嚴 on 2016/2/15.
//  Copyright © 2016年 鄭涵嚴. All rights reserved.
//

import UIKit

class NewUserViewController: UIViewController,UITextFieldDelegate {
    var homeController:HomeViewController?
    var checkList = ["N","N","N"]
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(sender: UIButton) {
    self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func addNewAccount(sender: UIButton) {
        let textName = self.view.viewWithTag(2) as! UITextField
        let textAccount = self.view.viewWithTag(3)as! UITextField
        let textPassword = self.view.viewWithTag(4)as! UITextField
        let textPasswordRepeat = self.view.viewWithTag(5) as! UITextField
        let noSpaceName = textName.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let noSpacePassword = textPassword.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())

        if
            noSpaceName == ""
        {
            self.showMessage("名稱錯誤", detailText: "顯示暱稱不可為空白")
            self.checkList[0] = "N"
        }
        else
        {
         self.checkList[0] = "Y"
        }
        self.checkAccount(textAccount.text!)
        if
            noSpacePassword == "" || textPassword.text != textPasswordRepeat.text
        {
            self.showMessage("密碼不同", detailText: "兩次輸入的密碼需相同,且不可為空白")
            self.checkList[2] = "N"
        }
        else
        {
           self.checkList[2] = "Y"
        }
        if checkList.contains("N")  {
           
        }
        else
        {
            let user = PFUser()
            user.username = textAccount.text
            user.password = textPassword.text
            user["nickname"] = textName.text
            user["photo"] = "nil"
            user["rolecount"] = 3
            // other fields can be set just like with PFObject
            SVProgressHUD.show()
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    let errorString = error.userInfo["error"] as? NSString
                    self.homeController!.loginStatus = "NO"
                    SVProgressHUD.dismiss()
                    // Show the errorString somewhere and let the user try again.
                } else {
                    self.homeController!.teachMode = "Y"
                    let teachController = (self.storyboard?.instantiateViewControllerWithIdentifier("Teach1"))! as UIViewController
                    self.presentViewController(teachController, animated: true, completion: nil)
                    let gameScore = PFObject(className:"Rank")
                    self.homeController!.userRankObject = gameScore
                    gameScore["score"]  = 0
                    gameScore["win"]  = 0
                    gameScore["lose"]  = 0
                    gameScore["winrate"] = 0
                    gameScore["user"] = user
                    gameScore["public"] = false
                    gameScore.saveEventually()
                    self.homeController!.totalScore.text = "0"
                    self.homeController!.checkUserSet()
                    self.homeController!.loginStatus = "YES"
                    SVProgressHUD.dismiss()
                    // Hooray! Let them use the app now.
                }
            }
        }
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let noSpaceString = textField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        switch textField.tag
        {
            case 2:
                if
                    noSpaceString == ""
                {
                    self.showMessage("名稱錯誤", detailText: "顯示暱稱不可為空白")
                }
            case 3:
                self.checkAccount(textField.text!)
            case 5:
                let passwordText = self.view.viewWithTag(4) as! UITextField
                if
                    passwordText.text != textField.text || noSpaceString == ""
                {
                self.showMessage("密碼不同", detailText: "兩次輸入的密碼需相同,且不可為空白")
                }
            default:
                break
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
    func checkAccount(account:String) {
        let noSpaceString = account.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if
            noSpaceString != ""
        {
            let query = PFUser.query()
            query!.whereKey("username", equalTo:account)
            SVProgressHUD.show()
            var userData = [PFObject]()
            do {
                userData = try query!.findObjects()
            } catch _ {
                userData = [PFObject]()
            }
            if
                userData.count != 0
            {
                let alertController = UIAlertController(title: "帳號錯誤", message: "帳號已有人使用", preferredStyle: .Alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                    UIAlertAction in
                    let accountText = self.view.viewWithTag(3) as! UITextField
                    self.checkList[1] = "N"
                    accountText.text = ""
                }
                
                // Add the actions
                alertController.addAction(okAction)
                
                // Present the controller
                self.presentViewController(alertController, animated: true, completion: nil)

            }
            else
            {
                self.checkList[1] = "Y"
            }
            SVProgressHUD.dismiss()
        }
        else
        {
            self.checkList[1] = "N"
             self.showMessage("帳號錯誤", detailText: "帳號不可為空白")
        }
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
