//
//  NovelContentViewController.swift
//  占卜小遊戲
//
//  Created by 鄭涵嚴 on 2016/1/29.
//  Copyright © 2016年 鄭涵嚴. All rights reserved.
//

import UIKit

class NovelContentViewController: UIViewController {
    var novelContent = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if
            novelContent != ""
        {
            textView.text = novelContent
        }
    }
    @IBOutlet weak var textView: UITextView!
}
