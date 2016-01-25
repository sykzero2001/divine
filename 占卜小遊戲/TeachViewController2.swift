//
//  TeachViewController2.swift
//  占卜小遊戲
//
//  Created by 鄭涵嚴 on 2016/1/18.
//  Copyright © 2016年 鄭涵嚴. All rights reserved.
//

import UIKit

class TeachViewController2: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var startFightButton: UIButton!

    @IBOutlet weak var phaseText: UILabel!
    @IBOutlet weak var enemyRoleLabel: UILabel!
    @IBOutlet weak var startToSearch: UILabel!
    @IBOutlet weak var choseAttackRole: UILabel!
    @IBOutlet weak var battleView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    var displayCount = 1
    var teachViewController1 = TeachViewController1()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchButton.layer.borderWidth = 1
        searchButton.layer.borderColor = UIColor.redColor().CGColor
        // Do any additional setup after loading the view.
    }

    @IBAction func startFightPush(sender: UIButton) {
        self.performSegueWithIdentifier("teach3",sender: self)
    }
    override func viewWillAppear(animated: Bool) {
        switch
        displayCount{
        case 2:
//            setTeach()
            searchButton.setTitle("再次搜索敵人", forState: UIControlState.Normal)
            startToSearch.hidden = false
            battleView.hidden = true
            battleTeach.hidden = true
            startFight.hidden = true
            searchButton.layer.borderWidth = 1
            startToSearch.text = "按下再次搜索敵人按鈕"
            enemyRoleLabel.text = "學徒"
            phaseText.hidden = true
            startFightButton.layer.borderWidth = 0
        case 3:
            teachViewController1.displayCount = displayCount
            self.dismissViewControllerAnimated(false, completion: nil)
        default:
            break
        }
        
    }
//    func setTeach(){
//        searchButton.setTitle("再次搜索敵人", forState: UIControlState.Normal)
//        battleView.hidden = true
//        battleTeach.hidden = true
//        startFight.hidden = true
//        searchButton.layer.borderWidth = 1
//        startToSearch.text = "按下再次搜索敵人按鈕"
//    }
    @IBOutlet weak var battleTeach: UILabel!
    @IBOutlet weak var startFight: UILabel!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func pushSearch(sender: UIButton) {
    choseAttackRole.hidden = true
    startToSearch.hidden = true
    battleView.hidden = false
    battleTeach.hidden = false
    startFight.hidden = false
    startFightButton.layer.borderWidth = 1
    startFightButton.layer.borderColor = UIColor.redColor().CGColor
    searchButton.layer.borderWidth = 0
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "teach3"
        {
            let controller = segue.destinationViewController as! TeachViewController3;
            controller.teachView2Controller = self;
        }
    }

    //protocol
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        let returnValue:String ;
        if component == 1
        {
            returnValue = "流浪者";
        }
        else
        {
            returnValue = "迷路的";
            
        }
        return returnValue;
        
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2;
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       
            return 1
    }
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pickerLabel = UILabel();
        pickerLabel.textColor = UIColor.blackColor()
        if
            component == 1
        {
            pickerLabel.text = "流浪者"
            
        }
        else
        {
            pickerLabel.text = "迷路的"
        }
        // pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 15)
        pickerLabel.font = UIFont(name: "Arial-BoldMT", size: 15) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel
    }

}
