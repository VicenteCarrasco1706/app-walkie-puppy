import UIKit
import FirebaseAuth

class AuthViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true

        // Configura el color de fondo para la vista principal (celeste claro)
        view.backgroundColor = UIColor(red: 173.0/255.0, green: 216.0/255.0, blue: 230.0/255.0, alpha: 1.0)

        // Configura el estilo de los elementos visuales
        configureUI()
    }

    func configureUI() {
        // Configura el estilo de los textfields
        configureTextField(emailTextField)
        configureTextField(passwordTextField)

        // Configura el estilo del botón de inicio de sesión
        logInButton.layer.cornerRadius = 8.0
        logInButton.backgroundColor = UIColor.blue
        logInButton.setTitleColor(UIColor.white, for: .normal)
    }

    func configureTextField(_ textField: UITextField) {
        textField.layer.cornerRadius = 8.0
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        textField.textColor = UIColor.black
        textField.tintColor = UIColor.blue
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
    }

    @IBAction func logInButtonAction(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    print("Error durante la autenticación: \(error.localizedDescription)")
                } else {
                    self.transitionToInicioViewController()
                }
            }
        }
    }

    func transitionToInicioViewController() {
        if let inicioViewController = self.storyboard?.instantiateViewController(identifier: "InicioViewController") {
            self.navigationController?.pushViewController(inicioViewController, animated: true)
        }
    }
}
