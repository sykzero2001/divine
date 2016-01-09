//
//  RankTableViewController.swift
//  占卜小遊戲
//
//  Created by 鄭涵嚴 on 2015/12/31.
//  Copyright © 2015年 鄭涵嚴. All rights reserved.
//

import UIKit

class RankTableViewController: UITableViewController {
    var rankArray = [[String:String]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib.init(nibName: "RankTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "RankCell")
        getNewRank()
//        let qureyRank = PFQuery(className:"Rank");
//        qureyRank.orderByDescending("score")
//        qureyRank.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, errors:NSError?) -> Void in
//            for object in objects!{
//                let userName = object["user"]["nickname"] as! String
//                let photoUrl = object["user"]["photo"] as! String
//                    let dic = ["user":userName ,"photo":photoUrl,"score":String(object["score"]) ]
//              self.rankArray.append(dic)
//            };
//        self.tableView.reloadData()
        };

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    func getNewRank(){
        let qureyRank = PFQuery(className:"Rank");
        qureyRank.orderByDescending("score")
        qureyRank.includeKey("user")
        qureyRank.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, errors:NSError?) -> Void in
            self.rankArray.removeAll()
            for object in objects!{
                let user = object["user"] as! PFObject
                let userName = user["nickname"] as! String
//                let userName = String(userNameTmp)
                let photoUrl = object["user"]["photo"] as! String
                let dic = ["user":userName ,"photo":photoUrl,"score":String(object["score"]) ]
                self.rankArray.append(dic)
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
            let photoUrl = NSURL(string:rankData["photo"]!)! as NSURL
            let imageRequest = NSMutableURLRequest.init(URL: photoUrl, cachePolicy:NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 30.0)
            
            cell.rankImage.setImageWithURLRequest(imageRequest, placeholderImage:nil,success:{ (request:NSURLRequest,response:NSHTTPURLResponse?, image:UIImage) -> Void in
                cell.rankImage.layer.cornerRadius = cell.rankImage.bounds.size.width / 2.0;
                cell.rankImage.image = image;
                }, failure: {
                    (request:NSURLRequest,response:NSHTTPURLResponse?, error:NSError!) -> Void in
                   NSLog("error:%@",error)
                })
            
        cell.rankName.text = rankData["user"]
        cell.totalScore.text = rankData["score"]
        cell.rankSeq.text = String(indexPath.row + 1)
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
