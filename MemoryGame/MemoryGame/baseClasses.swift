//
//  baseClasses.swift
//  MemoryGame
//
//  Created by Scott Bridgman on 1/31/15.
//  Copyright (c) 2015 Tohism. All rights reserved.
//

import UIKit

class baseGameViewController: UIViewController {
    
    func showEndOfGameAlert(){
        var msg:String
        var detailMsg = ""
        /*
        if (showQuestionMarks){
            if modeLevel == 1{
                msg = "Remember\nIn single mode, you are only shown the new screen, but you need to remember the previous ones too!"
            }else if gameName == "master"{
                msg = "Remember\nIn master mode, you have to remember the color, emoji, and placement on each screen!"
            }else{
                msg = "Remember\nOn level \(levelNum + 1), there will be \(levelNum + 1) items to tap."
            }
        }
        */
        if (levelNum == 0){
            msg = "Play again?"
            detailMsg = ""
        }else if (newPr > 0){
            msg = "NEW HIGH SCORE: \(levelNum)\nYou are a  \(getAnimalLevel(levelNum, typeName: gameName, modeLevelNum: modeLevel))"
            newPr = 0
        }else{
            msg = "You got to level \(levelNum)\n\(getAnimalLevel(levelNum, typeName: gameName, modeLevelNum: modeLevel))"
        }
        let actionSheetController: UIAlertController = UIAlertController(title: msg, message: detailMsg, preferredStyle: .Alert)
        
        if gameName == "photo" {
            let sendAction: UIAlertAction = UIAlertAction(title: "Send to Friend", style: .Default) { action -> Void in
                self.performSegueWithIdentifier("sendPicSegue", sender: nil)
            }
            actionSheetController.addAction(sendAction)
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Home", style: .Default) { action -> Void in
            unwindToMenu = true
            self.newGame()
        }
        actionSheetController.addAction(cancelAction)
        
        let nextAction: UIAlertAction = UIAlertAction(title: "New Game", style: .Default) { action -> Void in
            self.newGame()
        }
        actionSheetController.addAction(nextAction)
        
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    func gameOver(){
        setLevel(gameName, levelNum: difficultyLevel, modeNum: modeLevel, newLevel: levelNum)
        //timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("showEndOfGameAlert"), userInfo: nil, repeats: false)
        showEndOfGameAlert()
    }
    
    func newGame(){
        levelNum = -1
        layouts  = []
        unwind()
    }
    
    func unwind() {
        self.navigationController?.popViewControllerAnimated(false)
    }
}