//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController , CLLocationManagerDelegate , changeCityDelegate{
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    

    //TODO: Declare instance variables here
    let LocationManger = CLLocationManager()
    let weatherModel = WeatherDataModel();
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
        LocationManger.delegate = self
        LocationManger.desiredAccuracy = kCLLocationAccuracyHundredMeters
        LocationManger.requestWhenInUseAuthorization()
        LocationManger.startUpdatingLocation()
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getWeatherData(url : String , paramters:[String:String]){
        Alamofire.request(url, method: .get, parameters: paramters).responseJSON { (response) in
            if response.result.isSuccess {
                
                print("Success! Got the weather data")
                
                self.LocationManger.stopUpdatingLocation()
                
                let weatherjson : JSON = JSON(response.result.value!)
                
                print(weatherjson)
                
               self.updateweatherData(jasonFile: weatherjson)
                
            }
            else{
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
        }
        
    }
    
    

    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    func updateweatherData(jasonFile : JSON) {
        
        let temp : Double = jasonFile["main"]["temp"].doubleValue
        if(temp > 0)
        {
            weatherModel.tempermature = Int(temp - 273.15)
            
            weatherModel.city = jasonFile["name"].stringValue
            
            weatherModel.condition = jasonFile["weather"][0]["id"].intValue
            
            weatherModel.iconName = weatherModel.updateWeatherIcon(condition: weatherModel.condition)
            
            updateUiWithWeatherData()
        }
        else
        {
           cityLabel.text = "Error City"
           temperatureLabel.text = "_"
        }
    }

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    func updateUiWithWeatherData() {
        cityLabel.text = weatherModel.city
        temperatureLabel.text = "\(weatherModel.tempermature)º"
        weatherIcon.image = UIImage(named: weatherModel.iconName)
    }
    
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy < 0{
            LocationManger.stopUpdatingLocation()
            
        }
        let lonitude = String(location.coordinate.longitude)
        let latitude = String(location.coordinate.latitude)
        let parm : [String:String] =  ["lat":latitude , "lon":lonitude ,"appid":APP_ID]
        getWeatherData(url: WEATHER_URL, paramters: parm)
        
    }
    
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "location unavaliabal"
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    func userEnterCityName(city: String) {
        let parm : [String:String] = ["q":city , "appid":APP_ID]
        getWeatherData(url: WEATHER_URL, paramters: parm)
        
    }

    
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName"{
            
            let destionvc = segue.destination as! ChangeCityViewController
            
            destionvc.delegate = self
        }
    }
    
    
    
    
}


