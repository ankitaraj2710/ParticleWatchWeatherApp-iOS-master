//
//  InterfaceController.swift
//  Meatballs WatchKit Extension
//
//  Created by Shikhar Shah on 2019-11-02.
//  Copyright © 2019 Lambton. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController,WCSessionDelegate{
    
    
    @IBOutlet weak var cityLabel: WKInterfaceLabel!
    @IBOutlet weak var TimeLabel: WKInterfaceLabel!
    @IBOutlet weak var tempLabel: WKInterfaceLabel!
    @IBOutlet weak var descLabel: WKInterfaceLabel!
    
    @IBOutlet weak var dateLabel: WKInterfaceLabel!
    
    let suggestedResponses = ["Toronto", "London", "Kolkata","Tokyo","Auckland"]
    var selectedString: String = "Toronto"
    var selectedTimeZone: String = "america/toronto"
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    @IBAction func SelectCityPressed() {
        
        // 1. When person clicks on button, show them the input UI
        presentTextInputController(withSuggestions: suggestedResponses, allowedInputMode: .plain) {
            
            (results) in
            
            if (results != nil && results!.count > 0) {
                print("Inside User Selected")
                let userResponse = results?.first as? String
                
                self.cityLabel.setText(userResponse!)
                print("User selected: \(userResponse!)")
                self.selectedString = "\(userResponse!)"
                if(userResponse! == "Toronto"){
                    self.selectedTimeZone = "america/toronto"
                }
                else
                    if(userResponse! == "London"){
                        self.selectedTimeZone = "europe/london"
                    }
                    else
                        if(userResponse! == "Kolkata"){
                            self.selectedTimeZone = "asia/kolkata"
                        }
                        else
                            if(userResponse! == "Tokyo"){
                                self.selectedTimeZone = "asia/tokyo"
                            }
                            else
                                if(userResponse! == "Auckland"){
                                    self.selectedTimeZone = "pacific/auckland"
                }
                
                //      self.makeAPIRequest()
                self.sendMessage()
                
            }
        }
        
    }
    func sendMessage(){
        WCSession.default.sendMessage(
            ["city" :self.selectedString,"timezone": self.selectedTimeZone ],
            replyHandler: {
                (_ replyMessage: [String: Any]) in
                // @TODO: Put some stuff in here to handle any responses from the PHONE
                print("Message sent, put something here if u are expecting a reply from the phone")
                // self.messageLabel.setText("Got reply from phone")
        }, errorHandler: { (error) in
            //@TODO: What do if you get an error
            print("Error while sending message: \(error)")
            // self.messageLabel.setText("Error sending message")
        })
    }
}
