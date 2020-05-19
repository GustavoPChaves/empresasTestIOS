//
//  HomeRouter.swift
//  empresas
//
//  Created by Gustavo Chaves on 18/05/20.
//  Copyright (c) 2020 Gustavo Chaves. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol HomeRoutingLogic
{
  func routeToSomewhere(segue: UIStoryboardSegue?, selectedEnterpriseId: Int)
}

protocol HomeDataPassing
{
  var dataStore: HomeDataStore? { get }
}

class HomeRouter: NSObject, HomeRoutingLogic, HomeDataPassing
{
  weak var viewController: HomeViewController?
  var dataStore: HomeDataStore?
  
  // MARK: Routing
  
    func routeToSomewhere(segue: UIStoryboardSegue?, selectedEnterpriseId: Int)
  {
    if let segue = segue {
      let destinationVC = segue.destination as! DetailViewController
      var destinationDS = destinationVC.router!.dataStore!
        passDataToSomewhere(source: dataStore!, destination: &destinationDS, selectedEnterpriseId: selectedEnterpriseId)
    } else {
      //let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let destinationVC = DetailViewController()//storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! DetailViewController
      var destinationDS = destinationVC.router!.dataStore!
      passDataToSomewhere(source: dataStore!, destination: &destinationDS, selectedEnterpriseId: selectedEnterpriseId)
      navigateToSomewhere(source: viewController!, destination: destinationVC)
    }
  }

  // MARK: Navigation
  
  func navigateToSomewhere(source: HomeViewController, destination: DetailViewController)
  {
    destination.modalPresentationStyle = .automatic
    source.show(destination, sender: nil)
  }
  
  // MARK: Passing data
  
  func passDataToSomewhere(source: HomeDataStore, destination: inout DetailDataStore, selectedEnterpriseId: Int)
  {
    destination.enterprise = source.enterprises[selectedEnterpriseId]
  }
}
