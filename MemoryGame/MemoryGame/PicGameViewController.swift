//
//  PicGameViewController.swift
//  MemoryGame
//
//  Created by Scott Bridgman on 1/24/15.
//  Copyright (c) 2015 Tohism. All rights reserved.
//

import UIKit
import Photos
import AssetsLibrary

class PicGameViewController: baseGameViewController {

    @IBOutlet var itemImages: [UIImageView]!
    var itemOrder: [Int]   = [0,1,2,3]
    var testLevelNum: Int  = levelNum + 1
    var itemWasTapped:Bool = false
    var lastTappedTag:Int  = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        for (idx, pic) in pics.enumerate(){
            itemImages[idx].image = pic
        }
        itemOrder = shuffle()
        testLevelNum--
        
        //UIGraphicsBeginImageContext(backgroundImage.size);
        //[backgroundImage drawInRect:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
        //[watermarkImage drawInRect:CGRectMake(backgroundImage.size.width - watermarkImage.size.width, backgroundImage.size.height - watermarkImage.size.height, watermarkImage.size.width, watermarkImage.size.height)];
        //UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
        //UIGraphicsEndImageContext();
        
        
        for (idx, imageItem) in itemImages.enumerate(){
            let tapGesture = UITapGestureRecognizer(target: self, action: "itemTapped:")
            tapGesture.numberOfTapsRequired = 1
            imageItem.addGestureRecognizer(tapGesture)
            imageItem.image = pics[itemOrder[idx]]
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if unwindToMenu {
            newGame()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if itemWasTapped {
            gameOver()
        }
    }
    
    func itemTapped(gesture:UITapGestureRecognizer){
        
        let tappedView = gesture.view!
        if (itemWasTapped || lastTappedTag == tappedView.tag){
            return
        }
        itemWasTapped = true
        
        let layoutNum = 0
        for image in itemImages{
            image.layer.borderWidth = 0.0
        }
        if (itemOrder[tappedView.tag] == layouts[testLevelNum][layoutNum]) {
            tappedView.layer.borderWidth = BORDER_WIDTH
            tappedView.layer.borderColor = UIColor.greenColor().CGColor
            lastTappedTag = tappedView.tag
            correctTap()
        }else{
            //println("wrong")
            for (idx, image) in itemImages.enumerate(){
                if (itemOrder[idx] == layouts[testLevelNum][layoutNum]){
                    image.layer.borderWidth = BORDER_WIDTH
                    image.layer.borderColor = UIColor.greenColor().CGColor
                    break
                }
            }
            
            tappedView.layer.borderWidth = BORDER_WIDTH
            tappedView.layer.borderColor = UIColor.redColor().CGColor
            gameOver()
        }
    }
    
    func correctTap(){
        testLevelNum--
        if (testLevelNum == -1){
            for image in itemImages{
                image.layer.borderWidth = 0.0
            }
            let messageLabel = UILabel(frame: CGRectMake(0, self.view.bounds.height/2.0, self.view.bounds.width, 50))
            messageLabel.backgroundColor = UIColor.greenColor()
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.text = "Level \(levelNum + 1) Complete!"
            let size:CGFloat = CGFloat(25 * mult)
            messageLabel.font = UIFont (name: "ChalkboardSE-Bold", size: size)
            messageLabel.textColor = UIColor.darkGrayColor()
            self.view.addSubview(messageLabel)
            timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("unwind"), userInfo: nil, repeats: false)
        }else{
            itemWasTapped = false
        }
    }

}
