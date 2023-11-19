//
//  RegisterPaseoViewController.swift
//  app-walkie-puppy
//
//  Created by DAMII on 19/11/23.
//

import UIKit
import Firebase

class RegisterPaseoViewController: UIViewController {

    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var fechaTextField: UITextField!
    @IBOutlet weak var horaTextField: UITextField!
    @IBOutlet weak var direccionTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registrarPaseoButtonTapped(_ sender: Any) {
        // Recolecta la información del paseo desde los campos de texto
                guard let nombre = nombreTextField.text,
                      let fecha = fechaTextField.text,
                      let hora = horaTextField.text,
                      let direccion = direccionTextField.text else {
                    // Maneja la situación donde no se ingresaron todos los datos
                    print("Por favor, complete todos los campos.")
                    return
    }
        // Llama a la función para registrar el paseo en Firebase
                registrarPaseoEnFirebase(nombre: nombre, fecha: fecha, hora: hora, direccion: direccion)
            }

            func registrarPaseoEnFirebase(nombre: String, fecha: String, hora: String, direccion: String) {
                let paseoRef = Database.database().reference().child("paseos").childByAutoId()
                let paseoData: [String: Any] = [
                    "nombre": nombre,
                    "fecha": fecha,
                    "hora": hora,
                    "direccion": direccion
                ]
                paseoRef.setValue(paseoData) { (error, _) in
                    if let error = error {
                        print("Error al registrar el paseo en Firebase: \(error.localizedDescription)")
                    } else {
                        print("Paseo registrado en Firebase exitosamente")
                        // Puedes agregar aquí cualquier código adicional después de registrar el paseo
                    }
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
