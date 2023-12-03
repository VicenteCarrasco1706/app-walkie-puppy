//
//  InicioViewController.swift
//  app-walkie-puppy
//
//  Created by DAMII on 19/11/23.
//

import UIKit

class InicioViewController: UIViewController {

    @IBOutlet weak var programapaseo: UIButton!
    @IBOutlet weak var listapaseo: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        view.backgroundColor = UIColor(red: 173.0/255.0, green: 216.0/255.0, blue: 230.0/255.0, alpha: 1.0)

        // Do any additional setup after loading the view.
    }
    
    func configureUI() {

        // Configura el estilo del botón de inicio de sesión
        programapaseo.layer.cornerRadius = 8.0
        programapaseo.backgroundColor = UIColor.blue
        programapaseo.setTitleColor(UIColor.white, for: .normal)
        
        // Configura el estilo del botón de inicio de sesión
        listapaseo.layer.cornerRadius = 8.0
        listapaseo.backgroundColor = UIColor.blue
        listapaseo.setTitleColor(UIColor.white, for: .normal)
    }

    func configureTextField(_ textField: UITextField) {
        textField.layer.cornerRadius = 8.0
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        textField.textColor = UIColor.black
        textField.tintColor = UIColor.blue
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
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
