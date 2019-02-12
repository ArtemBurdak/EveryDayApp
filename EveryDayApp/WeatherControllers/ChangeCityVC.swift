//
//  ChangeCityVC.swift
//  EveryDayApp
//
//  Created by Artem on 2/12/19.
//  Copyright © 2019 Artem. All rights reserved.
//

import UIKit

protocol changeCityDelegate {
    func newCityName(city: String)
}

class ChangeCityVC: UIViewController {

    var delegate: changeCityDelegate?

//    var name: WeatherJson? = nil

    @IBOutlet weak var cityNameTxtField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    //    To Do: Alert with error, if entered unexisting city name

    @IBAction func changeCityNameBtn(_ sender: UIButton) {
        let cityName = cityNameTxtField.text!

//        if cityName == name?.name {
        delegate?.newCityName(city: cityName)
        self.dismiss(animated: true, completion: nil)
//        } else {
//            print("error")
//        }
    }
    @IBAction func cancelAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
