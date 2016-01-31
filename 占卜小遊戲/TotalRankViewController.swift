//
//  TotalRankViewController.swift
//  占卜小遊戲
//
//  Created by 鄭涵嚴 on 2016/1/30.
//  Copyright © 2016年 鄭涵嚴. All rights reserved.
//

import UIKit

class TotalRankViewController: UIViewController {

    @IBAction func changeRankType(sender: UISegmentedControl) {
        var dic = ["type":"total"]
        switch
        sender.selectedSegmentIndex{
        case 0:
            dic = ["type":"total"]
        case 1:
            dic = ["type":"winCount"]
        case 2:
            dic = ["type":"winRate"]
        default:
             dic = ["type":"total"]
        }
         NSNotificationCenter.defaultCenter().postNotificationName("RankType", object: nil, userInfo: dic)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
