//
//  AuthViewController.swift
//  app-huron-azul
//
//  Created by DAMII on 5/11/23.
//

import UIKit
import FirebaseAnalytics
import FirebaseAuth


class AuthViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var singUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func singUpButtonAction(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text{
            Auth.auth().createUser(withEmail: email, password: password){ (result, error) in
                if let error = error{
                    print("Error durante la autenticacion: \(error.localizedDescription)")
            } else {
                self.transitionToLoginViewController()
            }
        }
    }
    }
    
    @IBAction func logInButtonAction(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text{
            Auth.auth().signIn(withEmail: email, password: password){ (result, error) in
                if let error = error{
                    print("Error durante la autenticacion: \(error.localizedDescription)")
            } else {
                self.transitionToInicioViewController()
            }
        }
    }
    }
    
                
        func transitionToInicioViewController(){
            if let inicioViewController = self.storyboard?.instantiateViewController(identifier: "InicioViewController"){
            self.navigationController?.pushViewController(inicioViewController, animated: true)
        }
        }
    
    func transitionToLoginViewController(){
        if let loginViewController = self.storyboard?.instantiateViewController(identifier: "LoginViewController"){
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    }
}
