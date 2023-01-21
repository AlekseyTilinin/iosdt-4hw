//
//  SettingsViewController.swift
//  iosdt-4hw
//
//  Created by Aleksey on 07.01.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var sortMethod: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "sortStatus")
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "sortStatus")
        }
    }
    
    private lazy var sortLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sort files by abc"
        return label
    }()
    
    private lazy var sortSwitcher: UISwitch = {
        let switcher = UISwitch()
        switcher.translatesAutoresizingMaskIntoConstraints = false
        switcher.addTarget(self, action: #selector(setSort), for: .valueChanged)
        return switcher
    }()
    
    private lazy var passwordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(" Change password ", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(changePassword), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(sortLabel)
        view.addSubview(sortSwitcher)
        view.addSubview(passwordButton)
        
        NSLayoutConstraint.activate([
            sortLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            sortLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            
            sortSwitcher.centerYAnchor.constraint(equalTo: sortLabel.centerYAnchor),
            sortSwitcher.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            passwordButton.topAnchor.constraint(equalTo: sortLabel.bottomAnchor, constant: 20),
            passwordButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if sortMethod {
            sortSwitcher.isOn = true
        } else {
            sortSwitcher.isOn = false
        }
    }
    
    @objc
    func setSort() {
        if sortSwitcher.isOn {
            sortMethod = true
        } else {
            sortMethod = false
        }
    }
    
    @objc
    func changePassword() {
        PasswordViewController().status = false
        present(PasswordViewController(), animated: true)
    }
}
