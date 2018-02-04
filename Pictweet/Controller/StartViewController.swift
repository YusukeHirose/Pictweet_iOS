//
//  StartViewController.swift
//  Pictweet
//
//  Created by User on 2018/02/04.
//  Copyright © 2018年 User. All rights reserved.
//

import UIKit
import NCMB

class StartViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        guard let userName = userNameTextField.text, let password = passwordTextField.text else { return }
        let user = User(userName: userName, email: "", password: password)
        user.login { error in
            if let errorMessage = (error as NSError?)?.userInfo["NSLocalizedDescription"] as? String {
                self.showAlert(message: errorMessage)
            } else {
                self.performSegue(withIdentifier: "toTimeLineFromStart", sender: self)
            }
        }
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func didTapRegisterButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toRegisterFromStart", sender: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
