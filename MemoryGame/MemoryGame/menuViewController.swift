//
//  menuViewController.swift
//  MemoryGame
//
//  Created by Scott Bridgman on 1/3/15.
//  Copyright (c) 2015 Tohism. All rights reserved.
//  TODO:
//
//      POST LAUNCH:
//      Add options to send photos to a friend

import UIKit
import Photos
import AssetsLibrary

@objc
protocol MenuViewControllerDelegate {
    optional func toggleOptionsPanel()
    optional func collapseOptionsPanel()
}

class menuViewController: UIViewController {

    @IBOutlet weak var mainAnimalLabel: UILabel!
    @IBOutlet var animalLevels: [UILabel]!
    @IBOutlet var levelLabels: [UILabel]!
    @IBOutlet weak var speedLabel: UIImageView!
    @IBOutlet weak var modeLabel: UIImageView!
    @IBOutlet weak var speedSettingLabel: UIImageView!
    @IBOutlet weak var modeSettingLabel: UIImageView!
    @IBOutlet var questionMarkImages: [UIImageView]!
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var turnOffTutImage: UIImageView!
    @IBOutlet weak var tapMeImage: UIImageView!
    @IBOutlet var testImages: [UIImageView]!
    var delegate: MenuViewControllerDelegate?
    var rateNumber:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if (NSUserDefaults.standardUserDefaults().valueForKey("v1p4") == nil) {
            showQuestionMarks = true
            NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "v1p4")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        if DeviceType.IS_IPHONE_4_OR_LESS{
            mult = 1.0
        }else if DeviceType.IS_IPHONE_5{
            mult = 1.1
        }else if DeviceType.IS_IPHONE_6{
            mult = 1.3
        }else if DeviceType.IS_IPHONE_6P{
            mult = 1.5
        }else{
            mult = 1.0
        }
        
        resetMainAnimal(false)
        setSpeedImage()
        setModeImage()
        
        let tapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didTap:")
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        let speedTapGest = UITapGestureRecognizer(target: self, action: "speedTapped:")
        speedTapGest.numberOfTapsRequired = 1
        speedSettingLabel.addGestureRecognizer(speedTapGest)
        
        let modeTapGest = UITapGestureRecognizer(target: self, action: "modeTapped:")
        modeTapGest.numberOfTapsRequired = 1
        modeSettingLabel.addGestureRecognizer(modeTapGest)
        
        let mainAnimalGest = UITapGestureRecognizer(target: self, action: "mainAnimalTapped")
        mainAnimalGest.numberOfTapsRequired = 1
        mainAnimalLabel.addGestureRecognizer(mainAnimalGest)
        
        for imageView in testImages{
            let tapGesture = UITapGestureRecognizer(target: self, action: "testTapped:")
            tapGesture.numberOfTapsRequired = 1
            imageView.addGestureRecognizer(tapGesture)
        }
        
        for qmark in questionMarkImages{
            let tapGesture = UITapGestureRecognizer(target: self, action: "qmarkTapped:")
            tapGesture.numberOfTapsRequired = 1
            qmark.addGestureRecognizer(tapGesture)
        }
        
        if !showQuestionMarks {
            for qmark in questionMarkImages{
                qmark.hidden = true
            }
            self.turnOffTutImage.hidden = true
            self.tapMeImage.hidden = true
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "menuIconTapped")
        tapGesture.numberOfTapsRequired = 1
        self.menuImage.addGestureRecognizer(tapGesture)
        
        for level in levelLabels {
            level.layer.masksToBounds = true
            level.layer.cornerRadius = 23.0
            level.layer.borderWidth = 4.0;
            level.layer.borderColor = UIColor(red: CGFloat(74.0/255.0), green: CGFloat(144.0/255.0), blue: CGFloat(226.0/255.0), alpha:1.0).CGColor
            level.backgroundColor = UIColor(red: CGFloat(215.0/255.0), green: CGFloat(215.0/255.0), blue: CGFloat(200.0/255.0), alpha:1.0)
        }
        
        setMenuLevels()
        
        for (idx, imageView) in testImages.enumerate(){
            imageView.image = UIImage(named: "\(typeNames[idx])_label")
        }
        
        if (NSUserDefaults.standardUserDefaults().valueForKey("rateStatus") == nil) {
            self.rateNumber = 10
            NSUserDefaults.standardUserDefaults().setInteger(self.rateNumber, forKey: "rateStatus")
            NSUserDefaults.standardUserDefaults().synchronize()
            setSlides("intro", maxNum:5)
            changeSlideTutorial()
        } else {
            self.rateNumber = NSUserDefaults.standardUserDefaults().valueForKey("rateStatus") as! Int
            if self.rateNumber > 0 {
                self.rateNumber = self.rateNumber + 1
                NSUserDefaults.standardUserDefaults().setInteger(self.rateNumber, forKey: "rateStatus")
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
        canPanMenu = true
        setMenuLevels()
        resetMainAnimal(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        if self.rateNumber > 0 && rateNumber % 20 == 0 {
            showRateMe()
        }
    }
    
    func setSlides(tutorialName:String, maxNum:Int){
        tutorialSlide = 0
        tutName = tutorialName
        tutMaxNum = maxNum
        canPanMenu = false
    }
    
    func setMenuLevels() {
        var tempLevelNum: Int
        for idx in 0...4{
            tempLevelNum = getLevel(typeNames[idx], levelNum: difficultyLevel, modeNum: modeLevel)
            levelLabels[idx].text = "\(tempLevelNum)"
            levelLabels[idx].font = UIFont (name: "Helvetica Neue", size: 25)
            animalLevels[idx].text = getAnimalLevel(tempLevelNum, typeName: typeNames[idx], modeLevelNum: modeLevel) as String
            let size1:CGFloat = CGFloat(25*mult)
            let size2:CGFloat = CGFloat(40*mult)
            levelLabels[idx].font  = UIFont (name: "Helvetica Neue", size: size1)
            animalLevels[idx].font = UIFont (name: "Helvetica Neue", size: size2)
        }
    }
    
    func checkCanTap() -> Bool {
        
        if (tutorialSlide > -1){
            changeSlideTutorial()
            return false
        }
        
        if self.view.viewWithTag(70) != nil {
            return false
        }
        
        return true
    }
    
    func mainAnimalTapped(){
        
        if !checkCanTap(){
            return
        }
        
        self.navigationController?.navigationBar.hidden = false
        performSegueWithIdentifier("menuToRankings", sender: nil)
    }
    
    func speedTapped(gesture:UITapGestureRecognizer){
        
        if !checkCanTap(){
            return
        }
        
        difficultyLevel = (difficultyLevel + 1) % 3
        setSpeedImage()
        setMenuLevels()
        resetMainAnimal(false)
    }
    
    func modeTapped(gesture:UITapGestureRecognizer){
        
        if !checkCanTap(){
            return
        }
        
        modeLevel = (modeLevel + 1) % 3
        setModeImage()
        setMenuLevels()
        resetMainAnimal(false)
    }
    
    func menuIconTapped(){
        
        if !checkCanTap(){
            return
        }
        
        canPanMenu = true
        delegate?.toggleOptionsPanel!()
    }
    
    func qmarkTapped(gesture:UITapGestureRecognizer){
        
        if !checkCanTap(){
            return
        }
        
        let tappedView = gesture.view! as! UIImageView
        switch tappedView.tag {
            case 41:
                tutName = "speed"
            case 42:
                tutName = "mode"
//            case 44:
//            case 45:
//            case 46:
//            case 47:
            case 48:
                break
            default:
                break
        }
        
        canPanMenu    = false
        tutMaxNum     = 1
        tutorialSlide = 0
        changeSlideTutorial()
    }
    
    func testTapped(gesture:UITapGestureRecognizer){
        
        if !checkCanTap(){
            return
        }
        
        if (isExpanded){
            return
        }
        
        let tappedView = gesture.view! as! UIImageView
        var segueName = "None"
        gameNum  = tappedView.tag
        gameName = typeNames[gameNum]
        
        
        switch gameNum {
            case 0:
                segueName = "menuToSingleGame"
            case 1:
                segueName = "menuToSingleGame"
            case 2:
                segueName = "menuToSingleGame"
            case 3:
                segueName = "menuToPhotoGame"

                let status:ALAuthorizationStatus = ALAssetsLibrary.authorizationStatus()
                
                switch (status) {
                    case ALAuthorizationStatus.Restricted, ALAuthorizationStatus.Denied:

                        let alert = UIAlertController(title: "Can't Access Photos", message: "Go to Settings -> MemoryGame to allow photo access", preferredStyle: UIAlertControllerStyle.Alert)
                        let alertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in }
                        alert.addAction(alertAction)
                        presentViewController(alert, animated: true) { () -> Void in }
                        
                        return
                    case ALAuthorizationStatus.NotDetermined:

                        let fetchOptions: PHFetchOptions = PHFetchOptions()
                        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate",ascending:true)]
                        PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options:fetchOptions)
                        return
                    default:
                        break;
                }
            case 4:
                segueName = "menuToMasterGame"
            default:
                break
        }
        
        if showQuestionMarks {
            
            let titleMsg  = "\(gameName.capitalizedString) Game!"
            let gameNameStr = (gameName == "place") ? "placement" : gameName
            var detailMsg = "Remember the order of the \(gameNameStr)s\n\n"
            
            if gameName == "master"{
                detailMsg = "Each screen will have a color, emoji and placement you have to remember\n\n"
            }
            
            detailMsg += "Your speed is set to \(getSpeedName())\n\n"
            detailMsg += "Your mode is set to \(getModeName()), which means "
            
            let gameNameToUse = gameName == "master" ? "screen" : gameName == "place" ? "placement" : gameName
            
            switch modeLevel {
                case 0:
                    detailMsg += "you will see all \(gameNameToUse)s in order"
                case 1:
                    detailMsg += "you are not shown previous \(gameNameToUse)s, only the newest one"
                case 2:
                    detailMsg += "the order changes on every level (this gets tough!)"
                default:
                    print("SNP")
            }
            
            let tutPreMessage = UIAlertController(title: titleMsg, message: detailMsg, preferredStyle: .Alert)
            let abortAction   = UIAlertAction(title: "Pass", style: .Default) { action -> Void in }
            let playAction    = UIAlertAction(title: "Let's Play", style: .Default) { action -> Void in
                self.performSegueWithIdentifier(segueName, sender: nil)
            }
            tutPreMessage.addAction(abortAction)
            tutPreMessage.addAction(playAction)
            
            self.presentViewController(tutPreMessage, animated: true, completion: nil)
            
        } else {
            self.performSegueWithIdentifier(segueName, sender: nil)
        }
        
    }
 
    func setSpeedImage(){
        var imageName = ""
        switch difficultyLevel {
            case 0:
                imageName = "slow"
            case 1:
                imageName = "med"
            case 2:
                imageName = "fast"
            default:
                difficultyLevel = 0
                imageName = "slow"
        }
        speedSettingLabel.image = UIImage(named: imageName)
    }
    
    func setModeImage(){
        var imageName = ""
        switch modeLevel {
            case 0:
                imageName = "stack"
            case 1:
                imageName = "single"
            case 2:
                imageName = "shuffle"
            default:
                modeLevel = 0
                imageName = "stack"
        }
        modeSettingLabel.image = UIImage(named: imageName)
    }
    
    /*
    func setSettingImages(imageViews:[UIImageView], imageName:NSString){
        var theImage:UIImage
        var frame:CGRect
        var cgImage:CGImageRef
        var xPos:CGFloat = 0
        var yPos:CGFloat = 0
        var tagNum:Int
        
        for imageView in imageViews{
            tagNum = imageView.tag
            yPos = ((tagNum == difficultyLevel && imageName == "SpeedBoard") || (tagNum == modeLevel && imageName == "ModeBoard")) ? 120 : 0
            switch tagNum {
                case 0:
                    xPos = 0
                case 1:
                    xPos = 235
                case 2:
                    xPos = 469
                default:
                    break
            }
            xPos = getPPIMultiplier(xPos)
            yPos = getPPIMultiplier(yPos)
            theImage = UIImage(named:imageName as String)!
            frame    = CGRectMake(xPos, yPos, getPPIMultiplier(235), getPPIMultiplier(120))
            cgImage  = CGImageCreateWithImageInRect(theImage.CGImage, frame)
            imageView.image = UIImage(CGImage: cgImage)
        }
    }
    */
    
    func resetMainAnimal(checkForAnimalUpdate:Bool){
        var levelSums:Int = 0
        var curLevel:Int

        for typeName in typeNames{
            curLevel = getLevel(typeName, levelNum: difficultyLevel, modeNum: modeLevel)
            levelSums += getAnimalLevel(curLevel, typeName: typeName, modeLevelNum: modeLevel, retNum:true).integerValue
        }
        
        let temp:Float = Float(levelSums) / Float(typeNames.count)
        var avgNum:Int
        
        if (temp >= 6){
            avgNum = 6
        }else{
            avgNum = min(5,Int(round(temp)))
        }
        
        let newAnimal:NSString = getAnimalLevel(avgNum, typeName: "master", modeLevelNum: 2)
        
        if (checkForAnimalUpdate && newAnimal != mainAnimalLabel.text){
            
            var imageName:String = "congrats_fish"
            
            switch newAnimal{
                case "🐠":
                    imageName = "congrats_fish"
                case "🐥":
                    imageName = "congrats_bird"
                case "🐩":
                    imageName = "congrats_dog"
                case "🐒":
                    imageName = "congrats_monkey"
                case "🐬":
                    imageName = "congrats_dolphin"
                case "🐘":
                    imageName = "congrats_elephant"
                default:
                    break
            }
            
            let image = UIImage(named: imageName)
            let imageView = UIImageView(image: image!)
            imageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            imageView.tag = 70
            view.addSubview(imageView)
            animalStatusChange(newAnimal)
            
        }else if !checkForAnimalUpdate {
            
            mainAnimalLabel.text = getMainAnimal(difficultyLevel, modeNum: modeLevel) as String
            let size:CGFloat = CGFloat(100 * mult)
            mainAnimalLabel.font = UIFont (name: "HelveticaNeue-UltraLight", size:size)
        }
    }
    
    func didTap(recognizer: UITapGestureRecognizer){
        changeSlideTutorial()
    }
    
    func changeSlideTutorial(){
        if tutorialSlide == -1{
            return
        }
        
        tutorialSlide++
        if tutorialSlide > tutMaxNum {
            tutorialSlide = -1
            canPanMenu = true
            self.view.viewWithTag(60)!.removeFromSuperview()
            return
        }else if tutorialSlide == 1{
            let imageName = "\(tutName)_\(tutorialSlide)"
            let image = UIImage(named: imageName)
            let imageView = UIImageView(image: image!)
            imageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            imageView.tag = 60
            self.view.addSubview(imageView)
        }else{
            let imageView = self.view.viewWithTag(60) as! UIImageView
            imageView.image = UIImage(named: "\(tutName)_\(tutorialSlide)")
        }
    }
    
    func animalStatusChange(newAnimal:NSString){
        self.tapMeImage.hidden = true
        setMainAnimal(difficultyLevel, modeNum: modeLevel, mainAnimal: newAnimal)
        UIView.transitionWithView(mainAnimalLabel, duration: 8.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {self.mainAnimalLabel.text = newAnimal as String}) { (Void) -> Void in
            self.view.viewWithTag(70)!.removeFromSuperview()
            self.tapMeImage.hidden = !showQuestionMarks
        }
    }
    
    func showRateMe() {
        let alert = UIAlertController(title: "Rate Us", message: "Thanks for using MemoryGame", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Rate MemoryGame", style: UIAlertActionStyle.Default, handler: { alertAction in
                NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "rateStatus")
                NSUserDefaults.standardUserDefaults().synchronize()
                UIApplication.sharedApplication().openURL(NSURL(string : "http://appsto.re/us/zooG8.i")!)
                alert.dismissViewControllerAnimated(true, completion: nil)
                self.rateNumber = 0
        }))
        alert.addAction(UIAlertAction(title: "No Thanks", style: UIAlertActionStyle.Default, handler: { alertAction in
            NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "rateStatus")
            NSUserDefaults.standardUserDefaults().synchronize()
            alert.dismissViewControllerAnimated(true, completion: nil)
            self.rateNumber = 0
        }))
        alert.addAction(UIAlertAction(title: "Maybe Later", style: UIAlertActionStyle.Default, handler: { alertAction in
            NSUserDefaults.standardUserDefaults().setInteger(self.rateNumber + 1, forKey: "rateStatus")
            NSUserDefaults.standardUserDefaults().synchronize()
            alert.dismissViewControllerAnimated(true, completion: nil)
            self.rateNumber = self.rateNumber + 1
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension menuViewController: OptionsViewControllerDelegate {
    func collapsePanel() {
        delegate?.collapseOptionsPanel?()
    }
    
    func toggleQuestMarkVisibility() {
        for qmark in questionMarkImages{
            qmark.hidden = !showQuestionMarks
        }
        self.turnOffTutImage.hidden = !showQuestionMarks
        self.tapMeImage.hidden = !showQuestionMarks
    }
}

