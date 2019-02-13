//
//  SwipeVC.swift
//  EveryDayApp
//
//  Created by Artem on 2/13/19.
//  Copyright © 2019 Artem. All rights reserved.
//

import UIKit
import SwipeVC

final class SwipeVC: SVCSwipeViewController {

    let currencyConstraints = CurrencyVC()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarInjection()
        addViewControllers()
    }

    private func addViewControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let weatherVC = storyboard.instantiateViewController(withIdentifier: "WeatherVC") as! WeatherVC

        let currencyVC = storyboard.instantiateViewController(withIdentifier: "CurrencyVC") as! CurrencyVC
        currencyVC.tabBarHeigh = tabBar?.height

        let toDoListTableVC = storyboard.instantiateViewController(withIdentifier: "ToDoListTableVC") as! ToDoListTableVC

        viewControllers = [weatherVC, currencyVC, toDoListTableVC]
    }

    private func tabBarInjection() {
        tabBarType = .top

        let defaultTabBar = SVCTabBar()

        showMovableView(onDefaultTabBar: defaultTabBar)

        // Init first item
        let weatherItem = SVCTabItem(type: .system)
        weatherItem.imageViewAnimators = [SVCTransitionAnimator(transitionOptions: .transitionFlipFromTop)]
        weatherItem.setTitle("Weather", for: .normal)

        // Init second item
        let currencyItem = SVCTabItem(type: .system)
        currencyItem.imageViewAnimators = [SVCTransitionAnimator(transitionOptions: .transitionFlipFromRight)]
        currencyItem.setTitle("Currency", for: .normal)

        // Init third item
        let toDoItem = SVCTabItem(type: .system)
        toDoItem.imageViewAnimators = [SVCTransitionAnimator(transitionOptions: .transitionFlipFromBottom)]
        toDoItem.setTitle("ToDo List", for: .normal)

        defaultTabBar.items = [weatherItem, currencyItem, toDoItem]

        // inject tab bar
        tabBar = defaultTabBar
    }

    func showMovableView(onDefaultTabBar defaultTabBar: SVCTabBar) {
        defaultTabBar.movableView.isHidden = false
        defaultTabBar.movableView.backgroundColor = UIColor.black
        defaultTabBar.movableView.bouncing = 0.5
        defaultTabBar.movableView.width = 64
        defaultTabBar.movableView.height = 1
        defaultTabBar.movableView.attach = .bottom
    }
}
