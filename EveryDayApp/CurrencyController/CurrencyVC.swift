//
//  CurrencyVC.swift
//  EveryDayApp
//
//  Created by Artem on 2/2/19.
//  Copyright © 2019 Artem. All rights reserved.
//

import UIKit

struct Currency: Codable {
    let success: Bool
    let terms: String
    let privacy: String
    let sourse = "USD"
    let quotes: QuotesCurrency
}

struct QuotesCurrency: Codable {
    var USDUAH: Double
    var USDEUR: Double
    var USDRUB: Double
}

class CurrencyVC: UIViewController {

    @IBOutlet weak var uahLabel: UILabel!
    @IBOutlet weak var eurLabel: UILabel!
    @IBOutlet weak var rubLabel: UILabel!
    @IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var multiplierBtn: UIButton!
    @IBOutlet weak var updateLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var updateBtnConstraint: NSLayoutConstraint!

    var tabBarHeigh: CGFloat?
    var currency: Currency?

    var multiplierUSD: Double = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        changeConstraints()

        if let data = UserDefaults.standard.value(forKey: Constants.storedCurrencyKey) as? Data {
            if let tempCurrency = try? PropertyListDecoder().decode(Currency.self, from: data) {
                currency = tempCurrency
                self.updateUI(curency: currency!)
            }
        }

        multiplierBtn.setTitle("x \(abs(Int(multiplierUSD))) $", for: .normal)

        getJSONData(urlString: Constants.apiUrl)
    }

    func getJSONData(urlString: String) {

        DispatchQueue.global(qos :.background).async {

            //urlString converting to URL
            guard let url: URL = URL(string: urlString) else {return}

            //Using created URL
            if let data = try? Data(contentsOf: url) {
                self.parce(json: data)
                return
            } else {
                self.showError()
            }
        }
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "Probem whith loading", preferredStyle: .alert)
        ac.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (_) in
            self.updateLabel.text = "Loading error"
            self.updateLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        }))
        present(ac, animated: true)
    }

    func parce(json: Data) {
        let decoder = JSONDecoder()

        if let jsonValues = try? decoder.decode(Currency.self, from: json) {
            currency = jsonValues

            self.updateUI(curency: currency!)

            DispatchQueue.main.async {
                //updatedTime
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
                let result = formatter.string(from: date)
                self.updateLabel.text = "Updated " + result
                self.updateLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
    }

    func updateUI(curency: Currency) {

        DispatchQueue.main.async {

            let usdUsd = abs(self.multiplierUSD * (self.currency?.quotes.USDUAH ?? 0))
            let usdEur = abs(self.multiplierUSD * (self.currency?.quotes.USDEUR ?? 0))
            let usdRub = abs(self.multiplierUSD * (self.currency?.quotes.USDRUB ?? 0))

            self.uahLabel.text = String(format: "%.2f", usdUsd)
            self.eurLabel.text = String(format: "%.2f", usdEur)
            self.rubLabel.text = String(format: "%.2f", usdRub)

            UIView.animate(withDuration: 1) {
                self.uahLabel.alpha = 1
                self.eurLabel.alpha = 1
                self.rubLabel.alpha = 1
            }

            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.currency), forKey: Constants.storedCurrencyKey)
        }
    }

    @IBAction func termsBtn(_ sender: Any) {
        guard let terms = currency?.terms else { return }
        openUrl(url: terms)
    }

    @IBAction func privacyBtn(_ sender: UIButton) {
        guard let privacy = currency?.privacy else { return }
        openUrl(url: privacy)
    }

    func openUrl(url: String) {
        guard let url = URL(string: url) else { return }
        UIApplication.shared.open(url)
    }

    @IBAction func refreshAction(_ sender: UIButton) {
        updateLabel.text = "Updating..."
        updateLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        getJSONData(urlString: Constants.apiUrl)
    }

    @IBAction func updateMultiplayerAction(_ sender: UIButton) {
        setMultiply()
    }

    func setMultiply(){
        let alert = UIAlertController(title: "Set multiplier", message: "Enter your ammount of $", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "1 $"
            textField.keyboardType = UIKeyboardType.decimalPad
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            self.multiplierUSD = Double(textField!.text ?? "1.0") ?? 1
            self.multiplierBtn.setTitle("x \(abs(Int(self.multiplierUSD))) $", for: .normal)
            self.getJSONData(urlString: Constants.apiUrl)
        }))

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel))

        self.present(alert, animated: true, completion: nil)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func changeConstraints() {
        updateLabelConstraint.constant = (tabBarHeigh ?? 0) + 8
        updateBtnConstraint.constant = (tabBarHeigh ?? 0) + 8
        view.layoutIfNeeded()
    }
}
