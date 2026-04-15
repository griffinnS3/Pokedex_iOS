//
//  RootViewController.swift
//  Project_3
//
//  Created by Smith01, Griffin on 4/15/26.
//
import UIKit

class NavigationController: UINavigationController {
    let tableView = GridViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [tableView]
    }
}
