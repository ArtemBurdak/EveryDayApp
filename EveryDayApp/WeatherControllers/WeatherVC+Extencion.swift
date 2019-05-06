//
//  WeatherVC+Extencion.swift
//  EveryDayApp
//
//  Created by Artem on 5/6/19.
//  Copyright © 2019 Artem. All rights reserved.
//

import GooglePlaces

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
