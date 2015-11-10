//
//  ViewController.swift
//  占卜小遊戲
//
//  Created by 鄭涵嚴 on 2015/11/9.
//  Copyright © 2015年 鄭涵嚴. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource{
//    var horoscopeArray = ["2","2"];
    @IBOutlet weak var myPicker: UIPickerView!;
    var pickerData = [String]();
    override func viewDidLoad() {
        let qurey = PFQuery(className:"Appellation");
//        qurey.selectKeys(["adjective"]);
        qurey.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, errors:NSError?) -> Void in
            for object in objects!{
//                let adjective:NSString = object["adjective"] as! NSString;
                self.pickerData.append(object["adjective"] as! String);
            };
            self.myPicker.reloadAllComponents();
//            self.pickerView(self.myPicker, numberOfRowsInComponent: 0);
//            let finalCount = self.pickerData.count - 1;
//            for i in 0...finalCount
//            {
//            self.pickerView(self.myPicker, titleForRow:i, forComponent: 1)
//            }
//            self.myPicker.delegate = self;
//            self.myPicker.dataSource = self;

        };
        super.viewDidLoad()
//        myPicker.dataSource = self
//        myPicker.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        let returnValue:String ;
        returnValue = pickerData[row];
        return returnValue;

    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2;
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

}

