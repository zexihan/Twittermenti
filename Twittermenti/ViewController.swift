//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let sentimentClassifier = TweetSentimentClassifier()
    
    let swifter = Swifter(consumerKey: "LTReJyreyyuz4SWjVABuA1WKI", consumerSecret: "ajf107xfd6869heCG8Ptn8iztfFHBWPIxLkFGvsmoEwI7MKZcz")

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let prediction = try! sentimentClassifier.prediction(text: "@Apple is a terrible company!")
//
//        print(prediction.label)
        
        swifter.searchTweet(using: "@trump", lang: "en", count: 100, tweetMode: .extended, success: {(results, metadata) in
            
            var tweets = [TweetSentimentClassifierInput]()
            
            for i in 0..<100 {
                if let tweet = results[i]["full_text"].string {
                    let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                    tweets.append(tweetForClassification)
                }
            }
            
            do {
                let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
                
                var sentimentScore = 0
                
                for pred in predictions {
                    let sentiment = pred.label
                    
                    if sentiment == "Pos" {
                        sentimentScore += 1
                    } else if sentiment == "Neg" {
                        sentimentScore -= 1
                    }
                }
                print(sentimentScore)
            } catch {
                print("There was an error with making a prediction, \(error)")
            }
            
            
            
        }) { (error) in
            print("There was an error with the Twitter API request, \(error)")
        }
        
    }

    @IBAction func predictPressed(_ sender: Any) {
    
    
    }
    
}

