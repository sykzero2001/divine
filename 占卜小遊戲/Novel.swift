//
//  Novel.swift
//  占卜小遊戲
//
//  Created by 鄭涵嚴 on 2016/1/28.
//  Copyright © 2016年 鄭涵嚴. All rights reserved.
//

import UIKit

class Novel: NSObject {
    let seqValue:Int
    let partValue:Int
    let stageValue:Int
    let contentValue:String
    let titleValue:String
    init(seq:Int,stage:Int,part:Int,content:String,title:String){
        seqValue = seq
        stageValue = stage
        partValue = part
        contentValue = content
        titleValue = title
    }
}
