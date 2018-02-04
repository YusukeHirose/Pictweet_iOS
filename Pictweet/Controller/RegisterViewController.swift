//
//  RegisterViewController.swift
//  Pictweet
//
//  Created by User on 2018/02/04.
//  Copyright © 2018年 User. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(toBack))
        navigationItem.leftBarButtonItem = backButtonItem
        userNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @objc func toBack() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapRegisterButton(_ sender: UIButton) {
        guard let userName = userNameTextField.text,
              let email = emailTextField.text, let password = passwordTextField.text else { return }
              let user = User(userName: userName, email: email, password: password)
        
        user.register { error in
            if let errorMessage = (error as NSError?)?.userInfo["NSLocalizedDescription"] as? String {
                self.showAlert(message: errorMessage)
            } else {
                print("登録成功")
            }
        }
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
