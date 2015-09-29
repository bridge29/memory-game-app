//
//  settings.swift
//  MemoryGame
//
//  Created by Scott Bridgman on 12/14/14.
//  Copyright (c) 2014 Tohism. All rights reserved.
//

import UIKit

///// GLOBAL SETTINGS & CONSTANTS
let BORDER_WIDTH:CGFloat = 10.0
let typeNames = ["color","emoji","place","photo","master"] // hack for setting and getting levels of these names dynamically in menuController
let allColors:[UIColor] = [UIColor.yellowColor(), UIColor.brownColor(), UIColor.blueColor(), UIColor.orangeColor(), UIColor.purpleColor(), UIColor.cyanColor(), UIColor.magentaColor(), UIColor.whiteColor(), UIColor.blackColor()]
let allEmojies = ["😃","😍","😡","😈","💩","👮","🙀","👹","👽","👍","👄","🎩","👠","👀","💍","🐶","🐼","🐸","🐌","🌴","🌛","🌍","⭐️","⛄️","⚡️","☔️","☀️","🎁","🎅","👻","🎃","🎄","🎉","📞","🔔","🔑","🔦","⏳","💣","🔫","🎨","🎵","🏈","🎱","🏁","⚽️","⚾️","🍕","🍟","🍔","🎲","🍓","🍒","🍭","✈️","⚓️","🚲","♠️","♥️","♣️","♦️","💲","🕓","💅","🐭","🐝","🔥","👼🏾","👂","👃","🍀","🐓","🐄","🐵","🐢","🍺","🍌","🎈","🎷","🎭","🎯","🎰","🎳","🚦","🏠","⛵️","🚀","💰","🌂","💎","🚿","🔒","♻️","♨️","🚪","⏰","📷","💃","🍦","🌻"]
var emojies:[NSString] = []
var colors:[UIColor]   = []
let places  = ["topleft","topright","botleft","botright"]
var pics:[UIImage] = []
var levelNum: Int = -1
var layouts: [[Int]] = []
var timer: NSTimer!
var waitTime = getDifficultySeconds(difficultyLevel)
var unwindToMenu = false
var gameName: String = "None"
var gameNum:Int = 0
var numOfPics:Int = -1
var newPr:Int = 0
var canPanMenu = true
var isExpanded = false
var tutorialSlide = -1
var tutName   = ""
var tutMaxNum = 0
var mult      = 1.0

var Timestamp: String {
    return "\(NSDate().timeIntervalSince1970 * 1000)"
}

enum SlideOutState {
    case collapsed
    case expanded
}

var maxLevel : Int {
    get {
        var returnValue: Int? = NSUserDefaults.standardUserDefaults().objectForKey("maxLevel") as? Int
        if returnValue == nil //Check for first run of app
        {
            returnValue = 0 //Default value
        }
        return returnValue!
    }
    set {
        NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "maxLevel")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}

var showQuestionMarks : Bool {
    get {
        var returnValue: Bool? = NSUserDefaults.standardUserDefaults().objectForKey("showQuestionMarks") as? Bool
        if returnValue == nil //Check for first run of app
        {
            returnValue = true
        }
        return returnValue!
    }
    set {
        NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "showQuestionMarks")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}

var difficultyLevel : Int {
    get {
        var returnValue: Int? = NSUserDefaults.standardUserDefaults().objectForKey("difficultyLevel") as? Int
        if returnValue == nil //Check for first run of app
        {
            returnValue = 0
        }
        return returnValue!
    }
    set {
        NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "difficultyLevel")
        NSUserDefaults.standardUserDefaults().synchronize()
        waitTime = getDifficultySeconds(newValue)
    }
}

func getModeName() -> String{
    switch modeLevel {
        case 0: return "Stack"
        case 1: return "Single"
        case 2: return "Shuffle"
        default: return "???"
    }
}

func getSpeedName() -> String{
    switch difficultyLevel {
        case 0: return "Slow"
        case 1: return "Medium"
        case 2: return "Fast"
        default: return "???"
    }
}

func getMainAnimal(levelNum: Int, modeNum: Int) -> NSString{
    var returnValue: NSString? = NSUserDefaults.standardUserDefaults().objectForKey("animal_\(levelNum)_\(modeNum)") as? NSString
    if returnValue == nil //Check for first run of app
    {
        returnValue = "🐛" //Default value
    }
    return returnValue!
}

func setMainAnimal(levelNum: Int, modeNum: Int, mainAnimal:NSString){
    NSUserDefaults.standardUserDefaults().setObject(mainAnimal, forKey: "animal_\(levelNum)_\(modeNum)")
    NSUserDefaults.standardUserDefaults().synchronize()
}

var modeLevel : Int {
get {
    var returnValue: Int? = NSUserDefaults.standardUserDefaults().objectForKey("modeLevel") as? Int
    if returnValue == nil
    {
        returnValue = 0
    }
    return returnValue!
}
set {
    NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "modeLevel")
    NSUserDefaults.standardUserDefaults().synchronize()
}
}

func getLevel(levelName: String, levelNum: Int, modeNum: Int) -> Int{
    var returnValue: Int? = NSUserDefaults.standardUserDefaults().objectForKey("\(levelName)_\(levelNum)_\(modeNum)") as? Int
    if returnValue == nil //Check for first run of app
    {
        returnValue = 0 //Default value
    }
    return returnValue!
}

func setLevel(levelName: String, levelNum: Int, modeNum: Int, newLevel:Int){
    if (newLevel > getLevel(levelName, levelNum: levelNum, modeNum: modeNum)){
        newPr = newLevel
        NSUserDefaults.standardUserDefaults().setObject(newLevel, forKey: "\(levelName)_\(levelNum)_\(modeNum)")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}

func getDifficultySeconds(diffLevel: Int) -> Double {
    return [2.5, 1.4, 0.7][diffLevel]
}

func randInRange(range: Range<Int>) -> Int {
    // arc4random_uniform(_: UInt32) returns UInt32, so it needs explicit type conversion to Int
    // note that the random number is unsigned so we don't have to worry that the modulo
    // operation can have a negative output
    return  Int(arc4random_uniform(UInt32(range.endIndex - range.startIndex))) + range.startIndex
}

func makeLayoutsFromScratch(){
    layouts = []
    var newLayout:[Int] = []
    var gameNums:[Int]  = []
    gameNums = (["master","photo"].contains(gameName)) ? [0,1,2] : [gameNum]
    
    mainLoop: while (true){
        newLayout = [randInRange(0...3),randInRange(0...3),randInRange(0...3)]
        for gameNumber in gameNums{
            if (layouts.count > 0){
                if (layouts[0][gameNumber] == newLayout[gameNumber]){
                    //println("BAD dobule: \(layouts) NEW: \(newLayout)")
                    continue mainLoop
                }
            }
            if (layouts.count > 2){
                if (layouts[0][gameNumber] == layouts[2][gameNumber] && layouts[1][gameNumber] == newLayout[gameNumber]){
                    //println("BAD alter: \(layouts) NEW: \(newLayout)")
                    continue mainLoop
                }
            }
        }
        if (layouts.count > 1 && gameNum == 3 && layouts[1] == newLayout){
            /// cannot jump back to an identical master car
            //println("BAD master duplicate: \(layouts) NEW: \(newLayout)")
            continue mainLoop
        }
        layouts.insert(newLayout, atIndex: 0)
        if (layouts.count > levelNum+1){
            break
        }
    }
    
    levelNum++
    if (levelNum > maxLevel) {
        //println("New Level reached: \(levelNum)")
        maxLevel = levelNum
    }
}

func appendCardLayouts(){
    var newLayout:[Int] = []
    var gameNums:[Int]  = []
    gameNums = (["master","photo"].contains(gameName)) ? [0,1,2] : [gameNum]

    mainLoop: while (true){
        newLayout = [randInRange(0...3),randInRange(0...3),randInRange(0...3)]
        for gameNumber in gameNums{
            if (layouts.count > 0){
                if (layouts[0][gameNumber] == newLayout[gameNumber]){
                    //println("BAD dobule: \(layouts) NEW: \(newLayout)")
                    continue mainLoop
                }
            }
            if (layouts.count > 2){
                if (layouts[0][gameNumber] == layouts[2][gameNumber] && layouts[1][gameNumber] == newLayout[gameNumber]){
                    //println("BAD alter: \(layouts) NEW: \(newLayout)")
                    continue mainLoop
                }
            }
        }
        if (layouts.count > 1 && gameNum == 3 && layouts[1] == newLayout){
            /// cannot jump back to an identical master car
            //println("BAD master duplicate: \(layouts) NEW: \(newLayout)")
            continue mainLoop
        }
        break
    }
    layouts.insert(newLayout, atIndex: 0)
    levelNum++
    if (levelNum > maxLevel) {
        //println("New Level reached: \(levelNum)")
        maxLevel = levelNum
    }
}

func shuffle() -> [Int]{
    let startArr: [Int] = [0,1,2,3]
    var shuffledArray: [Int] = []
    var newNum: Int
    while (shuffledArray.count < 4){
        newNum = randInRange(0...3)
        if (!shuffledArray.contains(newNum)){
            shuffledArray.append(newNum)
        }
        if (shuffledArray.count == 3) {
            for i in startArr {
                if (!shuffledArray.contains(i)){
                    shuffledArray.append(i)
                }
            }
        }
    }
    return shuffledArray
}

func setEmojies() -> [NSString]{
    var emojies:[NSString] = []
    let emojiCount = allEmojies.count - 1
    var emojiNum = 0
    
    while (emojies.count < 4){
        emojiNum = randInRange(0...emojiCount)
        if (!emojies.contains(allEmojies[emojiNum])){
            emojies.append(allEmojies[emojiNum])
        }
    }
    return emojies
}

func setColors() -> [UIColor]{
    var colors:[UIColor] = []
    let colorCount = allColors.count - 1
    var colorNum = 0
    
    while (colors.count < 4){
        colorNum = randInRange(0...colorCount)
        if (!colors.contains(allColors[colorNum])){
            colors.append(allColors[colorNum])
        }
    }
    return colors
}

func getAnimalLevel(levelNum:Int, typeName:NSString, modeLevelNum:Int, retNum:Bool=false) -> NSString{
    var threshs:[Int] = []
    if (typeName != "master"){
        switch modeLevelNum {
            case 0:
                threshs = [2,6,10,14,18,22]
            case 1:
                threshs = [2,5,8,11,14,17]
            case 2:
                threshs = [2,4,6,8,10,12]
            default:
                print("SNP", terminator: "")
                break
        }
    }else{
        switch modeLevelNum {
            case 0:
                threshs = [2,4,6,8,10,12]
            case 1:
                threshs = [1,2,4,6,8,10]
            case 2:
                threshs = [1,2,3,4,5,6]
            default:
                print("SNP", terminator: "")
                break
        }
    }
    //println("\(threshs) \(levelNum) \(modeLevelNum)")
    
    switch levelNum{
        case 0..<threshs[0]:
            return (retNum) ? "0" : "🐛"
        case threshs[0]..<threshs[1]:
            return (retNum) ? "1" : "🐠"
        case threshs[1]..<threshs[2]:
            return (retNum) ? "2" : "🐥"
        case threshs[2]..<threshs[3]:
            return (retNum) ? "3" : "🐩"
        case threshs[3]..<threshs[4]:
            return (retNum) ? "4" : "🐒"
        case threshs[4]..<threshs[5]:
            return (retNum) ? "5" : "🐬"
        default:
            return (retNum) ? "6" : "🐘"
    }
}

func getPPIMultiplier(num:CGFloat) -> CGFloat{
    if (DeviceType.IS_IPHONE_6P){
        return 1.5 * CGFloat(num)
    }else{
        return CGFloat(num)
    }
}


enum UIUserInterfaceIdiom : Int
{
    case Unspecified
    case Phone
    case Pad
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.mainScreen().bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.mainScreen().bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.currentDevice().userInterfaceIdiom == .Pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}
