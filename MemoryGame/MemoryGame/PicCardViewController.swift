//
//  PicCardViewController.swift
//  MemoryGame
//
//  Created by Scott Bridgman on 1/24/15.
//  Copyright (c) 2015 Tohism. All rights reserved.
//

import UIKit
import Photos

class PicCardViewController: UIViewController {

    @IBOutlet weak var picImage: UIImageView!
    var currentLevelNum: Int!
    var viewDidAppearFlag:Bool = false
    var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        if showQuestionMarks{
            
            messageLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.width, 60))
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.font = UIFont (name: "ChalkboardSE-Bold", size: 30)
            messageLabel.textColor = UIColor.darkGrayColor()
            self.view.addSubview(messageLabel)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        canPanMenu = false
        
        if (levelNum == -1){
            
            let fetchOptions: PHFetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate",ascending:true)]
            let fetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options:fetchOptions)
            
            if fetchResult.count >= 4 {
                
                if (numOfPics == -1){
                    numOfPics = fetchResult.count
                }

                pics = []
                let picNums:[Int] = getPicNums(numOfPics)
                
                for picNum in picNums{
                    let randAsset: PHAsset = fetchResult[picNum] as! PHAsset
                    let options = PHImageRequestOptions()
                    options.synchronous = true
                    options.deliveryMode = .HighQualityFormat
                    
                    PHImageManager.defaultManager().requestImageForAsset(randAsset, targetSize: self.picImage.bounds.size, contentMode: PHImageContentMode.AspectFill, options: options, resultHandler: { (result, info) -> Void in
                        pics.append(result!)
                    })
                }
                
            }else{
                let actionSheetController: UIAlertController = UIAlertController(title: "Not Enough Photos", message: "Either there was an error in accessing your photos, or you do not have enough for memory game.\n4 are required.", preferredStyle: .Alert)
                let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .Default) { action -> Void in
                    self.navigationController?.popViewControllerAnimated(false)
                }
                actionSheetController.addAction(okAction)
                self.presentViewController(actionSheetController, animated: true, completion: nil)
                return
            }
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
        viewDidAppearFlag = true
    }

    func goToMenu(){
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    func getPicNums(numOfPics:Int) -> [Int]{
        var picNum:Int
        var picNums:[Int] = []
        while (picNums.count < 4){
            picNum = randInRange(0...(numOfPics-1))
            if (!picNums.contains(picNum)){
                picNums.append(picNum)
            }
        }
        return picNums
    }
    
    func checkIfDone(){
        if (viewDidAppearFlag && currentLevelNum < 0){
            performSegueWithIdentifier("imageCardToTest", sender: self)
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
            self.messageLabel.text = "Photo \(levelNum - currentLevelNum + 1)"
        }
        
        makeLayout(layouts[currentLevelNum])
        currentLevelNum!--
    }
    
    func makeLayout(layout: [Int]){
        let picNum = layout[0]
        self.picImage.image = pics[picNum]
    }

}
