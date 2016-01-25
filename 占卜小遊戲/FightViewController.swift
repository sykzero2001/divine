//
//  FightViewController.swift
//  占卜小遊戲
//
//  Created by 鄭涵嚴 on 2015/12/9.
//  Copyright © 2015年 鄭涵嚴. All rights reserved.
//

import UIKit

class FightViewController: UIViewController {
    var enemyAppeData = RoleSetting.init(name: "", valueProp: 0);
    
    @IBOutlet weak var enemyAppeLabel: UILabel!
    @IBOutlet weak var enemyRoleLabel: UILabel!
    @IBOutlet weak var enemyFightValueLabel: UILabel!
    
    @IBOutlet weak var winOrLoseLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var battleResultLabel: UILabel!
    @IBOutlet weak var battleProcessLabel: UILabel!
    @IBOutlet weak var myFightValueLabel: UILabel!
    @IBOutlet weak var myAppeLabel: UILabel!
    @IBOutlet weak var myRoleLabel: UILabel!
    var enemyRoleData = RoleSetting.init(name: "", valueProp: 0);
    var enemyFightValue = 0;
    var myAppe = NSString();
    var myRole = NSString();
    var myFightValue = 0;
    var totalScore = 0;
    var userScoreData:PFObject?;
    var fightResult = [String:String]();
    var winCount = 0;
    var loseCount = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentUser = PFUser.currentUser()

        let query = PFQuery(className: "Rank")
        query.whereKey("user", equalTo: currentUser!)
        
        do {
            userScoreData = try query.getFirstObject();
        } catch _ {
            userScoreData = nil
        }
        totalScore = userScoreData!["score"] as! Int
        winCount = userScoreData!["win"] as! Int
        loseCount = userScoreData!["lose"] as! Int
        enemyAppeLabel.text = enemyAppeData.nameProperty
        enemyRoleLabel.text = enemyRoleData.nameProperty
        enemyFightValueLabel.text =  String(abs(enemyFightValue))
        myAppeLabel.text = myAppe as String
        myRoleLabel.text = myRole as String
        myFightValueLabel.text = String(abs(myFightValue))
        setTextColor(enemyAppeLabel,fightValue:enemyFightValue)
        setTextColor(enemyRoleLabel, fightValue: enemyFightValue)
        setTextColor(enemyFightValueLabel, fightValue: enemyFightValue)
        setTextColor(myAppeLabel, fightValue: myFightValue)
        setTextColor(myRoleLabel, fightValue: myFightValue)
        setTextColor(myFightValueLabel, fightValue: myFightValue)
        getFightResult()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setTextColor(textLabel:UILabel,fightValue value:Int){
        if
            value < 0
        {
        textLabel.textColor = UIColor.redColor()
        }
        else
        {
        textLabel.textColor = UIColor.blueColor()
        }
    }
    func getFightResult(){
        //計算真正的戰力
        var enemyRealFight = 0
        if
            enemyFightValue > 0
        {
        enemyRealFight = Int(Double(abs(enemyFightValue)) * 1.2)
        }
        else
        {
        enemyRealFight = abs(enemyFightValue)
        }
        var myRealFight = 0
        if
            myFightValue > 0
        {
        myRealFight = Int(Double(abs(myFightValue)) * 1.2)
        }
        else
        {
        myRealFight = abs(myFightValue)
        }
        //計算戰鬥結果
        var getScore = 0;
        if
        //戰力相等
            enemyRealFight == myRealFight
        {
            fightResult = ["對戰結果":"平手！","獲取分數":"","目前總分":String(totalScore)]
            
        }
        else if
         //敵方戰力較高
            enemyRealFight > myRealFight
        {
            if
                enemyRealFight >= myRealFight * 2
            {
            let battlePocessString = getBattleProcess(["就在快被打倒之際,你給了敵人致命一擊！","敵人要給你最後一擊時,不小心滑倒了！","就在敵人要解決你的瞬間,發現認錯了人"])
                getScore = (enemyRealFight - myRealFight) / 100
                //邪惡加成
                let getScoreReslut = getEvilBuff(myFightValue,battleScore:getScore)
                winCount = winCount + 1
                fightResult = ["對戰結果":"險勝！","獲取分數":"你獲得了" + String(getScoreReslut)+"分","對戰紀錄":battlePocessString,"目前總分":String(totalScore + getScoreReslut)]
            }
            else
            {
                getScore = (enemyRealFight - myRealFight)
                //邪惡加成
                let getScoreReslut = getEvilBuff(enemyFightValue,battleScore:getScore)
                var totalScoreTmp = 0
                if
                    totalScore - getScoreReslut >= 0
                {
                    totalScoreTmp = totalScore - getScoreReslut
                }
                else
                {
                    totalScoreTmp = 0
                }
                let battlePocessString = getBattleProcess(["壓倒性的力量擊潰了你！","在一番激烈交戰之後,仍然不敵而落敗","在決勝負的關鍵時刻,你的武器居然壞了！"])
                loseCount = loseCount + 1
                fightResult = ["對戰結果":"戰敗！","獲取分數":"你失去了" + String(getScoreReslut)+"分","對戰紀錄":battlePocessString,"目前總分":String(totalScoreTmp)]
            }
        }
        else
        //我方戰力較高
        {
            if
                myRealFight > enemyRealFight * 2
            {
                getScore = (myRealFight - enemyRealFight) / 100
                //邪惡加成
                let getScoreReslut = getEvilBuff(enemyFightValue,battleScore:getScore)

                var totalScoreTmp = 0
                if
                    totalScore - getScoreReslut >= 0
                {
                    totalScoreTmp = totalScore - getScoreReslut
                }
                else
                {
                    totalScoreTmp = 0
                }
                loseCount = loseCount + 1
                let battlePocessString = getBattleProcess(["在關鍵時刻,你不小心滑了一跤,被偷襲了！","開打才發現忘了帶武器！","敵人是你的夢中情人,你無法對他認真下手！"])
                fightResult = ["對戰結果":"惜敗！","獲取分數":"你失去了" + String(getScoreReslut)+"分","對戰紀錄":battlePocessString,"目前總分":String(totalScoreTmp)]
            }
            else
            {
                getScore = (myRealFight - enemyRealFight)
                //邪惡加成
                let getScoreReslut = getEvilBuff(myFightValue,battleScore:getScore)
                winCount = winCount + 1
                let battlePocessString = getBattleProcess(["你憤怒的致命一擊打倒了敵人！","敵人害怕你的殺氣,舉雙手投降了！","打到一半,敵人因肚子痛而逃走了！"])
                fightResult = ["對戰結果":"勝利！","獲取分數":"你獲得了" + String(getScoreReslut)+"分","對戰紀錄":battlePocessString,"目前總分":String(totalScore + getScoreReslut)]
            }
        }
        battleProcessLabel.text = fightResult["對戰紀錄"]
        battleResultLabel.text = fightResult["獲取分數"]
        winOrLoseLabel.text = fightResult["對戰結果"]
        totalScoreLabel.text = fightResult["目前總分"]
        userScoreData!["score"] = Int(fightResult["目前總分"]!)
        userScoreData!["win"] = winCount
        userScoreData!["lose"] = loseCount
        userScoreData!.saveEventually()
        SVProgressHUD.dismiss()
        
    }
    func getEvilBuff(battleValue:Int,battleScore:Int)->Int{
        if
            battleValue < 0
        {
            return Int(Double(battleScore) * 1.5)
        }
        else
        {
            return battleScore
        }
    }
    func getBattleProcess(battleArray:[String])->String{
        let arrayCount = Int(arc4random_uniform(UInt32(battleArray.count)))
        return battleArray[arrayCount]
    }
    @IBAction func back(sender: UIButton) {
    self.dismissViewControllerAnimated(true, completion: nil)
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
