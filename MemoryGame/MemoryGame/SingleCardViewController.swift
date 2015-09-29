//
//  SingleCardViewController.swift
//  MemoryGame
//
//  Created by Scott Bridgman on 1/3/15.
//  Copyright (c) 2015 Tohism. All rights reserved.
//

import UIKit

class SingleCardViewController: UIViewController {

    @IBOutlet var cornerLabels: [UILabel]!
    @IBOutlet weak var emojiLabel: UILabel!
    var messageLabel: UILabel!
    var currentLevelNum: Int!
    var viewDidAppearFlag:Bool = false
    var gameNameStr: String!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        gameNameStr = (gameName == "place") ? "placement" : gameName
        
        if showQuestionMarks{
            
            let divNum:CGFloat = (gameName == "emoji") ? 0.2 : 0.4
            messageLabel = UILabel(frame: CGRectMake(0, self.view.bounds.height * divNum, self.view.bounds.width, 60))
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.font = UIFont (name: "ChalkboardSE-Bold", size: 30)
            messageLabel.textColor = UIColor.darkGrayColor()
            self.view.addSubview(messageLabel)
        }
    }
    
    override func viewWillAppear(animated: Bool) {

        canPanMenu = false
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
        //println("levelNum: \(levelNum). Layouts: \(layouts)")
    }
    
    override func viewDidAppear(animated: Bool) {
        viewDidAppearFlag = true
    }

    func goToMenu(){
        self.navigationController?.popViewControllerAnimated(false)
        
    }
    
    func checkIfDone(){
        if (viewDidAppearFlag && currentLevelNum < 0){
            performSegueWithIdentifier("singleCardToTest", sender: self)
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
            self.messageLabel.text = "\(gameNameStr) \(levelNum - currentLevelNum + 1)"
        }
        makeLayout(layouts[currentLevelNum])
        currentLevelNum!--
    }

    func makeLayout(layout: [Int]){
        let colorNum = layout[0]
        let emojiNum = layout[1]
        let placeNum = layout[2]
        
        /// ZERO OUT THE CARD SPECS
        for cornerLabel in cornerLabels{
            cornerLabel.text = ""
        }
        self.view.backgroundColor = UIColor.lightGrayColor()
        emojiLabel.text = ""
        
        /// SET CORRECT CARD SPECS
        if (gameName == "color"){
            self.view.backgroundColor = colors[colorNum]
        }else if (gameName == "emoji"){
            emojiLabel.text = emojies[emojiNum] as String
        }else if (gameName == "place"){
            cornerLabels[placeNum].text = emojies[0] as String
        }
    }

    /*
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        return true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //if (segue.identifier == "singleCardToTest"){
        //    let dvc = segue.destinationViewController as GameViewController
        //}
    }
    */
}


