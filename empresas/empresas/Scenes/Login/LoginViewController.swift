//
//  LoginViewController.swift
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

protocol LoginDisplayLogic: class
{
  func displaySomething(viewModel: Login.Something.ViewModel)
    func displayError(viewModel: Login.Error.ViewModel)
    func displayUserLogin(loginData: Login.Something.LoginData)
}

class LoginViewController: UIViewController, LoginDisplayLogic
{
  var interactor: LoginBusinessLogic?
  var router: (NSObjectProtocol & LoginRoutingLogic & LoginDataPassing)?

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = LoginInteractor()
    let presenter = LoginPresenter()
    let router = LoginRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    setupView()
    //doLogin()
    interactor?.getLoginStoredData()
    
  }
  
  // MARK: Do something
  
  //@IBOutlet weak var nameTextField: UITextField!
    var backgroundImage: UIImageView!
    var emailLabel: UILabel!
    var passwordLabel: UILabel!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var loginButton: UIButton!
    var passwordRevealButton: UIButton!
    var greetingsLabel: UILabel!
    var iconImage: UIImageView!
    var errorFeedbackLabel: UILabel!
    var errorEmailFeedbackImage: UIImageView!
    var errorPasswordFeedbackImage: UIImageView!
    var loadingView: UIView!
    var innerCircleView: UIView!
    var outerCircleView: UIView!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    func setupView(){
        backgroundImage = UIImageView(frame: view.frame)
        backgroundImage.image = #imageLiteral(resourceName: "background")
        let path = UIBezierPath(ovalIn: CGRect(x: -view.frame.width/2, y: -view.frame.height*2/3, width: view.frame.width * 2, height: view.frame.height ))
        backgroundImage.mask(withPath: path)
        
        iconImage = UIImageView(image: #imageLiteral(resourceName: "logo_icon"))
        errorPasswordFeedbackImage = UIImageView(image: #imageLiteral(resourceName: "loginError"))
        errorPasswordFeedbackImage.isHidden = true
        errorEmailFeedbackImage = UIImageView(image: #imageLiteral(resourceName: "loginError"))
        errorEmailFeedbackImage.isHidden = true
        
        greetingsLabel = UILabel()
        greetingsLabel.setup(text: "Seja bem vindo ao empresas!", color: .white, fontSize: 20)
        
        emailLabel = UILabel()
        emailLabel.setup(text: "Email", color: UIColor(named: "gray3")!, fontSize: 14)
        
        passwordLabel = UILabel()
        passwordLabel.setup(text: "Senha", color: UIColor(named: "gray3")!, fontSize: 14)
        
        errorFeedbackLabel = UILabel()
        errorFeedbackLabel.setup(text: "Credenciais incorretas", color: UIColor(named: "red")!, fontSize: 14)
        errorFeedbackLabel.isHidden = true
        
        emailTextField = UITextField()
        emailTextField.delegate = self
        emailTextField.clipsToBounds = true
        emailTextField.layer.masksToBounds = true
        emailTextField.autocapitalizationType = .none
        emailTextField.layer.cornerRadius = 4
        emailTextField.layer.borderColor = UIColor(named: "red")?.cgColor
        emailTextField.backgroundColor = UIColor(named: "gray1")
        emailTextField.layer.borderWidth = 0
        emailTextField.borderStyle = .none
        
        passwordTextField = UITextField()
        passwordTextField.delegate = self
        passwordTextField.layer.masksToBounds = true
        passwordTextField.isSecureTextEntry = true
        passwordTextField.clipsToBounds = true
        passwordTextField.autocapitalizationType = .none
        passwordTextField.layer.cornerRadius = 4
        passwordTextField.layer.borderColor = UIColor(named: "red")?.cgColor
        passwordTextField.layer.borderWidth = 0
        passwordTextField.backgroundColor = UIColor(named: "gray1")
        passwordTextField.borderStyle = .none
        
        loginButton = UIButton()
        loginButton.setTitle("ENTRAR", for: .normal)
        loginButton.backgroundColor = UIColor(named: "pink")
        loginButton.addTarget(self, action: #selector(doLogin), for: .touchUpInside)
        loginButton.layer.cornerRadius = 8
        
        passwordRevealButton = UIButton()
        passwordRevealButton.setBackgroundImage(#imageLiteral(resourceName: "passwordReveal"), for: .normal)
        passwordRevealButton.addTarget(self, action: #selector(revealPassword), for: .touchUpInside)
        
        view.addSubviews([backgroundImage, emailLabel, passwordLabel, emailTextField, passwordTextField, loginButton, greetingsLabel, iconImage, errorFeedbackLabel, errorPasswordFeedbackImage, errorEmailFeedbackImage, passwordRevealButton])
        
        setupConstraints()
        
        createLoadingView()
        
    }
    
    func createLoadingView(){
        loadingView = UIView(frame: view.frame)
        innerCircleView = UIView(frame: view.frame)
        outerCircleView = UIView(frame: view.frame)
        
        let background = UIView(frame: view.frame)
        background.backgroundColor = UIColor(named: "transparentBlack")
        loadingView.addSubviews([background])
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: view.frame.width/2, y: view.frame.height/2), radius: CGFloat(50), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2 * 0.75), clockwise: true)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath

        // Change the fill color
        shapeLayer.fillColor = UIColor.clear.cgColor
        // You can change the stroke color
        shapeLayer.strokeColor = UIColor(named: "lightPink")?.cgColor
        // You can change the line width
        shapeLayer.lineWidth = 5.0
        
        innerCircleView.layer.addSublayer(shapeLayer)
        
        
        let circlePathInner = UIBezierPath(arcCenter: CGPoint(x: view.frame.width/2, y: view.frame.height/2), radius: CGFloat(30), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2 * 0.75), clockwise: true)

        let shapeLayerInner = CAShapeLayer()
        shapeLayerInner.path = circlePathInner.cgPath

        // Change the fill color
        shapeLayerInner.fillColor = UIColor.clear.cgColor
        // You can change the stroke color
        shapeLayerInner.strokeColor = UIColor(named: "lightPink")?.cgColor
        // You can change the line width
        shapeLayerInner.lineWidth = 5.0

        outerCircleView.layer.addSublayer(shapeLayerInner)
        loadingView.addSubviews([innerCircleView, outerCircleView])
        
    }
    
    func setupConstraints()
    {
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/3).isActive = true
        
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        iconImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        iconImage.heightAnchor.constraint(equalToConstant: 31.58).isActive = true
        iconImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        iconImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 84).isActive = true
        
        greetingsLabel.translatesAutoresizingMaskIntoConstraints = false
        greetingsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        greetingsLabel.topAnchor.constraint(equalTo: iconImage.bottomAnchor, constant: 16.42).isActive = true
        
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        emailLabel.topAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: 28).isActive = true
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 4).isActive = true
        
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16).isActive = true

        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 4).isActive = true
        
        passwordRevealButton.translatesAutoresizingMaskIntoConstraints = false
        passwordRevealButton.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor, constant: 0).isActive = true
        passwordRevealButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        passwordRevealButton.widthAnchor.constraint(equalToConstant: 22).isActive = true
        passwordRevealButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: -16).isActive = true
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        errorEmailFeedbackImage.translatesAutoresizingMaskIntoConstraints = false
        errorEmailFeedbackImage.centerYAnchor.constraint(equalTo: emailTextField.centerYAnchor, constant: 0).isActive = true
        errorEmailFeedbackImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        errorEmailFeedbackImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        errorEmailFeedbackImage.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor, constant: -14).isActive = true
        
        errorPasswordFeedbackImage.translatesAutoresizingMaskIntoConstraints = false
        errorPasswordFeedbackImage.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor, constant: 0).isActive = true
        errorPasswordFeedbackImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        errorPasswordFeedbackImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        errorPasswordFeedbackImage.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: -14).isActive = true
        
        errorFeedbackLabel.translatesAutoresizingMaskIntoConstraints = false
        errorFeedbackLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        errorFeedbackLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 4).isActive = true
    }
    
    func updateLayout()
    {
        let path = UIBezierPath(ovalIn: CGRect(x: -view.frame.width/2, y: -view.frame.height*4/5, width: view.frame.width * 2, height: view.frame.height ))
        
        self.backgroundImage.mask(withPath: path)
        self.greetingsLabel.isHidden = true
        self.iconImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 52).isActive = true
        self.backgroundImage.bottomAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/5).isActive = true
        
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeIn, animations: {
            self.view.layoutIfNeeded()
        })
        animator.startAnimation()
    }
    
    func displayError(viewModel: Login.Error.ViewModel)
    {
        presentErrorFeedback()
    }
    
    @objc func revealPassword(){
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    func presentErrorFeedback(_ option: Bool = true)
    {
        errorFeedbackLabel.isHidden = !option
        errorPasswordFeedbackImage.isHidden = !option
        errorEmailFeedbackImage.isHidden = !option
        passwordRevealButton.isHidden = option

        if option
        {
            emailTextField.layer.borderWidth = 1
            passwordTextField.layer.borderWidth = 1
        }
        else
        {
            emailTextField.borderStyle = .none
            passwordTextField.borderStyle = .none
            emailTextField.layer.borderWidth = 0
            passwordTextField.layer.borderWidth = 0

        }
        
        emailTextField.backgroundColor = UIColor(named: "gray1")
        passwordTextField.backgroundColor = UIColor(named: "gray1")
    }
     
    func displayUserLogin(loginData: Login.Something.LoginData){
         emailTextField.text = loginData.email
         passwordTextField.text = loginData.password
     }
    
  
  @objc func doLogin()
  {
    //let request = Login.Something.Request(email: "testeapple@ioasys.com.br", password: "12341234")
    let request = Login.Something.Request(email: emailTextField.text!, password: passwordTextField.text!)
    interactor?.doSomething(request: request)
    displayLoading()
  }
  
  func displaySomething(viewModel: Login.Something.ViewModel)
  {
    //nameTextField.text = viewModel.name
  }
    
    func displayLoading(_ option: Bool = true){
        view.addSubview(loadingView)
        innerCircleView.rotate(clockwise: false)
        outerCircleView.rotate(clockwise: true)
    }
}

extension LoginViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }
        else{
            textField.resignFirstResponder()
        }
        return false
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateLayout()
        presentErrorFeedback(false)
    }
    
}

