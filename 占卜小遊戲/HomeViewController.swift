//
//  ViewController.swift
//  占卜小遊戲
//
//  Created by 鄭涵嚴 on 2015/11/9.
//  Copyright © 2015年 鄭涵嚴. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource{
    @IBOutlet weak var myPicker: UIPickerView!;
    var pickerAppeData = [RoleSetting]();
    var pickerRoleData = [RoleSetting]();
    var test = [String]();
    override func viewDidLoad() {
        super.viewDidLoad()
        let qureyAppellation = PFQuery(className:"Appellation");
        getParseData(qureyAppellation,name:"adjective",battleValue:"value",numberCompient:0);
        let qureyRole = PFQuery(className:"Role");
        getParseData(qureyRole,name:"roleName",battleValue:"battleValue",numberCompient:1);
        self.myPicker.reloadAllComponents();
//        qurey.selectKeys(["adjective"]);
        
    }
    
    func getParseData(qurey:PFQuery,name nameProp:String,battleValue battleValueProp:String ,numberCompient number:Int){
        qurey.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, errors:NSError?) -> Void in
            for object in objects!{
                let roleSetting = RoleSetting.init(name: object[nameProp] as! String, valueProp: object[battleValueProp] as! Int);
                if
                    number == 1
                {
                    self.pickerRoleData.append(roleSetting)
                }
                else
                {
                 self.pickerAppeData.append(roleSetting);
                }
                
            };
            self.myPicker.reloadAllComponents();
 
        };

    };
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        var pickerLabel = UILabel();
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
class RoleSetting: NSObject {
    let nameProperty:String
    let valueProperty:Int
    init(name:String,valueProp:Int){
//        super.init();
        nameProperty = name;
        valueProperty = valueProp;
    }
}
