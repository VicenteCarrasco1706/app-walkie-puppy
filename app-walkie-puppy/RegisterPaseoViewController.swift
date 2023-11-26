//
//  RegisterPaseoViewController.swift
//  app-walkie-puppy
//
//  Created by DAMII on 19/11/23.
//

import UIKit
import Firebase

class RegisterPaseoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var fechaTextField: UITextField!
    @IBOutlet weak var horaTextField: UITextField!
    @IBOutlet weak var direccionTextField: UITextField!

 
    let pickerView = UIPickerView()
    let datePicker = UIDatePicker()

    let horas: [String] = ["08:00 am", "09:00 am", "10:00 am", "11:00 am", "12:00 pm", "01:00 pm", "02:00 pm", "03:00 pm", "04:00 pm", "05:00 pm"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configura el UIPickerView para las horas
        pickerView.delegate = self
        pickerView.dataSource = self
        horaTextField.inputView = pickerView

        // Configura el UIDatePicker para las fechas y horas
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 15, to: Date()) // Establece el límite mínimo a 15 días en el futuro
        fechaTextField.inputView = datePicker

        // Configura el UIToolbar para ambos pickers
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePicker))
        toolbar.setItems([doneButton], animated: false)

        horaTextField.inputAccessoryView = toolbar
        fechaTextField.inputAccessoryView = toolbar
    }

    @objc func donePicker() {
        // Oculta ambos pickers al presionar "Done"
        horaTextField.resignFirstResponder()
        fechaTextField.resignFirstResponder()
    }

    // Implementa el protocolo UIPickerViewDelegate y UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return horas.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return horas[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        horaTextField.text = horas[row]
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
