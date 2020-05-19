//
//  HomeWorker.swift
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

class HomeWorker
{
  func doSomeWork(type: Int, name: String, headers: Headers, completion: @escaping (EnterpriseResponse?) -> ())
  {
    Networking.shared.getEnterprises(type: type, name: name, headers: headers, completion: completion)
  }
}
