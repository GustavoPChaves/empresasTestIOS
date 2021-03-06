//
//  LoginPresenter.swift
//  empresas
//
//  Created by Gustavo Chaves on 16/05/20.
//  Copyright (c) 2020 Gustavo Chaves. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol LoginPresentationLogic
{
  func presentSomething(response: Login.Something.Response)
    func presentError(response: Login.Something.Response)
    func presentLoginData(loginData: Login.Something.LoginData)
}

class LoginPresenter: LoginPresentationLogic
{
  weak var viewController: LoginDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: Login.Something.Response)
  {
    let viewModel = Login.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
    func presentError(response: Login.Something.Response)
    {
        let viewModel = Login.Error.ViewModel(message: response.user.errors?[0] ?? "")
        viewController?.displayError(viewModel: viewModel)
    }
    func presentLoginData(loginData: Login.Something.LoginData){
         viewController?.displayUserLogin(loginData: loginData)
     }
}
