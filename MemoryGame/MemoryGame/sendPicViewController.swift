//
//  sendPicViewController.swift
//  MemoryGame
//
//  Created by Scott Bridgman on 7/24/15.
//  Copyright (c) 2015 Tohism. All rights reserved.
//

import UIKit
import MessageUI

class sendPicViewController: UIViewController, UIScrollViewDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {

    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var scrollView: UIScrollView!
    var containerView: UIView!
    var shouldSendList = [false,false,false,false,false]
    var throwbackPic:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        self.view.backgroundColor = UIColor.lightGrayColor()
        
        let textButton:UIBarButtonItem = UIBarButtonItem(title: "Text", style: UIBarButtonItemStyle.Plain, target: self, action: "sendText")
        let emailButton:UIBarButtonItem = UIBarButtonItem(title: "Email", style: UIBarButtonItemStyle.Plain, target: self, action: "sendEmail")
        
        self.navItem.setRightBarButtonItems([emailButton, textButton], animated: false)
        
        //// CREATE THROWBACK PIC
        let image1:UIImage = pics[0]
        let image2:UIImage = pics[1]
        let image3:UIImage = pics[2]
        let image4:UIImage = pics[3]
        let banner:UIImage = UIImage(named: "mgThrowbackTop")!
        let fullWidth:CGFloat    =  960
        let fullHeight:CGFloat   = 1280
        let halfWidth:CGFloat    =  480
        let halfHeight:CGFloat   =  640
        let bannerHeight:CGFloat =  200
        
        UIGraphicsBeginImageContext(CGSize(width: fullWidth, height: fullHeight + bannerHeight))
        banner.drawInRect(CGRectMake(        0,               0, fullWidth, bannerHeight))
        image1.drawInRect(CGRectMake(        0,             bannerHeight, halfWidth, halfHeight))
        image2.drawInRect(CGRectMake(halfWidth,             bannerHeight, halfWidth, halfHeight))
        image3.drawInRect(CGRectMake(        0,halfHeight + bannerHeight, halfWidth, halfHeight))
        image4.drawInRect(CGRectMake(halfWidth,halfHeight + bannerHeight, halfWidth, halfHeight))
        
        let hlw:CGFloat = 10
        let context:CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetStrokeColorWithColor(context, UIColor(red: 64.0/255, green: 143.0/255, blue: 226.0/255, alpha: 1.0).CGColor)
        
        //// Left Line
        CGContextSetLineWidth(context, 20)
        CGContextMoveToPoint(context, hlw, bannerHeight)
        CGContextAddLineToPoint(context, hlw, fullHeight + bannerHeight - hlw)
        CGContextDrawPath(context, CGPathDrawingMode.Stroke)
        
        //// Middle line
        CGContextMoveToPoint(context, halfWidth, bannerHeight)
        CGContextAddLineToPoint(context, halfWidth, fullHeight + bannerHeight - hlw)
        CGContextDrawPath(context, CGPathDrawingMode.Stroke)
        
        //// Bottom Line
        CGContextMoveToPoint(context, 0, fullHeight + bannerHeight - hlw)
        CGContextAddLineToPoint(context, fullWidth, fullHeight + bannerHeight - hlw)
        CGContextDrawPath(context, CGPathDrawingMode.Stroke)
        
        //// Right Line
        CGContextMoveToPoint(context, fullWidth - hlw, bannerHeight)
        CGContextAddLineToPoint(context, fullWidth - hlw, fullHeight + bannerHeight - hlw)
        CGContextDrawPath(context, CGPathDrawingMode.Stroke)
        
        //// Cross Line
        CGContextMoveToPoint(context, hlw, halfHeight + bannerHeight)
        CGContextAddLineToPoint(context, fullWidth, halfHeight + bannerHeight)
        CGContextDrawPath(context, CGPathDrawingMode.Stroke)
        
        self.throwbackPic = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //// SET UP CONTAINER VIEW WITH SCROLL VIEW AND IMAGE VIEWS
        let heightValue = self.view.bounds.width * CGFloat(4.0/3.0) - 120
        let containerSize = CGSize(width: self.view.bounds.width , height: heightValue * CGFloat(5.2))
        containerView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size:containerSize))
        scrollView.addSubview(containerView)
        
        for (idx,pic) in ([self.throwbackPic] + pics).enumerate(){
            
            let imageView = UIImageView(image: pic)
            imageView.frame = CGRect(x: 45, y: CGFloat(idx) * heightValue, width: self.view.bounds.width - 90, height: heightValue)
            imageView.tag = 11 + idx
            let tapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didTap:")
            tapGestureRecognizer.numberOfTapsRequired = 1
            imageView.userInteractionEnabled = true
            imageView.addGestureRecognizer(tapGestureRecognizer)
            imageView.layer.borderWidth = 6.0
            imageView.layer.borderColor = UIColor.grayColor().CGColor
            containerView.addSubview(imageView)
        }
        
        scrollView.contentSize = containerSize;
        
        // Set up the minimum & maximum zoom scales
        //let scrollViewFrame = scrollView.frame
        //let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        //let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        //let minScale = min(scaleWidth, scaleHeight)
        
        //scrollView.minimumZoomScale = minScale
        //scrollView.maximumZoomScale = 1.0
        //scrollView.zoomScale = 1.0
    }
    
    func didTap(recognizer: UITapGestureRecognizer){

        let tappedView = recognizer.view as! UIImageView
        let idx = tappedView.tag - 11
        
        shouldSendList[idx] = !shouldSendList[idx]
        
        if shouldSendList[idx] {
            tappedView.layer.borderColor = UIColor.greenColor().CGColor
        }else{
            tappedView.layer.borderColor = UIColor.grayColor().CGColor
        }
        
    }
    
    @IBAction func cancelSendPic(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        switch (result.rawValue){
            case MFMailComposeResultCancelled.rawValue:
                self.dismissViewControllerAnimated(true, completion: nil)
            case MFMailComposeResultFailed.rawValue:
                self.dismissViewControllerAnimated(true, completion: { action -> Void in
                    let actionSheetController: UIAlertController = UIAlertController(title: "Uh Oh", message: "Something went wrong and email did not send", preferredStyle: .Alert)
                    let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .Default) { action -> Void in
                    }
                    actionSheetController.addAction(okAction)
                    self.presentViewController(actionSheetController, animated: true, completion: nil)
                })
            case MFMailComposeResultSent.rawValue:
                self.dismissViewControllerAnimated(true, completion: { action -> Void in
                    self.backToMenu()
                })
            default:
                self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func sendEmail() {
        let body = "\n\n\nMemoryGame is a fun way to test your memory and keep your mind sharp. Give it a try, it's free!\nhttp://appsto.re/us/zooG8.i"
        let picker = MFMailComposeViewController()
        picker.mailComposeDelegate = self
        
        
        var numSelected = 0
        for tag in 11...15 {
            let imageView = self.view.viewWithTag(tag) as! UIImageView
            if shouldSendList[tag - 11] {
                numSelected++
                picker.addAttachmentData(UIImageJPEGRepresentation(imageView.image!, 1)!, mimeType: "image/jpg", fileName: "MGTB_"+String(numSelected)+".jpg")
            }
        }
        
        let picWord = numSelected == 1 ? "Pic!" : "Pics!"
        picker.setSubject("Memory Game Throwback " + picWord)
        picker.setMessageBody(body, isHTML: false)
        
        if numSelected > 0 {
            presentViewController(picker, animated: true, completion: nil)
        } else {
            let actionSheetController: UIAlertController = UIAlertController(title: "No Photos Selected", message: "Tap the photos you would like to send to a friend.", preferredStyle: .Alert)
            let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .Default) { action -> Void in
            }
            actionSheetController.addAction(okAction)
            self.presentViewController(actionSheetController, animated: true, completion: nil)
        }
    }

    func sendText(){
        
        var someSelected = false
        var numSelected  = 0
        let messageVC    = MFMessageComposeViewController()
        messageVC.messageComposeDelegate = self
        
        for tag in 11...15 {
            let imageView = self.view.viewWithTag(tag) as! UIImageView
            if shouldSendList[tag - 11] {
                someSelected = true
                numSelected++
                messageVC.addAttachmentData(UIImageJPEGRepresentation(imageView.image!, 1)!, typeIdentifier: "image/jpg", filename: "MGTB_"+String(numSelected)+".jpg")
            }
        }
        
        let picWord = numSelected == 1 ? "Pic!" : "Pics!"
        messageVC.body = "MemoryGame Throwback " + picWord + "\n"
        
        if someSelected && MFMessageComposeViewController.canSendText() &&  MFMessageComposeViewController.canSendAttachments(){
            self.presentViewController(messageVC, animated: false, completion: nil)
        } else if !someSelected{
            let actionSheetController: UIAlertController = UIAlertController(title: "No Photos Selected", message: "Tap the photos you would like to send to a friend.", preferredStyle: .Alert)
            let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .Default) { action -> Void in
            }
            actionSheetController.addAction(okAction)
            self.presentViewController(actionSheetController, animated: true, completion: nil)
        } else {
            let actionSheetController: UIAlertController = UIAlertController(title: "Can't Send Texts", message: "Sorry, your phone is not configured to send photos via SMS text.", preferredStyle: .Alert)
            let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .Default) { action -> Void in
            }
            actionSheetController.addAction(okAction)
            self.presentViewController(actionSheetController, animated: true, completion: nil)
        }
    }

    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        
        switch (result.rawValue) {
        case MessageComposeResultCancelled.rawValue:
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        case MessageComposeResultFailed.rawValue:
            
            self.dismissViewControllerAnimated(true, completion: { action -> Void in
                let actionSheetController: UIAlertController = UIAlertController(title: "Uh Oh", message: "Something went wrong and message did not send", preferredStyle: .Alert)
                let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .Default) { action -> Void in
                }
                actionSheetController.addAction(okAction)
                self.presentViewController(actionSheetController, animated: true, completion: nil)
            })
            
            
        case MessageComposeResultSent.rawValue:
            
            self.dismissViewControllerAnimated(true, completion: { action -> Void in
                self.backToMenu()
            })
            
        default:
            
            print("SNP", terminator: "")
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
    }
    
    func backToMenu() {
        unwindToMenu = true
        self.navigationController?.popViewControllerAnimated(false)

    }
}
