//
//  HomeViewController.swift
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

protocol HomeDisplayLogic: class
{
  func displaySomething(viewModel: Home.Something.ViewModel)
}

class HomeViewController: UIViewController, HomeDisplayLogic
{
  var interactor: HomeBusinessLogic?
  var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?

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
    let interactor = HomeInteractor()
    let presenter = HomePresenter()
    let router = HomeRouter()
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
    view.backgroundColor = .white
    super.viewDidLoad()
    //doSomething()
    setupView()
  }
  
  // MARK: Do something
  
  //@IBOutlet weak var nameTextField: UITextField!
    var backgroundImage: UIImageView!
    var searchTextField: UITextField!
    var searchImage: UIImageView!
    var enterprises: [Enterprise] = []
    var enterprisesTableView: UITableView!
    var feedbackLabel: UILabel!
    var noneFeedbackLabel: UILabel!
    var loadingView: LoadingView!
    let cellId = "cellId"
    var containerView: UIView!
    
    var timer: Timer?
    
    var backgroundBottomConstraint: NSLayoutConstraint!
    
    
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        if searchTextField.text == ""{
            updateLayout(isEditing: false)
        }
    }
    
    func setupView()
    {
        loadingView = LoadingView(view: view, hasBackground: false)
        backgroundImage = UIImageView(frame: view.frame)
        backgroundImage.image = #imageLiteral(resourceName: "background")
        backgroundImage.clipsToBounds = true
        backgroundImage.layer.masksToBounds = true
        
        searchTextField = UITextField()
        searchTextField.setLeftPaddingPoints(50)
        searchTextField.placeholder = "Pesquise por empresa"
        searchTextField.delegate = self
        searchTextField.clipsToBounds = true
        searchTextField.layer.masksToBounds = true
        searchTextField.autocapitalizationType = .none
        searchTextField.layer.cornerRadius = 4
        searchTextField.backgroundColor = UIColor(named: "gray1")
        searchTextField.borderStyle = .none
        
        searchImage = UIImageView(image: #imageLiteral(resourceName: "search"))
        
        enterprisesTableView = UITableView()
        enterprisesTableView.register(EnterpriseTableViewCell.self, forCellReuseIdentifier: cellId)
        enterprisesTableView.dataSource = self
        enterprisesTableView.delegate = self
        enterprisesTableView.separatorStyle = .none
        //enterprisesTableView.allowsSelection = false
        
        feedbackLabel = UILabel()
        feedbackLabel.setup(text: "", color: UIColor(named: "gray3") ?? .gray, fontSize: 14)
        
        noneFeedbackLabel = UILabel()
        noneFeedbackLabel.setup(text: "Nenhum resultado encontrado", color: UIColor(named: "gray3") ?? .gray, fontSize: 18)
        noneFeedbackLabel.isHidden = true
        
        view.addSubviews([backgroundImage, searchTextField, searchImage, enterprisesTableView, feedbackLabel, noneFeedbackLabel])
        
        setupConstraints()
        createBackgroundAnimation()
    }
    
    func createBackgroundAnimation(){
        containerView = UIView(frame: backgroundImage.bounds)
        
        view.addSubview(containerView)
        containerView.frame = CGRect(x: 0, y:  0, width: view.frame.width, height: view.frame.height/3 )
        
        containerView.alpha = 0.1
        animator = UIDynamicAnimator(referenceView: containerView)
        
        let collision = UICollisionBehavior()
        //collision.addItem(containerView)
        gravity = UIGravityBehavior()
        let fieldBehaviour = UIFieldBehavior.vortexField()
        let radialGravity = UIFieldBehavior.radialGravityField(position: CGPoint(x: containerView.frame.width/2, y: containerView.frame.height/2))
        fieldBehaviour.position = CGPoint(x: containerView.frame.width/2, y: containerView.frame.height/2)
        fieldBehaviour.strength = 0.5
        
        let size = Double(view.frame.width/25)
         
        for i in 1...4 {
            let iconImage = UIImageView(image: #imageLiteral(resourceName: "logo_icon"))

            //collision.addBoundary(withIdentifier: iconImage, for: UIBezierPath(rect: iconImage.frame))
            containerView.addSubview(iconImage)
            let multiplier = (1 + Double(i)/2) * size
            iconImage.frame = CGRect(x: Double(i * 50), y: Double(i * 20), width: 4 * multiplier, height: 3.1 * multiplier)
            
            gravity.addItem(iconImage)
            collision.addItem(iconImage)
            //fieldBehaviour.addItem(iconImage)
            //radialGravity.addItem(iconImage)
        }
    collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        animator.addBehavior(fieldBehaviour)
        animator.addBehavior(radialGravity)
        animator.addBehavior(gravity)
        
    }
    
    func setupConstraints()
    {
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        backgroundBottomConstraint = backgroundImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height/3)
        backgroundBottomConstraint.isActive = true
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        searchTextField.topAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: -24).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        searchImage.translatesAutoresizingMaskIntoConstraints = false
        searchImage.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor, constant: 16).isActive = true
        searchImage.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor, constant: 0).isActive = true
        searchImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        searchImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        feedbackLabel.translatesAutoresizingMaskIntoConstraints = false
        feedbackLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        feedbackLabel.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16).isActive = true
        
        
        noneFeedbackLabel.translatesAutoresizingMaskIntoConstraints = false
        noneFeedbackLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        noneFeedbackLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 166).isActive = true
        
        enterprisesTableView.translatesAutoresizingMaskIntoConstraints = false
        enterprisesTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 56).isActive = true
        enterprisesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        enterprisesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        enterprisesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        
    }
    
    
    func updateLayout(isEditing: Bool = true)
    {
        if isEditing{
            
            backgroundBottomConstraint.constant = 44
            containerView.alpha = 0
            
        }
        else{
            
            backgroundBottomConstraint.constant = view.frame.height/3
            containerView.alpha = 0.1
        }
        
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut, animations: {
            
            self.view.layoutIfNeeded()
        })
        animator.startAnimation()
    }
  
  func doSomething()
  {
    let request = Home.Something.Request(searchTerm: searchTextField.text ?? "")
    if request.searchTerm.isEmpty
    {
        return
    }
    interactor?.doSomething(request: request)
    view.addSubview(loadingView)
  }
  
  func displaySomething(viewModel: Home.Something.ViewModel)
  {
    //nameTextField.text = viewModel.name
    DispatchQueue.main.async {
        
        self.enterprises = viewModel.enterprises
        if self.enterprises.count > 0 {
            self.feedbackLabel.isHidden = false
            self.feedbackLabel.text = "\(self.enterprises.count) resultados encontrados"
            self.noneFeedbackLabel.isHidden = true
            
        }
        else
        {
            self.feedbackLabel.isHidden = true
            self.noneFeedbackLabel.isHidden = false
        }
        self.loadingView.removeFromSuperview()
    self.enterprisesTableView.reloadData()
        //self.view.layoutIfNeeded()
    }
  }
}

extension HomeViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        if textField.text == "" && enterprises.count == 0{
            updateLayout(isEditing: false)
        }
        else{
            doSomething()
        }
        return false
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateLayout(isEditing: true)
    }
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { (_) in self.doSomething()})
    }
    
}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        enterprises.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EnterpriseTableViewCell
        cell.configure(enterpriseName: enterprises[indexPath.row].enterpriseName)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        router?.routeToSomewhere(segue: nil, selectedEnterpriseId: indexPath.row)
    }

}


