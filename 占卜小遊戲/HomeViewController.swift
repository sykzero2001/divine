//
//  ViewController.swift
//  占卜小遊戲
//
//  Created by 鄭涵嚴 on 2015/11/9.
//  Copyright © 2015年 鄭涵嚴. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource{
    @IBOutlet weak var adView: GADBannerView!
    @IBOutlet weak var startDivine: UIButton!
    @IBOutlet weak var startBattle: UIButton!
    @IBOutlet weak var totalScore: UILabel!
    @IBOutlet weak var defenseConst: NSLayoutConstraint!
    @IBOutlet weak var attackConst: NSLayoutConstraint!
    @IBOutlet weak var startConst: NSLayoutConstraint!
    @IBOutlet weak var luckyNum: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var phase: UILabel!
    @IBOutlet weak var myPicker: UIPickerView!;
    @IBOutlet weak var battleNum: UILabel!
    var pickerAppeData = [RoleSetting]();
    var pickerRoleData = [RoleSetting]();
    var totalAppeData = [RoleSetting]();
    var totalRoleData = [RoleSetting]();
    var luckNumber = 0;
    var attackBattleNum = 0
    var loginStatus:String?
    var theRoleDisplay = ""
    var theAppeDisplay = ""
    var currentUser:PFUser?
    var refresh = "Y"
    var teachMode = "N"
    func checkUserSet()
    {
    currentUser = PFUser.currentUser()
        //讀取角色設定,檢查是否要重新占卜
        if currentUser != nil
        {
            let qureyPlayerRole = PFQuery(className:"PlayerRole");
            qureyPlayerRole.isEqual("user")
            qureyPlayerRole.whereKey("user", equalTo: currentUser!)
            qureyPlayerRole.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, errors:NSError?) -> Void in
                if
                    objects != nil && objects?.count != 0
                {
                    for object in objects!{
                        let updateTime = object.updatedAt! as NSDate
                        let date = NSDate();
                        // "Apr 1, 2015, 8:53 AM" <-- local without seconds
                        let formatter = NSDateFormatter();
                        formatter.dateFormat = "yyyy-MM-dd";
                        let lastTimeZoneStr = formatter.stringFromDate(updateTime);
                        let dateZoneStr = formatter.stringFromDate(date);
                        if
                            dateZoneStr <= lastTimeZoneStr
                        {
                            self.refresh = "N"
                        }
                        
                    }
                    //若不需重新占卜
                    if
                        self.refresh == "N"
                        
                    {
                        for object in objects!{
                            
                            let roleSetting = RoleSetting.init(name: object["role"] as! String, valueProp: object["rolevalue"] as! Int);
                            let appeSetting = RoleSetting.init(name: object["appellation"] as! String, valueProp: object["appevalue"] as! Int);
                            self.pickerRoleData.append(roleSetting)
                            self.pickerAppeData.append(appeSetting)
                            let luckColor = UIColor(red: object["redvalue"] as! CGFloat, green: object["greenvalue"] as! CGFloat, blue: object["bluevalue"] as! CGFloat, alpha:1.0);
                            self.colorView.backgroundColor = luckColor;
                            self.luckyNum.text = String(object["luckynumber"]);

                        }
//                    let qureyAppellation = PFQuery(className:"Appellation");
//                    self.getParseData(qureyAppellation,name:"adjective",battleValue:"value",numberCompient:0);
//                        let qureyRole = PFQuery(className:"Role");
//                    self.getParseData(qureyRole,name:"roleName",battleValue:"battleValue",numberCompient:1);
//                        self.startConst.constant = 0
//                        self.defenseConst.constant = 30
//                        self.attackConst.constant = 30
                    }
                }
                let qureyAppellation = PFQuery(className:"Appellation");
                self.getParseData(qureyAppellation,name:"adjective",battleValue:"value",numberCompient:0);
                let qureyRole = PFQuery(className:"Role");
                self.getParseData(qureyRole,name:"roleName",battleValue:"battleValue",numberCompient:1);
            }
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        startDivine.layer.cornerRadius = startDivine.layer.bounds.size.width/10
        startBattle.layer.cornerRadius = startBattle.layer.bounds.size.width/10
        defenseConst.constant = 0
       attackConst.constant = 0
        startConst.constant = 0
        currentUser = PFUser.currentUser()
        if currentUser == nil
        {
       login()
        }
        else
        {
        checkUserSet()
        }
        adView.adUnitID = "ca-app-pub-2545255102687972/6493325241"
        adView.rootViewController = self
        adView.loadRequest(GADRequest.init())
//        self.view.window?.rootViewController = CJPAdController.sharedInstance()
//        self.view.window?.rootViewController = CJPAdController.sharedInstance()
//        self.view.window?.rootViewController = CJPAdController.sharedInstance()
    }
    override func viewWillAppear(animated: Bool) {
        currentUser = PFUser.currentUser()
        if
            currentUser != nil
        {
        let query = PFQuery(className: "Rank")
        query.whereKey("user", equalTo: currentUser!)
        do {
            let userScoreData = try query.getFirstObject();
            self.totalScore.text = String(userScoreData["score"])
        } catch _ {
            self.totalScore.text = ""
        }
        }
        if
            teachMode == "Y"
        {
        let alertController = UIAlertController(title: "教學模式", message: "新手教學結束！請開始享受遊戲吧！", preferredStyle: .Alert)
        
                    // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                        UIAlertAction in
                        NSLog("OK Pressed")
                    }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
            teachMode = "N"
        }
        
                    // Present the controller
    }
    
    override func viewDidAppear(animated: Bool) {
        if
            loginStatus == "NO"
        {
            let alertController = UIAlertController(title: "請先登入", message: "請先登入FaceBook帳號", preferredStyle: .Alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                NSLog("OK Pressed")
            self.loginStatus = nil
                self.login()
            }
            
            // Add the actions
            alertController.addAction(okAction)
            
            // Present the controller
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    @IBAction func start(sender: UIButton) {
        //取得形容詞與角色
        pickerRoleData.removeAll();
        pickerAppeData.removeAll();
        var tmpAdd = totalAppeData.shuffle();
        var tmpRoleAdd = totalRoleData.shuffle();
        for var i = 0;i <= 2;i++
        {
        pickerAppeData.append(tmpAdd[0]);
        pickerRoleData.append(tmpRoleAdd[0]);
        tmpAdd.removeFirst();
        tmpRoleAdd.removeFirst()
        };
//        self.myPicker.reloadAllComponents();
        //取得幸運數字
        luckNumber = Int(arc4random_uniform(100));
        luckyNum.text = String(luckNumber);
        
        //取得幸運顏色RGB
        let luckyR = CGFloat(arc4random_uniform(255))/225.0;
        let luckyG = CGFloat(arc4random_uniform(255))/225.0;
        let luckyB = CGFloat(arc4random_uniform(255))/225.0;
        let luckColor = UIColor(red: luckyR, green: luckyG, blue: luckyB, alpha:1.0);
        colorView.backgroundColor = luckColor;
        startConst.constant = 0
        defenseConst.constant = 30
        attackConst.constant = 30
        if
            currentUser == nil
        {
            currentUser = PFUser.currentUser()
        }
        let qureyPlayerRole = PFQuery(className:"PlayerRole");
        qureyPlayerRole.isEqual("user")
        qureyPlayerRole.whereKey("user", equalTo: currentUser!)
        qureyPlayerRole.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, errors:NSError?) -> Void in
            //若是第一次占卜需要建立角色設定檔
            if
                objects?.count == 0
            {
                for var i = 0 ;i < self.pickerAppeData.count; i++
               {
                let playerRoleData  = PFObject(className:"PlayerRole")
                playerRoleData["role"] = self.pickerRoleData[i].nameProperty
                playerRoleData["rolevalue"] = self.pickerRoleData[i].valueProperty
                playerRoleData["appellation"] = self.pickerAppeData[i].nameProperty
                playerRoleData["appevalue"] = self.pickerAppeData[i].valueProperty
                playerRoleData["user"] = self.currentUser
                playerRoleData["redvalue"] = luckyR
                playerRoleData["greenvalue"] = luckyG
                playerRoleData["bluevalue"] = luckyB
                playerRoleData["luckynumber"] = self.luckNumber
//                SVProgressHUD.show()
                playerRoleData.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // The object has been saved.
                    } else {
                        // There was a problem, check error.description
                    }
//                SVProgressHUD.dismiss()
                }
                }
            }
            //若不是則更新角色設定檔
            else
            {
            var i = 0
            for object in objects!{
                object["role"] = self.pickerRoleData[i].nameProperty
                object["rolevalue"] = self.pickerRoleData[i].valueProperty
                object["appellation"] = self.pickerAppeData[i].nameProperty
                object["appevalue"] = self.pickerAppeData[i].valueProperty
                object["user"] = self.currentUser
                object["redvalue"] = luckyR
                object["greenvalue"] = luckyG
                object["bluevalue"] = luckyB
                object["luckynumber"] = self.luckNumber
                i++
                object.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // The object has been saved.
                    } else {
                        // There was a problem, check error.description
                    }
                    //                SVProgressHUD.dismiss()
                }
                }
            }
                
        }
        
        //計算戰力
//        let battleData = HomeViewController.getBattleValue(myPicker.selectedRowInComponent(0),roleCount:myPicker.selectedRowInComponent(1),lucknumber:luckNumber,roleArray:pickerRoleData,appearray:pickerAppeData)
//        phase.text = battleData.phase
//        battleNum.text = String(abs(battleData.battleValue))
//        attackBattleNum = battleData.battleValue
        
    }

    @IBAction func goBattle(sender: UIButton) {
       self.performSegueWithIdentifier("battle",sender: self)
    }
    

    func getParseData(qurey:PFQuery,name nameProp:String,battleValue battleValueProp:String ,numberCompient number:Int){
        SVProgressHUD.show()
        qurey.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, errors:NSError?) -> Void in
            for object in objects!{
                let roleSetting = RoleSetting.init(name: object[nameProp] as! String, valueProp: object[battleValueProp] as! Int);
                if
                    number == 1
                {
                    self.totalRoleData.append(roleSetting)
                    self.theRoleDisplay = "YES"
                }
                else
                {
                 self.totalAppeData.append(roleSetting);
                    self.theAppeDisplay = "YES"
                }
                
                if
                    self.theAppeDisplay == "YES" && self.theRoleDisplay == "YES" && self.refresh == "Y"
                {
                    self.startConst.constant = 30
                    self.attackConst.constant = 0
                }
                else
                {
                self.attackConst.constant = 30
                self.startConst.constant = 0
                }
            };
        SVProgressHUD.dismiss()
        };

    };
    func login()  {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "email", "user_friends"]) {
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
                            user.saveEventually()
                            self.teachMode = "Y"
                            let teachController = (self.storyboard?.instantiateViewControllerWithIdentifier("Teach1"))! as UIViewController
                            self.presentViewController(teachController, animated: true, completion: nil)
                        }
                    })
                    let gameScore = PFObject(className:"Rank")
                    gameScore["score"]  = 0
                    gameScore["win"]  = 0
                    gameScore["lose"]  = 0
                    gameScore["user"] = user
                    gameScore.saveEventually()
                    self.totalScore.text = "0"
                    print("User signed up and logged in through Facebook!")
                }
                else {
                    print("User logged in through Facebook!")
                    let query = PFQuery(className: "Rank")
                    query.whereKey("user", equalTo: user)
                    do {
                       let userScoreData = try query.getFirstObject();
                        self.totalScore.text = userScoreData["score"] as? String
                    } catch _ {
                        self.totalScore.text = ""
                    }

                }
            self.checkUserSet()
            self.loginStatus = "YES"
            }
            else {
            self.loginStatus = "NO"
            }
        }
       }

   static func getBattleValue(appeCount:Int,roleCount:Int,lucknumber:Int,roleArray:[RoleSetting],appearray:[RoleSetting])->(phase:String,battleValue:Int){
//        let appeCount = myPicker.selectedRowInComponent(0);
//        let roleCount = myPicker.selectedRowInComponent(1);
//        let lucknumber = Int(luckyNum.text!);
        let battlepValueNum = appearray[appeCount].valueProperty * roleArray[roleCount].valueProperty + lucknumber
        let phase:String;
        if
            battlepValueNum > 0
        {
            phase = "正義"
        }
        else
        {
            phase = "邪惡"
        }
        return(phase,battlepValueNum)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "battle"
        {
            let controller = segue.destinationViewController as! BattleViewController;
            controller.defenseAppeData = pickerAppeData;
            controller.defenseRoleData = pickerRoleData;
            controller.luckyNumber = luckNumber;
//            controller.attackAppe = pickerAppeData[myPicker.selectedRowInComponent(0)].nameProperty
//            controller.attackRole = pickerRoleData[myPicker.selectedRowInComponent(1)].nameProperty
//            controller.attackValue = attackBattleNum
            controller.randomAppeData = totalAppeData
            controller.randomRoleData = totalRoleData
            controller.battleType = "攻擊"
        }
    }
    
    //protocol
    
func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        let returnValue:String ;
        if component == 1
        {
        returnValue = pickerRoleData[row].nameProperty;
        }
        else
        {
        returnValue = pickerAppeData[row].nameProperty;
 
        }
        return returnValue;

    }
func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2;
    }
func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let battleData = HomeViewController.getBattleValue(myPicker.selectedRowInComponent(0),roleCount:myPicker.selectedRowInComponent(1),lucknumber:luckNumber,roleArray:pickerRoleData,appearray:pickerAppeData)
    phase.text = battleData.phase
    battleNum.text = String(abs(battleData.battleValue))
    attackBattleNum = battleData.battleValue
    }
func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 1
        {
            return pickerRoleData.count
        }
        else
        {
            return pickerAppeData.count
        }
        
    }
func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pickerLabel = UILabel();
        pickerLabel.textColor = UIColor.blackColor()
        if
            component == 1
        {
            pickerLabel.text = pickerRoleData[row].nameProperty

        }
        else
        {
            pickerLabel.text = pickerAppeData[row].nameProperty
        }
        // pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 15)
        pickerLabel.font = UIFont(name: "Arial-BoldMT", size: 15) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel
    }
}

extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}
extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

//class RoleSetting: NSObject {
//    let nameProperty:String
//    let valueProperty:Int
//    init(name:String,valueProp:Int){
////        super.init();
//        nameProperty = name;
//        valueProperty = valueProp;
//    }
//}
