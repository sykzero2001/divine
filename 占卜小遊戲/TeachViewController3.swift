//
//  TeachViewController3.swift
//  占卜小遊戲
//
//  Created by 鄭涵嚴 on 2016/1/19.
//  Copyright © 2016年 鄭涵嚴. All rights reserved.
//

import UIKit

class TeachViewController3: UIViewController {
    @IBOutlet weak var scoreText: UILabel!
    @IBOutlet weak var totalScore: UILabel!
    @IBOutlet weak var yourScore: UILabel!
    @IBOutlet weak var battleResult: UILabel!
    @IBOutlet weak var battleProcess: UILabel!
    @IBOutlet weak var enemyRole: UILabel!
    @IBOutlet weak var enemyAppe: UILabel!

    @IBOutlet weak var battleFightText: UILabel!
    @IBOutlet weak var enemyBattleValue: UILabel!
    var teachView2Controller = TeachViewController2()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        if
            teachView2Controller.displayCount == 2
        {
        enemyAppe.text = "天真的"
        enemyRole.text = "學徒"
        enemyBattleValue.text = "18"
        battleFightText.text = "你的戰力大於敵人戰力的兩倍,戰力差距過大,因此敗北!"
        battleProcess.text = "開打才發現忘了帶武器！"
        battleResult.text = "惜敗！"
        yourScore.text = "你失去了12分"
        totalScore.text = "441"
        scoreText.text = "你失去的分數為雙方戰力差的百分之一(8X1.5邪惡加成)"
        }
    }

    @IBAction func back(sender: UIButton) {
    
        teachView2Controller.displayCount = teachView2Controller.displayCount + 1
        self.dismissViewControllerAnimated(false, completion: nil)
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
