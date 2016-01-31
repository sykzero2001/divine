//
//  Rank.swift
//  占卜小遊戲
//
//  Created by 鄭涵嚴 on 2016/1/30.
//  Copyright © 2016年 鄭涵嚴. All rights reserved.
//

import UIKit

class Rank: NSObject {
    let usernameValue:String
    let photoUrlValue:String
    let scoreValue:Int
    let winValue:Int
    let winRateValue:Float
    let userIdValue:String
    init(username:String,photoUrl:String,score:Int,win:Int,winRate:Float,userId:String){
        usernameValue = username
        photoUrlValue = photoUrl
        scoreValue = score
        winValue = win
        winRateValue = winRate
        userIdValue = userId
    }

}
