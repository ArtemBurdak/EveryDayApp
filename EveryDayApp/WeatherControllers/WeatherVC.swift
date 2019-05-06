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

class WeatherVC: UIViewController, GMSAutocompleteViewControllerDelegate {

    @IBOutlet private weak var imageWeatherStatus: UIImageView!
    @IBOutlet private weak var weatherConditionLbl: UILabel!
    @IBOutlet private weak var tmpLbl: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var backgroundDayTimeImage: UIImageView!
    @IBOutlet weak var changeCityTextField: UITextField!

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
                self.cityLabel.text = self.weatherJson?.name
                self.weatherConditionLbl.text = self.weatherJson?.weather.first?.description

                guard let tempResult = self.weatherJson?.main.temp else { return }
                self.tmpLbl.text = "\(Int(tempResult - 273.15)) °C"
            }
        }
    }

    @IBAction func typeCityNameAction(_ sender: UITextField) {
        changeCityTextField.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
}

extension WeatherVC: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {

            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)

            let parameters: [String: String] = ["lat" : latitude,
                                                "lon" : longitude,
                                                "appid" : Constants.weatherKey]

            getWeatherData(url: Constants.weatherUrl, parameters : parameters)

            locationManager.stopUpdatingLocation()
        }
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        changeCityTextField.text = place.name
        dismiss(animated: true, completion: nil)
        cityLabel.text = changeCityTextField.text

        if cityLabel.text?.isEmpty == false {

            let parameters: [String: String] = ["lat" : String(place.coordinate.latitude),
                                                "lon" : String(place.coordinate.longitude),
                                                "appid" : Constants.weatherKey]

            getWeatherData(url: Constants.weatherUrl, parameters : parameters)
        }
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }

    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location error"
    }
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
