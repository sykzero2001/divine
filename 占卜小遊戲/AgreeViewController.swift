//
//  AgreeViewController.swift
//  占卜小遊戲
//
//  Created by 鄭涵嚴 on 2016/2/12.
//  Copyright © 2016年 鄭涵嚴. All rights reserved.
//

import UIKit

class AgreeViewController: UIViewController {
    var controller = UIViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func pushButton(sender: UIButton) {
        var dic = ["public":true]
        if
        sender.titleLabel?.text == "同意"
        {
        dic = ["public":true]
        }
        else
        {
        dic = ["public":false]
        }
        let title = controller.title
        if
            title == "Rank"
        {
                  NSNotificationCenter.defaultCenter().postNotificationName("RankAgreePublic", object: nil, userInfo: dic)
        }
        else
        {
              NSNotificationCenter.defaultCenter().postNotificationName("HomeAgreePublic", object: nil, userInfo: dic)
        }


        self.dismissViewControllerAnimated(true, completion: nil)
            
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
