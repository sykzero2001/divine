//
//  RankTableViewCell.swift
//  占卜小遊戲
//
//  Created by 鄭涵嚴 on 2016/1/5.
//  Copyright © 2016年 鄭涵嚴. All rights reserved.
//

import UIKit

class RankTableViewCell: UITableViewCell {
    @IBOutlet weak var totalScore: UILabel!
    @IBOutlet weak var rankSeq: UILabel!
    @IBOutlet weak var rankName: UILabel!

    @IBOutlet weak var rankImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
