//
//  NovelTableViewController.swift
//  占卜小遊戲
//
//  Created by 鄭涵嚴 on 2016/1/28.
//  Copyright © 2016年 鄭涵嚴. All rights reserved.
//

import UIKit

class NovelTableViewController: UITableViewController {
var novelSeq = 0
var totalSeq = 0
var qureyuserNovelData:PFObject?
var currentUser:PFUser?
var novelDataArray = [Novel]()
    @IBAction func infoButton(sender: UIBarButtonItem) {
        var messageStr = ""
        if
            self.novelSeq > 0 && self.totalSeq > 0
        {
//        var messageStr1 = "每天獲得十場勝利,即可解鎖一篇小說！目前共解鎖:"
//        var messageStr2 =  messageStr1 +
        let messageStr1 = "每天獲得十場勝利,即可解鎖一篇小說！\n每解鎖十篇小說可以多一個角色組合！\n目前共解鎖:" + String(novelSeq) + "/"
        messageStr = messageStr1 + String(totalSeq)
        }
        else
        {
        messageStr = "每天獲得十場勝利,即可解鎖一篇小說！"
        }
        let alertController = UIAlertController(title: "說明", message: messageStr, preferredStyle: .Alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    func getUserPlayerRoleData(){
        let qureyRole = PFQuery(className:"PlayerRole")
        qureyRole.isEqual("user")
        qureyRole.whereKey("user", equalTo: currentUser!)
        qureyRole.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            
            if error != nil || object == nil {
                print("PlayerError")
            } else {
                let todayWinCount = String(object!["wincount"])
                self.navigationController!.navigationBar.topItem?.title = "每日勝場進度:" + todayWinCount + "/10"
                
                if
                    self.qureyuserNovelData!["novelopen"] as! Bool == false && object!["wincount"] as! Int >= 10
                {
                    self.novelSeq = self.novelSeq + 1
                    self.qureyuserNovelData!["novelopen"] = true
                    if
                        self.novelSeq != 0  && self.novelSeq % 10 == 0
                    {
                    let query = PFUser.query()
                    query?.isEqual(self.currentUser!)
                        query?.findObjectsInBackgroundWithBlock{ (userObjects:[PFObject]?, errors:NSError?) -> Void in
                            for userobject in userObjects!
                            {
                               userobject["rolecount"] = userobject["rolecount"] as! Int + 1
                                userobject.saveEventually()
                            }
                    }
                    }
                
                }
                self.qureyuserNovelData!["novelseq"] = self.novelSeq
                self.qureyuserNovelData!.saveEventually()
                SVProgressHUD.dismiss()
                //讀取小說內容
                let qureyNovel = PFQuery(className:"Novel")
                qureyNovel.orderByAscending("seq")
                qureyNovel.findObjectsInBackgroundWithBlock { (novelObjects:[PFObject]?, errors:NSError?) -> Void in
                    self.novelDataArray.removeAll()
                    for
                        novelObject in novelObjects!
                    {
                        let tmpSeq = novelObject["seq"] as! Int
                        if
                            self.novelSeq >= tmpSeq
                        {
                            let novelInstance = Novel.init(seq:novelObject["seq"] as! Int,stage:novelObject["stage"] as! Int,part:novelObject["part"] as! Int,content:novelObject["content"] as! String,title:novelObject["title"] as! String)
                        self.novelDataArray.append(novelInstance)
                        }
                    }
                self.tableView.reloadData()
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = PFUser.currentUser()
        let query = PFQuery(className:"Novel")
        query.countObjectsInBackgroundWithBlock {
            (count: Int32, error: NSError?) -> Void in
            if error == nil {
                self.totalSeq = Int(count)
             }
        }
      
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewWillAppear(animated: Bool) {
        if
            currentUser != nil
        {
            let qureyuserNovel = PFQuery(className:"UserNovel")
            qureyuserNovel.isEqual("user")
            qureyuserNovel.whereKey("user", equalTo: currentUser!)
            SVProgressHUD.show()
            var userNovelSet:PFObject?
//            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            do {
//                delegate.window?.userInteractionEnabled = false
                userNovelSet = try qureyuserNovel.getFirstObject();
            } catch _ {
                userNovelSet = nil
            }
                //若是第一次需建立小說設定檔
                if
                    userNovelSet == nil
                {
                    self.qureyuserNovelData  = PFObject(className:"UserNovel")
                    self.qureyuserNovelData!["user"] = self.currentUser
                    self.qureyuserNovelData!["novelseq"] = 0
                    self.qureyuserNovelData!["novelopen"] = false
                    self.novelSeq = 0
                    self.qureyuserNovelData!.saveEventually()
                }
                    //若不是則直接讀取小說設定檔
                else
                {
                    self.qureyuserNovelData = userNovelSet!
                    self.novelSeq = userNovelSet!["novelseq"] as! Int
                }
                self.getUserPlayerRoleData()
            }
        
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
        return novelDataArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath)

        if
            novelDataArray.count > 0
        {
            let subtitle1 = String(novelDataArray[indexPath.row].stageValue) + "-"
            let subtitle = subtitle1 + String(novelDataArray[indexPath.row].partValue)
            cell.detailTextLabel?.text = subtitle
            cell.textLabel?.text = novelDataArray[indexPath.row].titleValue
        }
        // Configure the cell...

        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("NovelContentViewController")
            as! NovelContentViewController
        controller.novelContent = novelDataArray[indexPath.row].contentValue
        self.navigationController?.pushViewController(controller, animated: true)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let controller = segue.destinationViewController as! NovelContentViewController;
        let controller = self.tableView.indexPathForCell(sender! as! UITableViewCell) as! NovelContentViewController
        let count = sender?.indexPath.row
//        let indexPathSender = tableView.indexPathForCell(sender)
//        controller.novelContent = novelDataArray[indexPathSender!.row].contentValue
    }


}
