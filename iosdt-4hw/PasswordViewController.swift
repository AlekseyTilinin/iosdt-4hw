//
//  PasswordViewController.swift
//  iosdt-4hw
//
//  Created by Aleksey on 16.01.2023.
//

import UIKit
import UIKit
import KeychainAccess

class PasswordViewController: UIViewController {
    
    let keychain = Keychain(service: "navigator")
    var password: String = ""
    
    var status: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "status")
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "status")
        }
    }
    
    var tryCount: Int {
        get {
            return UserDefaults.standard.integer(forKey: "tryCount")
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "tryCount")
        }
    }
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.layer.borderWidth = 1
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("create password", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(action), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = .white
        self.title = "Password Form"
        
        view.addSubview(textField)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            
            textField.heightAnchor.constraint(equalToConstant: 44),
            textField.widthAnchor.constraint(equalToConstant: 200),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            button.heightAnchor.constraint(equalToConstant: 44),
            button.widthAnchor.constraint(equalToConstant: 150),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 30)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        status = false
//        tryCount = 0
        
        if !status {
            button.setTitle("create password", for: .normal)
        } else {
            button.setTitle("enter password", for: .normal)
        }
    }
    
    @objc
    func action() {
        
        if !status {
            if tryCount == 1 {
                
                if textField.text == password {
                    textField.text = .none
                    button.setTitle("success!", for: .normal)
                    button.backgroundColor = .systemGreen
                    keychain["password"] = password
                    status = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.dismiss(animated: true)
                        self.button.setTitle("enter password", for: .normal)
                        self.button.backgroundColor = .systemBlue
                    }
                } else {
                    button.setTitle("create password", for: .normal)
                    tryCount = 0
                    textField.text = .none
                    
                    button.setTitle("wrong 2nd pass", for: .normal)
                    button.backgroundColor = .systemRed
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.button.setTitle("enter password", for: .normal)
                        self.button.backgroundColor = .systemBlue
                    }
                }
                
            } else if tryCount == 0 {
                if textField.text!.count >= 4 {
                    password = textField.text!
                    textField.text = .none
                    button.setTitle("repeat password", for: .normal)
                    tryCount += 1
                } else {
                    let badPasswordAlert = UIAlertController(title: "Недостаточная длина пароля", message: "Пароль должен содежать не менее четырех символов", preferredStyle: .actionSheet)
                    badPasswordAlert.addAction(UIAlertAction(title: "Try again", style: .cancel))
                    self.present(badPasswordAlert, animated: true, completion: nil)
                }
            }
            
        } else {
            let token = try? keychain.get("password")
            if textField.text == token! {
                
                button.setTitle("success!", for: .normal)
                button.backgroundColor = .systemGreen
                
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    let tabBarController = UITabBarController()
                    var fileTabNavigationController: UINavigationController!
                    var settingsTabNavigationController: UINavigationController!
                    
                    let url = FileManagerService().documentsDirectoryUrl
                    let fileVC = FileViewController()
                    fileVC.title = "File Manager"
                    fileVC.content = FileManagerService().contentsOfDirectory(url)
                    fileTabNavigationController = UINavigationController(rootViewController: fileVC)
                    settingsTabNavigationController = UINavigationController(rootViewController: SettingsViewController())
                    
                    let item1 = UITabBarItem(title: "File", image: UIImage(systemName: "folder.circle"), tag: 0)
                    let item2 = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape.2"), tag: 1)
                    
                    fileTabNavigationController.tabBarItem = item1
                    settingsTabNavigationController.tabBarItem = item2
                    
                    tabBarController.viewControllers = [fileTabNavigationController, settingsTabNavigationController]
                    
                    self.navigationController?.pushViewController(tabBarController, animated: true)
                }
                
            } else {
                textField.text = .none
                
                button.setTitle("wrong passord", for: .normal)
                button.backgroundColor = .systemRed
                
                DispatchQueue.main.asyncAfter(deadline: .now()+1){
                    self.button.setTitle("enter password", for: .normal)
                    self.button.backgroundColor = .systemBlue
                }
            }
        }
        
    }
}
