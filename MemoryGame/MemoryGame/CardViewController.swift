//
//  CardViewController.swift
//  MemoryGame
//
//  Created by Scott Bridgman on 12/12/14.
//  Copyright (c) 2014 Tohism. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {

    @IBOutlet var emojiLabels: [UILabel]!
    var currentLevelNum: Int!
    var viewDidAppearFlag:Bool = false
    var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        if showQuestionMarks{
            messageLabel = UILabel(frame: CGRectMake(0.0, self.view.bounds.height * 0.4, self.view.bounds.width, 60))
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.numberOfLines = 0
            messageLabel.font = UIFont (name: "ChalkboardSE-Bold", size: 30)
            messageLabel.textColor = UIColor.darkGrayColor()
            self.view.addSubview(messageLabel)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if (levelNum == -1){
            emojies = setEmojies()
            colors  = setColors()
        }
        viewDidAppearFlag = false
        if (unwindToMenu){
            unwindToMenu = false
            goToMenu()
            return
        }
        
        (modeLevel == 2) ? makeLayoutsFromScratch() : appendCardLayouts()
        currentLevelNum = (modeLevel == 1) ? 0 : levelNum
        changeCard()
    }
    
    override func viewDidAppear(animated: Bool) {
        canPanMenu = false
        viewDidAppearFlag = true
    }

    func goToMenu(){
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    func checkIfDone(){
        if (viewDidAppearFlag && currentLevelNum < 0){
            performSegueWithIdentifier("cardToTestSegue", sender: self)
        }else{
            timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: Selector("checkIfDone"), userInfo: nil, repeats: false)
        }
    }
    
    func changeCard() {
        if currentLevelNum >= 0 {
            timer = NSTimer.scheduledTimerWithTimeInterval(waitTime, target: self, selector: Selector("changeCard"), userInfo: nil, repeats: false)
        }else{
            checkIfDone()
            return
        }
        if showQuestionMarks {
            self.messageLabel.text = "Screen \(levelNum - currentLevelNum + 1)"
        }
        makeLayout(layouts[currentLevelNum])
        currentLevelNum!--
    }
    
    func makeLayout(layout: [Int]){
        let colorNum = layout[0]
        let emojiNum = layout[1]
        let placeNum = layout[2]
        
        ///// SET CARD SPECS
        let emojiLabel: UILabel    = emojiLabels[placeNum]
        self.view.backgroundColor = colors[colorNum]
        emojiLabel.text = emojies[emojiNum] as String
        
        /// hide other labels
        for sl in emojiLabels{
            if sl.tag != placeNum {
                sl.hidden = true
            }else{
                sl.hidden = false
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //if (segue.identifier == "cardToTestSegue"){
        //    let dvc = segue.destinationViewController as! GameViewController
        //}
    }
}




