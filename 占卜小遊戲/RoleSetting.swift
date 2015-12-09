//
//  RoleSetting.swift
//  占卜小遊戲
//
//  Created by 鄭涵嚴 on 2015/11/13.
//  Copyright © 2015年 鄭涵嚴. All rights reserved.
//

import UIKit

class RoleSetting: NSObject {
    let nameProperty:String
    let valueProperty:Int
    init(name:String,valueProp:Int){
        nameProperty = name;
        valueProperty = valueProp;
    }

}
