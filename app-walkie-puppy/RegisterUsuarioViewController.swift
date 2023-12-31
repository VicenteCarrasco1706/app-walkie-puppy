//
//  RegisterUsuarioViewController.swift
//  app-walkie-puppy
//
//  Created by DAMII on 26/11/23.
//

import UIKit
import FirebaseAuth

class RegisterUsuarioViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var singUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
        passwordTextField.isSecureTextEntry = true

        // Configura el color de fondo para la vista principal (celeste claro)
        view.backgroundColor = UIColor(red: 173.0/255.0, green: 216.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    }
    func configureUI() {
        // Configura el estilo de los textfields
        configureTextField(emailTextField)
        configureTextField(passwordTextField)

        // Configura el estilo del botón de inicio de sesión
        singUpButton.layer.cornerRadius = 8.0
        singUpButton.backgroundColor = UIColor.blue
        singUpButton.setTitleColor(UIColor.white, for: .normal)
    }

    func configureTextField(_ textField: UITextField) {
        textField.layer.cornerRadius = 8.0
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        textField.textColor = UIColor.black
        textField.tintColor = UIColor.blue
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
