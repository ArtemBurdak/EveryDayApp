//
//  ChangeCityVC.swift
//  EveryDayApp
//
//  Created by Artem on 2/12/19.
//  Copyright © 2019 Artem. All rights reserved.
//

import UIKit
import Alamofire

protocol changeCityDelegate {
    func newCityName(data: Data)
}

class ChangeCityVC: UIViewController {

    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "185207b6e5f17e147d1a452b2faecae0"

    var weatherJson: WeatherJson?

    var delegate: changeCityDelegate?

    @IBOutlet weak var cityNameTxtField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    //    To Do: Alert with error, if entered unexisting city name

    @IBAction func changeCityNameBtn(_ sender: UIButton) {
        let cityName = cityNameTxtField.text!

        let parameters: [String: String] = ["q": cityName, "appid": APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: parameters)
    }

    @IBAction func cancelAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    func getWeatherData(url: String, parameters: [String : String]) {
        Alamofire.request(url, method: .get, parameters: parameters).validate().responseJSON {
            response in

            guard let data = response.data else {
                print("error")
                return
            }

            switch response.result {
            case .success:
                self.delegate?.newCityName(data: data)
                self.dismiss(animated: true, completion: nil)

            case .failure:
                self.showError()
            }
        }
    }

    func showError() {
        let ac = UIAlertController(title: "Wrong city name", message: "Please, try another city name", preferredStyle: .alert)
        ac.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (_) in
        }))
        self.present(ac, animated: true)
    }
}
