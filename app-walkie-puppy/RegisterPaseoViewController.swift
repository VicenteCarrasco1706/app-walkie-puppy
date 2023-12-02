//
//  RegisterPaseoViewController.swift
//  app-walkie-puppy
//
//  Created by DAMII on 19/11/23.
//

import UIKit
import Firebase

class RegisterPaseoViewController: UIViewController{

    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var fechaTextField: UITextField!
    @IBOutlet weak var horaTextField: UITextField!
    @IBOutlet weak var direccionTextField: UITextField!

 
    let pickerView = UIPickerView()
     let datePicker = UIDatePicker()

     let horas: [String] = ["08:00 am", "09:00 am", "10:00 am", "11:00 am", "12:00 pm", "01:00 pm", "02:00 pm", "03:00 pm", "04:00 pm", "05:00 pm"]

     var selectedDate: Date?

     override func viewDidLoad() {
         super.viewDidLoad()
        // Configura el color de fondo para la vista principal (celeste claro)
        view.backgroundColor = UIColor(red: 173.0/255.0, green: 216.0/255.0, blue: 230.0/255.0, alpha: 1.0)

         // Configura el UIPickerView para las horas
         pickerView.delegate = self
         pickerView.dataSource = self
         horaTextField.inputView = pickerView

         // Configura el UIDatePicker para las fechas y horas
         datePicker.datePickerMode = .date
         datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())
         datePicker.maximumDate = Calendar.current.date(byAdding: .day, value: 15, to: Date())
         fechaTextField.inputView = datePicker

         // Configura el UIToolbar para ambos pickers
         let toolbar = UIToolbar()
         toolbar.sizeToFit()

         let doneButton = UIBarButtonItem(title: "Cerrar", style: .done, target: self, action: #selector(donePicker))
         toolbar.setItems([doneButton], animated: false)

         horaTextField.inputAccessoryView = toolbar
         fechaTextField.inputAccessoryView = toolbar

         // Configura el delegado del textField de fecha
         fechaTextField.delegate = self
     }

     @objc func donePicker() {
         // Oculta ambos pickers al presionar "Done"
         horaTextField.resignFirstResponder()
         fechaTextField.resignFirstResponder()
     }

     @IBAction func registrarPaseoButtonTapped(_ sender: Any) {
         guard let nombre = nombreTextField.text,
               let hora = horaTextField.text,
               let direccion = direccionTextField.text,
               let selectedDate = selectedDate else {
             print("Por favor, complete todos los campos.")
             return
         }

         // Formatea la fecha seleccionada antes de registrar en Firebase
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "dd/MM/yyyy"
         let fecha = dateFormatter.string(from: selectedDate)

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
 }

 extension RegisterPaseoViewController: UITextFieldDelegate {
     func textFieldDidBeginEditing(_ textField: UITextField) {
         if textField == fechaTextField {
             // Abre el selector de fecha cuando se selecciona el campo de texto de fecha
             datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
         }
     }

     @objc func datePickerValueChanged() {
         // Actualiza el campo de texto de fecha con la fecha seleccionada
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "dd/MM/yyyy"
         fechaTextField.text = dateFormatter.string(from: datePicker.date)
         selectedDate = datePicker.date
     }
 }

 // Implementa el protocolo UIPickerViewDelegate y UIPickerViewDataSource
 extension RegisterPaseoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
 }
