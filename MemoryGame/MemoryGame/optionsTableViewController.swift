//
//  optionsTableViewController.swift
//  MemoryGame
//
//  Created by Scott Bridgman on 6/3/15.
//  Copyright (c) 2015 Tohism. All rights reserved.
//

import UIKit

@objc
protocol OptionsViewControllerDelegate {
    func collapsePanel()
    func toggleQuestMarkVisibility()
}

class optionsTableViewController: UITableViewController {
    
    var rowItems:[String]  = ["what_is_mg", "tutorial_on", "show_rankings", "contact", "rate_mg"]
    let rowWidths:[Float]  = [180.0, 180.0, 140.0, 130.0, 140.0]
    let rowHeights:[Float] = [0.6, 0.6, 0.7, 0.6, 0.6]
    
    var delegate: OptionsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rowItems[1] = showQuestionMarks ? "tutorial_off" : "tutorial_on"
        self.tableView.rowHeight = 60
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return rowItems.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("menuCell", forIndexPath: indexPath) 
        
        if indexPath.row == 1 && view.viewWithTag(21) != nil {
            view.viewWithTag(21)!.removeFromSuperview()
        }
        
        let image = UIImage(named: rowItems[indexPath.row] as String)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 20, y: 15, width: CGFloat(rowWidths[indexPath.row]), height: cell.bounds.height * CGFloat(rowHeights[indexPath.row]))
        imageView.tag = indexPath.row + 20
        cell.addSubview(imageView)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row{
        case 0:
            setSlides("intro", maxNum:5)
            showQuestionMarks = !showQuestionMarks
            delegate?.toggleQuestMarkVisibility()
            delegate?.collapsePanel()
        case 1:
            showQuestionMarks = !showQuestionMarks
            rowItems[1] = showQuestionMarks ? "tutorial_off" : "tutorial_on"
            delegate?.toggleQuestMarkVisibility()
            delegate?.collapsePanel()
        case 2:
            setSlides("rankings", maxNum:1)
            delegate?.collapsePanel()
        case 3:
            UIApplication.sharedApplication().openURL(NSURL(string: "http://tohism.com/memory-game")!)
        case 4:
            //UIApplication.sharedApplication().openURL(NSURL(string : "itms://itunes.apple.com/de/app/x-gift/id1015079833?mt=8&uo=4")!)
            UIApplication.sharedApplication().openURL(NSURL(string : "http://appsto.re/us/zooG8.i")!)
            delegate?.collapsePanel()
        default:
            break
        }
        
    }
    
    func setSlides(tutorialName:String, maxNum:Int){
        tutorialSlide = 0
        tutName = tutorialName
        tutMaxNum = maxNum
        canPanMenu = false
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
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
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
