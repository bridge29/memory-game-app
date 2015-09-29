//
//  RankingViewController.swift
//  MemoryGame
//
//  Created by Scott Bridgman on 8/28/15.
//  Copyright (c) 2015 Tohism. All rights reserved.
//

import UIKit

class RankingViewController: UIViewController {

    @IBOutlet var tableRankLabels: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false
        
        for tableRankLabel in tableRankLabels {
            
            //let tableRankGest = UITapGestureRecognizer(target: self, action: "tableRankTapped:")
            //tableRankGest.numberOfTapsRequired = 1
            //tableRankLabel.addGestureRecognizer(tableRankGest)
            
            let tag = tableRankLabel.tag
            let speedLevel = tag % 10
            
            var mode:Int
            if tag < 20 {
                mode = 0
            } else if tag < 30 {
                mode = 1
            } else {
                mode = 2
            }
            
            tableRankLabel.text = getMainAnimal(speedLevel, modeNum: mode) as String
            let size:CGFloat = CGFloat(40*mult)
            tableRankLabel.font = UIFont (name: "HelveticaNeue-UltraLight", size:size)
            //println("mode: \(mode), tag: \(tag)")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
