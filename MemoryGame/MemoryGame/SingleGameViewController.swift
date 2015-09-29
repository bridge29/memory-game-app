//
//  SingleGameViewController.swift
//  MemoryGame
//
//  Created by Scott Bridgman on 1/18/15.
//  Copyright (c) 2015 Tohism. All rights reserved.
//

import UIKit

class SingleGameViewController: baseGameViewController {
    
    @IBOutlet var testLabels: [UILabel]!
    var itemOrder: [Int]   = [0,1,2,3]
    var testLevelNum: Int  = levelNum + 1
    var itemWasTapped:Bool = false
    var lastTappedTag:Int  = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        if (gameName != "place"){
            itemOrder = shuffle()
        }
        testLevelNum--
        for (idx, viewItem) in testLabels.enumerate(){
            //println("Timestamp: \(Timestamp)")
            let tapGesture = UITapGestureRecognizer(target: self, action: "itemTapped:")
            tapGesture.numberOfTapsRequired = 1
            viewItem.addGestureRecognizer(tapGesture)
            viewItem.backgroundColor = UIColor.lightGrayColor()
            
            if (gameName == "color"){
                viewItem.backgroundColor = colors[itemOrder[idx]]
                viewItem.text = ""
            }else if (gameName == "emoji"){
                viewItem.text = emojies[itemOrder[idx]] as String
            }else if (gameName == "place"){
                viewItem.text = emojies[0] as String
            }
        }
        
        if showQuestionMarks{
            
            self.view.viewWithTag(52)?.removeFromSuperview()
            let messageLabel = UILabel(frame: CGRectMake(0.0, self.view.bounds.height * 0.45, self.view.bounds.width, self.view.bounds.height * 0.1))
            messageLabel.textAlignment = NSTextAlignment.Center
            
            if gameName == "color" {
                messageLabel.backgroundColor = UIColor.lightGrayColor()
            }
            
            var msgStr = ""
            
            switch (testLevelNum){
                case 0:
                    msgStr += "Tap the \(gameName)"
                default:
                    msgStr += "Tap the \(testLevelNum + 1) \(gameName)s in order"
                    break
            }
            
            messageLabel.text = msgStr
            messageLabel.numberOfLines = 0
            let size:CGFloat = CGFloat(20 * mult)
            messageLabel.font = UIFont (name: "ChalkboardSE-Bold", size: size)
            messageLabel.textColor = UIColor.darkGrayColor()
            messageLabel.tag = 52
            self.view.addSubview(messageLabel)
        }
    }
    
    func resetBorder(){
        for viewItem in testLabels{
            viewItem.layer.borderWidth = 0.0
        }
    }
    
    func itemTapped(gesture:UITapGestureRecognizer){
        let tappedView = gesture.view! as! UILabel
        if (itemWasTapped || lastTappedTag == tappedView.tag){
            return
        }
        itemWasTapped = true
        
        var layoutNum: Int
        switch gameName {
            case "color":
                layoutNum = 0
            case "emoji":
                layoutNum = 1
            case "place":
                layoutNum = 2
            default:
                print("should not print")
                layoutNum = 0
                break
        }
        
        resetBorder()
        tappedView.layer.borderWidth = BORDER_WIDTH

        if (itemOrder[tappedView.tag] == layouts[testLevelNum][layoutNum]) {
            tappedView.layer.borderColor = UIColor.greenColor().CGColor
            lastTappedTag = tappedView.tag
            correctTap()
        }else{
            tappedView.layer.borderColor = UIColor.redColor().CGColor
            for (idx, label) in testLabels.enumerate(){
                if (itemOrder[idx] == layouts[testLevelNum][layoutNum]){
                    label.layer.borderColor = UIColor.greenColor().CGColor
                    label.layer.borderWidth = BORDER_WIDTH
                    break
                }
            }
            self.view.viewWithTag(52)?.removeFromSuperview()
            gameOver()
        }
    }

    func correctTap(){
        testLevelNum--
        if (testLevelNum == -1){
            resetBorder()
            self.view.viewWithTag(52)?.removeFromSuperview()
            let messageLabel = UILabel(frame: CGRectMake(0, self.view.bounds.height/2.0, self.view.bounds.width, 50))
            messageLabel.backgroundColor = UIColor.greenColor()
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.text = "Level \(levelNum + 1) Complete!"
            messageLabel.font = UIFont (name: "ChalkboardSE-Bold", size: 30)
            messageLabel.textColor = UIColor.darkGrayColor()
            self.view.addSubview(messageLabel)
            timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("unwind"), userInfo: nil, repeats: false)
        }else{
            itemWasTapped = false
        }
        
    }

}
