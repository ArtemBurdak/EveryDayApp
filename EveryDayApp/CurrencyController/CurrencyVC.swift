//
//  CurrencyVC.swift
//  EveryDayApp
//
//  Created by Artem on 2/2/19.
//  Copyright © 2019 Artem. All rights reserved.
//

import UIKit

private let defaultAlpha: CGFloat = 1.0

class CurrencyVC: UIViewController {

    @IBOutlet private weak var uahLabel: UILabel!
    @IBOutlet private weak var eurLabel: UILabel!
    @IBOutlet private weak var rubLabel: UILabel!
    @IBOutlet private weak var updateLabel: UILabel!
    @IBOutlet private weak var multiplierBtn: UIButton!
    @IBOutlet private weak var updateLabelConstraint: NSLayoutConstraint!
    @IBOutlet private weak var updateBtnConstraint: NSLayoutConstraint!

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

            guard let url: URL = URL(string: urlString) else {return}

            if let data = try? Data(contentsOf: url) {
                self.parce(data: data)
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
        self.present(ac, animated: true)
    }

    func parce(data: Data) {
        let decoder = JSONDecoder()

        if let jsonValues = try? decoder.decode(Currency.self, from: data) {
            self.currency = jsonValues
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.currency), forKey: Constants.storedCurrencyKey)

            self.updateUI(curency: jsonValues)

            DispatchQueue.main.async {
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
        let usdUsd = abs(self.multiplierUSD * (self.currency?.quotes.USDUAH ?? .zero))
        let usdEur = abs(self.multiplierUSD * (self.currency?.quotes.USDEUR ?? .zero))
        let usdRub = abs(self.multiplierUSD * (self.currency?.quotes.USDRUB ?? .zero))

        let strUsd = String(format: "%.2f", usdUsd)
        let strEur = String(format: "%.2f", usdEur)
        let strRub = String(format: "%.2f", usdRub)

        DispatchQueue.main.async {
            self.uahLabel.text = strUsd
            self.eurLabel.text = strEur
            self.rubLabel.text = strRub

            UIView.animate(withDuration: 1) {
                self.uahLabel.alpha = defaultAlpha
                self.eurLabel.alpha = defaultAlpha
                self.rubLabel.alpha = defaultAlpha
            }
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
            let textField = alert?.textFields?[0]
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
