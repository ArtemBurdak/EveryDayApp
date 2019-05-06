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
    @IBOutlet weak var cityLabel: UILabel!
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

                self.changeUI()

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

// MARK: - Private funcs -
private extension WeatherVC {
    func showError() {
        let ac = UIAlertController(title: "Loading error",
                                   message: "Probem with loading",
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction.init(title: "OK",
                                        style: .default, handler: { (_) in }))
        self.present(ac, animated: true)
        cityLabel.textColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
    }

    func changeUI() {
        guard let imageName = self.weatherJson?.weather.first?.icon else { return }
        self.imageWeatherStatus.image = UIImage.init(named: imageName)
        if imageName.contains("n") {
            self.backgroundDayTimeImage.image = UIImage.init(named: "night")
            tmpLbl.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            cityLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            weatherConditionLbl.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        } else {
            self.backgroundDayTimeImage.image = UIImage.init(named: "Day")
            tmpLbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            cityLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            weatherConditionLbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
    }
}
