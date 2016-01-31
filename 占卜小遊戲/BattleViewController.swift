//
//  BattleViewController.swift
//  占卜小遊戲
//
//  Created by 鄭涵嚴 on 2015/12/4.
//  Copyright © 2015年 鄭涵嚴. All rights reserved.
//

import UIKit

class BattleViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    @IBOutlet weak var phaseInfoConst: NSLayoutConstraint!
    @IBOutlet weak var phaseInfoLabel: UILabel!
    @IBAction func phaseInfo(sender: UIButton) {
    if
        phaseInfoConst.constant == 0
    {
        phaseInfoConst.constant = 45
    }
    else
    {
       phaseInfoConst.constant = 0
    }
        if
            attackValue < 0
        {
            phaseInfoLabel.text = "(戰鬥獲得分數增加50%)"
            phaseInfoLabel.textColor = UIColor.redColor()
        }
        else
        {
            phaseInfoLabel.text = "(戰力增加20%)"
            phaseInfoLabel.textColor = UIColor.blueColor()
        }
    UIView.animateWithDuration(0.3, animations: { () -> Void in
        self.view.layoutIfNeeded()
    })
    }
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var fightButton: UIButton!
    @IBOutlet weak var battleTitleLabel: UILabel!
    @IBOutlet weak var defenseBattleValue: UILabel!
    @IBOutlet weak var defensePhase: UILabel!
    @IBOutlet weak var defense: UIPickerView!
    @IBOutlet weak var enemyRoleLabel: UILabel!

    
    @IBOutlet weak var battleView: UIView!
    @IBOutlet weak var enemyPhase: UILabel!
    var battleType = String()
    var defenseAppeData = [RoleSetting]();
    var defenseRoleData = [RoleSetting]();
    var randomAppeData = [RoleSetting]();
    var randomRoleData = [RoleSetting]();
    var enemyAppe = RoleSetting.init(name: "", valueProp: 0);
    var enemyRole = RoleSetting.init(name: "", valueProp: 0);
    var enemyBattleValue = 0;
    var attackAppe = NSString();
    var attackRole = NSString();
    var attackValue = 0;
    let usrDefault = NSUserDefaults.standardUserDefaults()
    var luckyNumber = 0;

    override func viewDidLoad() {
        super.viewDidLoad()
        searchButton.layer.cornerRadius = searchButton.layer.bounds.size.width/10
        fightButton.layer.cornerRadius = fightButton.layer.bounds.size.width/10
        battleTitleLabel.text = battleType
        battleView.hidden = true
        battleView.layer.borderWidth = 1
        battleView.layer.borderColor =  UIColor.grayColor().CGColor
        fightButton.hidden = true
        
        if
            battleType == "防禦"
        {
        let defenseAppValue = usrDefault.objectForKey("defenseAppValue")
        let defenseRoleValue = usrDefault.objectForKey("defenseRoleValue")
        if
           defenseAppValue != nil && defenseRoleValue != nil
        {
            
            let battleData = HomeViewController.getBattleValue(defenseAppValue as! Int,roleCount:defenseRoleValue as! Int,lucknumber:luckyNumber,roleArray:defenseRoleData,appearray:defenseAppeData)
            defensePhase.text = battleData.phase
            defenseBattleValue.text = String(abs(battleData.battleValue))
            defense.selectRow(defenseAppValue as! Int, inComponent:0, animated:false)
            defense.selectRow(defenseRoleValue as! Int, inComponent:1, animated:false)
        }
        }
        else
        {
            let battleData = HomeViewController.getBattleValue(0,roleCount:0,lucknumber:luckyNumber,roleArray:defenseRoleData,appearray:defenseAppeData)
            defensePhase.text = battleData.phase
            if
                battleData.battleValue < 0
            {
            defensePhase.textColor = UIColor.redColor()
            }
            else
            {
            defensePhase.textColor = UIColor.blueColor()
            }
            defenseBattleValue.text = String(abs(battleData.battleValue))
            attackValue = battleData.battleValue

        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
//        NSLog("attackAppe:%@",attackAppe)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func searchEnemy(sender: UIButton) {
        battleView.hidden = false
        fightButton.hidden = false
//        myAppe.text = defenseAppeData[defense.selectedRowInComponent(0)].nameProperty
//        myRole.text = defenseRoleData[defense.selectedRowInComponent(1)].nameProperty
//        myBattleValue.text = String(abs(attackValue))
        let enemyAppeArray = randomAppeData.shuffle();
        let enemyRoleArray = randomRoleData.shuffle();
        enemyAppe = enemyAppeArray[0];
        enemyRole = enemyRoleArray[0];
        enemyRoleLabel.text = enemyRole.nameProperty
        enemyBattleValue = enemyAppe.valueProperty * enemyRole.valueProperty
        if
            enemyBattleValue > 0
        {
        enemyPhase.text = "正義"
        enemyPhase.textColor = UIColor.blueColor()
        }
        else
        {
        enemyPhase.text = "邪惡"
        enemyPhase.textColor = UIColor.redColor()
        }
        sender.setTitle("再次搜索敵人", forState: UIControlState.Normal)
        
    }
    @IBAction func startFighting(sender: UIButton) {
    SVProgressHUD.show()
    battleView.hidden = true
    self.performSegueWithIdentifier("fight",sender: self)
    searchButton.setTitle("開始搜索敵人", forState: UIControlState.Normal)
    fightButton.hidden = true
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "fight"
        {
            attackAppe = defenseAppeData[defense.selectedRowInComponent(0)].nameProperty
            attackRole = defenseRoleData[defense.selectedRowInComponent(1)].nameProperty
            let controller = segue.destinationViewController as! FightViewController;
            controller.enemyAppeData = enemyAppe;
            controller.enemyRoleData = enemyRole;
            controller.enemyFightValue = enemyBattleValue;
            controller.myRole = attackRole
            controller.myAppe = attackAppe
            controller.myFightValue = attackValue
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
    //protocol
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        let returnValue:String ;
        if component == 1
        {
            returnValue = defenseRoleData[row].nameProperty;
        }
        else
        {
            returnValue = defenseAppeData[row].nameProperty;
            
        }
        return returnValue;
        
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2;
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        battleView.hidden = true
        fightButton.hidden = true
        if
            battleType == "防禦"
        {
        usrDefault.setObject(defense.selectedRowInComponent(0), forKey: "defenseAppValue")
        usrDefault.setObject(defense.selectedRowInComponent(1), forKey: "defenseRoleValue")
        usrDefault.synchronize()
        }
        let battleData = HomeViewController.getBattleValue(defense.selectedRowInComponent(0),roleCount:defense.selectedRowInComponent(1),lucknumber:luckyNumber,roleArray:defenseRoleData,appearray:defenseAppeData)
        defensePhase.text = battleData.phase
        if
            battleData.battleValue < 0
        {
            defensePhase.textColor = UIColor.redColor()
        }
        else
        {
            defensePhase.textColor = UIColor.blueColor()
        }

        defenseBattleValue.text = String(abs(battleData.battleValue))
        attackValue = battleData.battleValue
        if
            attackValue < 0
        {
            phaseInfoLabel.text = "(戰鬥獲得分數增加50%)"
            phaseInfoLabel.textColor = UIColor.redColor()
        }
        else
        {
            phaseInfoLabel.text = "(戰力增加20%)"
            phaseInfoLabel.textColor = UIColor.blueColor()
        }

        
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 1
        {
            return defenseRoleData.count
        }
        else
        {
            return defenseAppeData.count
        }
        
    }
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pickerLabel = UILabel();
        pickerLabel.textColor = UIColor.blackColor()
        if
            component == 1
        {
            pickerLabel.text = defenseRoleData[row].nameProperty
            
        }
        else
        {
            pickerLabel.text = defenseAppeData[row].nameProperty
        }
        // pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 15)
        pickerLabel.font = UIFont(name: "Arial-BoldMT", size: 15) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel
    }

}
