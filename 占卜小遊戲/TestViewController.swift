//
//  TestViewController.swift
//  占卜小遊戲
//
//  Created by 鄭涵嚴 on 2016/1/19.
//  Copyright © 2016年 鄭涵嚴. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    @IBAction func startTest(sender: UIButton) {
        let teachController = (self.storyboard?.instantiateViewControllerWithIdentifier("Teach1"))! as UIViewController
        self.presentViewController(teachController, animated: true, completion: nil)
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
