//
//  ViewController.swift
//  EveryDayApp
//
//  Created by Artem on 1/27/19.
//  Copyright © 2019 Artem. All rights reserved.
//

import UIKit
import Alamofire
import GooglePlaces

class WeatherVC: UIViewController {

    @IBOutlet private weak var imageWeatherStatus: UIImageView!
    @IBOutlet private weak var weatherConditionLbl: UILabel!
    @IBOutlet private weak var tmpLbl: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var backgroundDayTimeImage: UIImageView!

    let locationManager = CLLocationManager()

    var weatherJson: WeatherJson?

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func getWeatherData(url: String,
                        parameters: [String : String]) {
        Alamofire.request(url, method: .get,
                          parameters: parameters).validate().responseJSON {
            response in
            guard
                let data = response.data
                else { self.showError(); return }
            self.parce(json: data)
        }
    }

    func parce(json: Data) { // ->
        let decoder = JSONDecoder()

        if let weaterData = try? decoder.decode(WeatherJson.self, from: json) {
            weatherJson = weaterData
            print(weatherJson as Any)

            DispatchQueue.main.async {

                guard let imageName = self.weatherJson?.weather.first?.icon else { return }
                self.imageWeatherStatus.image = UIImage.init(named: imageName)

                if imageName.contains("n") {
                    self.backgroundDayTimeImage.image = UIImage.init(named: "night")
                } else {
                    self.backgroundDayTimeImage.image = UIImage.init(named: "Day")
                }
//                self.cityLabel.text = self.weatherJson?.name
                self.weatherConditionLbl.text = self.weatherJson?.weather.first?.description

                guard let tempResult = self.weatherJson?.main.temp else { return }
                self.tmpLbl.text = "\(Int(tempResult - 273.15)) °C"
            }
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

extension WeatherVC: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()

            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)

            let parameters: [String : String] = ["lat" : latitude,
                                                 "lon" : longitude,
                                                 "appid" : Constants.weatherKey]

            getWeatherData(url: Constants.weatherUrl, parameters : parameters)
        }
    }

    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location error"
    }
}

extension WeatherVC: ChangeCityDelegate {

}

// MARK: - Private funcs -
private extension WeatherVC {
    func showError() {
        let ac = UIAlertController(title: "Loading error",
                                   message: "Probem with loading",
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction.init(title: "OK",
                                        style: .default, handler: { (_) in }))
        self.present(ac, animated: true)
        cityLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
    }
}
