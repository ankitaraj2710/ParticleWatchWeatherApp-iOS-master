//
//  ViewController.swift
//  Meatballs
//
//  Created by MacStudent on 2019-10-16.
//  Copyright © 2019 MacStudent. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import WatchConnectivity
import Particle_SDK


class ViewController: UIViewController ,WCSessionDelegate{
    
    var username:String = "hemantpatel564@gmail.com"
    var password:String = "Hemant564"
    var id:String = "270018001047363333343437"
    var myPhoton : ParticleDevice?
    
    @IBOutlet weak var logLabel: UILabel!
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    //to display message on phone
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        let timezone:String = message["timezone"]! as! String
        let city:String = message["city"]! as! String
        
        print(timezone)
        print(city)
        selectedString = city
        selectedTimeZone = timezone
        DisplayTime()
        makeAPIRequest()
        print("Received a message from the watch: \(message)")
    }
    
    @IBOutlet weak var resultsLabel: UILabel!
    // var city : String!
    var selectedString: String = "Toronto"
    var selectedTimeZone: String = "america/toronto"
    // api for?????
    let api = "370c15870f7f073b897896b4de956ee5"
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    let suggestedResponses = ["Toronto", "London", "Kolkata","Tokyo","Auckland"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
        //to connect particle call particle function which are defined below
        ParticleCloud.init()
        loginInParticle()
        getDeviceFromCloud()
        logLabel.text = "Please select a city from watch"
    }
    
    // api request
    func makeAPIRequest(){
        logLabel.text = "Fetching weather data..."
        print("Making request with city name: \(self.selectedString)"); AF.request("https://api.openweathermap.org/data/2.5/weather?q=\(selectedString)&appid=\(api)").responseJSON
            
            {
                (result) in
                print(result.value)
                
                // convert the response to a JSON object
                
                let jsonResponse = JSON(result.value)
                let main = jsonResponse["name"]
                let description = jsonResponse["weather"]
                let temp = jsonResponse["main"]["temp"]
                let desc = description[0]["description"]
                
                let mainJSON = jsonResponse["main"]["temp"]
                self.cityLabel.text = "\(main)"
                self.infoLabel.text = "Weather: \(desc)"
                self.tempLabel.text = "Temp: \(temp) F"
                
                
                
        }
        DisplayTime()
    }
    
    func DisplayTime() {
        print("DisplayTime")
        
        print("https://worldtimeapi.org/api/timezone/\(selectedTimeZone)")
        
        
        AF.request("https://worldtimeapi.org/api/timezone/\(selectedTimeZone)").responseJSON
            {
                
                (time) in
                print(time)
                let x = JSON(time.value)
                let response = x["datetime"]
                let stringResponse : String = response.rawString()!
                print(stringResponse)
                let stringArray = stringResponse.components(separatedBy: "T")
                print(stringArray)
                let stringTimeArray = stringArray[1].components(separatedBy: ".")
                print(stringTimeArray)
                //Seperate the hour from time
                let timeHourArray:[String] = stringTimeArray[0].components(separatedBy: ":")
                print(timeHourArray)
                let timeHour = timeHourArray[0]
                print(timeHour)
                self.callParticleTimeFunction(hour: timeHour)
                
                self.timeLabel.text = ("Time: \(stringTimeArray[0])")
                self.dateLabel.text = ("Date: \(stringArray[0])")
        }
        
    }
    func loginInParticle(){
        // 2. Login to your account
        ParticleCloud.sharedInstance().login(withUser: self.username, password: self.password) { (error:Error?) -> Void in
            if (error != nil) {
                // Something went wrong!
                print("Wrong credentials or as! ParticleCompletionBlock no internet connectivity, please try again")
                // Print out more detailed information
                print(error?.localizedDescription)
            }
            else {
                print("Login success!")
            }
        }
    }
    func getDeviceFromCloud() {
        ParticleCloud.sharedInstance().getDevice(self.id) { (device:ParticleDevice?, error:Error?) in
            
            if (error != nil) {
                print("Could not get device")
                print(error?.localizedDescription)
                return
            }
            else {
                print("Got photon: \(device?.id)")
                self.myPhoton = device
            }
            
        } // end getDevice()
    }
    
    
    func callParticleTimeFunction(hour:String){
        logLabel.text = "Please check particle for time"
        let parameters = [hour]
        print("callParticleTimeFunction: \(hour)")
        var call = myPhoton!.callFunction("showHour", withArguments: parameters) {
            
            (resultCode : NSNumber?, error : Error?) -> Void in
            if (error == nil) {
                print("Sent message to Particle to turn green")
            }
            else {
                print("Error when telling Particle to turn green")
            }
        }
    }
}

