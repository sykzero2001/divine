//
//  TeachViewController1.swift
//  占卜小遊戲
//
//  Created by 鄭涵嚴 on 2016/1/15.
//  Copyright © 2016年 鄭涵嚴. All rights reserved.
//

import UIKit

class TeachViewController1: UIViewController {
    @IBOutlet weak var startBattleLabel: UILabel!
    @IBOutlet weak var attackButton: UIButton!

    @IBOutlet weak var displayText: UILabel!
    @IBOutlet weak var luckyNumber: UILabel!
    @IBOutlet weak var startButton: UIButton!
    var displayCount = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.layer.borderWidth = 1
        startButton.layer.borderColor = UIColor.redColor().CGColor
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        if displayCount != 1
        {
            self.dismissViewControllerAnimated(false, completion: nil)
//            let alertController = UIAlertController(title: "教學模式", message: "新手教學結束！請開始享受遊戲吧！", preferredStyle: .Alert)
//            
//            // Create the actions
//            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
//                UIAlertAction in
//                NSLog("OK Pressed")
//                self.dismissViewControllerAnimated(true, completion: nil)
//            }
//            alertController.addAction(okAction)
//            
//            // Present the controller
//            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "teach2"
        {
            let controller = segue.destinationViewController as! TeachViewController2;
            controller.teachViewController1 = self;
        }
    }

    @IBAction func start(sender: UIButton) {
    startButton.hidden = true
    luckyNumber.hidden = false
    startBattleLabel.hidden = false
    attackButton.layer.borderWidth = 1
    attackButton.layer.borderColor = UIColor.redColor().CGColor
    attackButton.hidden = false
    displayText.hidden = true
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
