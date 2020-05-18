//
//  HomeInteractor.swift
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

protocol HomeBusinessLogic
{
  func doSomething(request: Home.Something.Request)
}

protocol HomeDataStore
{
  //var name: String { get set }
    var headers: Headers { get set}
    var user: LoginResponse { get set}
}

class HomeInteractor: HomeBusinessLogic, HomeDataStore
{
  var presenter: HomePresentationLogic?
  var worker: HomeWorker?
  //var name: String = ""
    var user: LoginResponse = LoginResponse(success: false, investor: nil, enterprise: nil, errors: nil)
    
    var headers = Headers(token: "", uid: "", client: "")
  
  // MARK: Do something
  
  func doSomething(request: Home.Something.Request)
  {
    worker = HomeWorker()
    worker?.doSomeWork()
    
    let response = Home.Something.Response()
    presenter?.presentSomething(response: response)
  }
}