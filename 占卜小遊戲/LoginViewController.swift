//
//  LoginViewController.swift
//  占卜小遊戲
//
//  Created by 鄭涵嚴 on 2015/12/17.
//  Copyright © 2015年 鄭涵嚴. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController{
    var homeController = HomeViewController()
    @IBOutlet weak var LoginView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(animated: Bool) {
        if
            homeController.loginStatus == "YES"
        {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    @IBAction func newAccount(sender: UIButton) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("NewUserViewController")
            as! NewUserViewController
        controller.homeController = homeController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    @IBAction func oldAccount(sender: UIButton) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("OldUserViewController")
            as! OldUserViewController
        controller.homeController = homeController
        self.presentViewController(controller, animated: true, completion: nil)
    }

    @IBAction func otherLog(sender: UIButton) {
    LoginView.hidden = false
    }
    @IBAction func facebookLog(sender: UIButton) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile"]) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"name,picture"]).startWithCompletionHandler({
                        (connection,result, error: NSError!) -> Void in
                        if error == nil {
                            //                            NSLog("%@",result)
                            print(result)
                            user["nickname"] = result["name"]
                            user["photo"] = result["picture"]!!["data"]!!["url"]!
                            user["rolecount"] = 3
                            user.saveEventually()
                            self.homeController.teachMode = "Y"
                            let teachController = (self.storyboard?.instantiateViewControllerWithIdentifier("Teach1"))! as UIViewController
                            self.presentViewController(teachController, animated: true, completion: nil)
                        }
                    })
                    let gameScore = PFObject(className:"Rank")
                    self.homeController.userRankObject = gameScore
                    gameScore["score"]  = 0
                    gameScore["win"]  = 0
                    gameScore["lose"]  = 0
                    gameScore["winrate"] = 0
                    gameScore["user"] = user
                    gameScore["public"] = false
                    gameScore.saveEventually()
                    self.homeController.totalScore.text = "0"
                    print("User signed up and logged in through Facebook!")
                }
                else {
                    print("User logged in through Facebook!")
                    let query = PFQuery(className: "Rank")
                    query.whereKey("user", equalTo: user)
                    do {
                        let userScoreData = try query.getFirstObject();
                        self.homeController.totalScore.text = userScoreData["score"] as? String
                    } catch _ {
                        self.homeController.totalScore.text = ""
                    }
                    
                }
                self.homeController.checkUserSet()
                self.homeController.loginStatus = "YES"
            }
            else {
                self.homeController.loginStatus = "NO"
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
