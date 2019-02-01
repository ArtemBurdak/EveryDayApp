//
//  ViewController.swift
//  EveryDayApp
//
//  Created by Artem on 1/27/19.
//  Copyright © 2019 Artem. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherVC: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var cityLabel: UILabel!
    

    let weatherApiUrl = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "185207b6e5f17e147d1a452b2faecae0"

    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let weatherUrl = URL(string: weatherApiUrl) else { return }

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 { //if horizontallAcuracy is below 0, data is wrong
            locationManager.stopUpdatingLocation() //stops udating when got result

            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)

            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]

//            getWeatherData(url: WEATHER_URL, parameters : params)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Cannot find your location"
    }

    @IBAction func chngeCityBtn(_ sender: UIButton) {
    }

    func getWeatherData(url: String, parameters: [String : String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Got the weather")

                let weatherJSON : JSON = JSON(response.result.value!)
                print(weatherJSON)

            } else {
                print("Error \(response.result.error)")
                self.cityLabel.text = "Faild to connect"
            }
        }
    }
    
}

