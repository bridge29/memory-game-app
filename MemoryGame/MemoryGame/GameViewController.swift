//
//  GameViewController.swift
//  MemoryGame
//
//  Created by Scott Bridgman on 12/6/14.
//  Copyright (c) 2014 Tohism. All rights reserved.
//

import UIKit

class GameViewController: baseGameViewController {

    @IBOutlet var colorLabels: [UILabel]!
    @IBOutlet var emojiLabels: [UILabel]!
    @IBOutlet var placeLabels: [UILabel]!
    
    var colorOrder: [Int] = []
    var emojiOrder: [Int] = []
    var testLevelNum: Int = levelNum + 1
    var scoreCount: Int   = 0  //// Score increments if correct item is ticked. If score == 3 then level has passed
    
    var colorWasTapped:Bool = false
    var emojiWasTapped:Bool = false
    var placeWasTapped:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        colorOrder = shuffle()
        emojiOrder = shuffle()
        newLevelToTest()
    
        for (idx, viewItem) in colorLabels.enumerate(){
            let tapGesture = UITapGestureRecognizer(target: self, action: "colorTapped:")
            tapGesture.numberOfTapsRequired = 1
            viewItem.addGestureRecognizer(tapGesture)
            viewItem.backgroundColor = colors[colorOrder[idx]]
        }
        
        for (idx, viewItem) in emojiLabels.enumerate(){
            let tapGesture = UITapGestureRecognizer(target: self, action: "emojiTapped:")
            tapGesture.numberOfTapsRequired = 1
            viewItem.addGestureRecognizer(tapGesture)
            viewItem.text = emojies[emojiOrder[idx]] as String
        }
        
        for viewItem in placeLabels{
            let tapGesture = UITapGestureRecognizer(target: self, action: "placeTapped:")
            tapGesture.numberOfTapsRequired = 1
            viewItem.addGestureRecognizer(tapGesture)
        }
        
        if showQuestionMarks{
            self.view.viewWithTag(52)?.removeFromSuperview()
            let messageLabel = UILabel(frame: CGRectMake(0.0, self.view.bounds.height * 0.63, self.view.bounds.width, self.view.bounds.height * 0.08))
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.backgroundColor   = UIColor.whiteColor()
            let msgStr = "Tap color, emoji and place"
            
            messageLabel.text = msgStr
            messageLabel.numberOfLines = 0
            let size:CGFloat = CGFloat(20 * mult)
            messageLabel.font = UIFont (name: "ChalkboardSE-Bold", size: size)
            messageLabel.textColor = UIColor.darkGrayColor()
            messageLabel.tag = 52
            self.view.addSubview(messageLabel)
        }
}
    
    func newLevelToTest(){
        testLevelNum--
        colorWasTapped = false
        emojiWasTapped  = false
        placeWasTapped = false
        scoreCount     = 0
        
        /// RESET BORDER
        for viewItem in colorLabels{
            viewItem.layer.borderWidth = 0.0
        }
        for viewItem in emojiLabels{
            viewItem.layer.borderWidth = 0.0
        }
        for viewItem in placeLabels{
            viewItem.layer.borderWidth = 0.0
        }
    }
    
    func checkDone(){
        scoreCount++
        if (scoreCount == 3){
            newLevelToTest()
        }
        if (testLevelNum == -1){
            self.view.viewWithTag(52)?.removeFromSuperview()
            let messageLabel = UILabel(frame: CGRectMake(0, self.view.bounds.height/1.6, self.view.bounds.width, 50))
            messageLabel.backgroundColor = UIColor.greenColor()
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.text = "Level \(levelNum + 1) Complete!"
            messageLabel.font = UIFont (name: "ChalkboardSE-Bold", size: 30)
            messageLabel.textColor = UIColor.darkGrayColor()
            self.view.addSubview(messageLabel)
            timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("unwind"), userInfo: nil, repeats: false)
        }
    }
    
    func colorTapped(gesture:UITapGestureRecognizer){
        if colorWasTapped {
            return
        }
        colorWasTapped = true
        let tappedView = gesture.view! as! UILabel
        tappedView.layer.borderWidth = 8.0

        if (colorOrder[tappedView.tag] == layouts[testLevelNum][0]) {
            tappedView.layer.borderColor = UIColor.greenColor().CGColor
            checkDone()
        }else{
            tappedView.layer.borderColor = UIColor.redColor().CGColor
            for (idx, label) in colorLabels.enumerate(){
                if (colorOrder[idx] == layouts[testLevelNum][0]){
                    label.layer.borderWidth = 8.0
                    label.layer.borderColor = UIColor.greenColor().CGColor
                    break
                }
            }
            self.view.viewWithTag(52)?.removeFromSuperview()
            gameOver()
        }
    }
    
    func emojiTapped(gesture:UITapGestureRecognizer){
        if emojiWasTapped {
            return
        }
        emojiWasTapped = true
        let tappedView = gesture.view! as! UILabel
        tappedView.layer.borderWidth = 8.0
        
        
        if (emojiOrder[tappedView.tag] == layouts[testLevelNum][1]) {
            tappedView.layer.borderColor = UIColor.greenColor().CGColor
            checkDone()
        }else{
            tappedView.layer.borderColor = UIColor.redColor().CGColor
            for (idx, label) in emojiLabels.enumerate(){
                if (emojiOrder[idx] == layouts[testLevelNum][1]){
                    label.layer.borderWidth = 8.0
                    label.layer.borderColor = UIColor.greenColor().CGColor
                    break
                }
            }
            gameOver()
        }
    }
    
    func placeTapped(gesture:UITapGestureRecognizer){
        if placeWasTapped {
            return
        }
        placeWasTapped = true
        let tappedView = gesture.view! as UIView
        tappedView.layer.borderWidth = 8.0
        
        if (tappedView.tag == layouts[testLevelNum][2]) {
            tappedView.layer.borderColor = UIColor.greenColor().CGColor
            checkDone()
        }else{
            tappedView.layer.borderColor = UIColor.redColor().CGColor
            for label in placeLabels{
                if (label.tag == layouts[testLevelNum][2]){
                    label.layer.borderWidth = 8.0
                    label.layer.borderColor = UIColor.greenColor().CGColor
                    break
                }
            }
            gameOver()
        }
    }

}

