//
//  RankTableViewController.swift
//  占卜小遊戲
//
//  Created by 鄭涵嚴 on 2015/12/31.
//  Copyright © 2015年 鄭涵嚴. All rights reserved.
//

import UIKit

class RankTableViewController: UITableViewController {
    var rankArray = [Rank]()
    var currentUserId = ""
    var rankType = "total"
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "getRankType:", name: "RankType", object: nil)
        tableView.allowsSelection = false
        let nib = UINib.init(nibName: "RankTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "RankCell")
        getNewRank()
        currentUserId = ((PFUser.currentUser()?.objectId)! as String)
        };
    @objc func getRankType(notification: NSNotification){
        rankType = notification.userInfo!["type"] as! String;
//        rankType = dic["Type"] as! String
        self.getNewRank()
    }
    func getNewRank(){
        let qureyRank = PFQuery(className:"Rank")
        qureyRank.includeKey("user")
        qureyRank.orderByDescending("score")
        switch
            rankType
        {
            case "total":
            qureyRank.orderByDescending("score")
            case "winCount":
            qureyRank.orderByDescending("win")
            case "winRate":
            qureyRank.orderByDescending("winrate")
            default:
            qureyRank.orderByDescending("score")
        }
        
        qureyRank.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, errors:NSError?) -> Void in
            self.rankArray.removeAll()
            for object in objects!{
                let user = object["user"] as! PFObject
                let userName = user["nickname"] as! String
                let userId = user.objectId! as String
//                let userName = String(userNameTmp)
                let photoUrl = object["user"]["photo"] as! String
//                let dic = ["user":userName ,"photo":photoUrl,"score":String(object["score"]),"win":String(object["win"]),"lose":String(object["lose"]),"userId":userId ]
                let ranlInstance = Rank.init(username: userName, photoUrl: photoUrl, score: object["score"] as! Int, win: object["win"] as! Int, winRate: object["winrate"] as! Float, userId: userId)
                self.rankArray.append(ranlInstance)
            };
            self.tableView.reloadData()
        }
    }
    override func viewWillAppear(animated: Bool) {
        getNewRank()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rankArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RankCell", forIndexPath: indexPath) as! RankTableViewCell

        // Configure the cell...
        if
             rankArray.count != 0
        {
         let rankData = rankArray[indexPath.row]
//        let photoUrl = NSURL.fileURLWithPath(rankData["photo"]!)
            let photoUrl = NSURL(string:rankData.photoUrlValue)! as NSURL
            let imageRequest = NSMutableURLRequest.init(URL: photoUrl, cachePolicy:NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 30.0)
            
            cell.rankImage.setImageWithURLRequest(imageRequest, placeholderImage:nil,success:{ (request:NSURLRequest,response:NSHTTPURLResponse?, image:UIImage) -> Void in
                cell.rankImage.layer.cornerRadius = cell.rankImage.bounds.size.width / 2.0;
                cell.rankImage.image = image;
                }, failure: {
                    (request:NSURLRequest,response:NSHTTPURLResponse?, error:NSError!) -> Void in
                   NSLog("error:%@",error)
                })
        cell.rankName.text = rankData.usernameValue
        switch rankType
            {
            case "total":
                 cell.totalScore.text = String(rankData.scoreValue)
            case "winCount":
                 cell.totalScore.text = String(rankData.winValue)
            case "winRate":
                 cell.totalScore.text = String(rankData.winRateValue * 100.0) + "%"
            default:
                cell.totalScore.text = String(rankData.scoreValue)
            }
//        cell.totalScore.text = String(rankData.scoreValue)
        cell.rankSeq.text = String(indexPath.row + 1)
        if
            currentUserId == rankData.userIdValue
        {
         cell.backgroundColor = UIColor.yellowColor()
        }
        else
        {
            cell.backgroundColor = UIColor.whiteColor()
        }
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
