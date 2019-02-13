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

class WeatherVC: UIViewController, CLLocationManagerDelegate, changeCityDelegate {

    @IBOutlet weak var backgroundWeather: UIImageView!
    @IBOutlet weak var weatherConditionLbl: UILabel!
    @IBOutlet weak var tmpLbl: UILabel!
    @IBOutlet weak var cityLabel: UILabel!

    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "185207b6e5f17e147d1a452b2faecae0"

    let locationManager = CLLocationManager()

    var weatherJson: WeatherJson?

    override func viewDidLoad() {
        super.viewDidLoad()

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

            let parameters: [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
//            print(parameters)

            getWeatherData(url: WEATHER_URL, parameters : parameters)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location error"
    }

    func getWeatherData(url: String, parameters: [String : String]) {
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON {
            response in
            guard let data = response.data else {
                self.showError()
                return
            }
            self.parce(json: data)
        }
    }
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "Probem with loading", preferredStyle: .alert)
        ac.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (_) in
        }))
        self.present(ac, animated: true)
        cityLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
    }

    func parce(json: Data) {
        let decoder = JSONDecoder()

        if let weaterData = try? decoder.decode(WeatherJson.self, from: json) {
            weatherJson = weaterData
            print(weatherJson as Any)

//            DispatchQueue.main.async { Deside if I need this line

                guard let imageName = self.weatherJson?.weather.first?.icon else { return }
                self.backgroundWeather.image = UIImage.init(named: imageName)
            cityLabel.text = self.weatherJson?.name
            weatherConditionLbl.text = self.weatherJson?.weather.first?.description
            guard let tempResult = self.weatherJson?.main.temp else { return }
            tmpLbl.text = "\(Int(tempResult - 273.15)) °C"

        }
    }

    func newCityName(data: Data) {
        parce(json: data)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCity" {
            let destinationVC = segue.destination as! ChangeCityVC
            destinationVC.delegate = self
        }
    }
}
