//
//  VerPaseosViewController.swift
//  app-walkie-puppy
//
//  Created by DAMII on 19/11/23.
//

import UIKit
import Firebase

struct Paseo {
    var nombre: String
    var fecha: String
    var hora: String
    var direccion: String

    init?(dictionary: [String: Any]) {
        guard let nombre = dictionary["nombre"] as? String,
              let fecha = dictionary["fecha"] as? String,
              let hora = dictionary["hora"] as? String,
              let direccion = dictionary["direccion"] as? String else {
            return nil
        }

        self.nombre = nombre
        self.fecha = fecha
        self.hora = hora
        self.direccion = direccion
    }
}

class VerPaseosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    
    var paseos: [Paseo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadPaseosFromFirebase()
        // Do any additional setup after loading the view.
        //tableview.register(UITableViewCell.self, forCellReuseIdentifier: "PaseoCell")
    }
    
    func setupTableView() {
            tableview.dataSource = self
            tableview.delegate = self
            // Configurar cualquier otra propiedad de la tabla según tus necesidades
        }

        func loadPaseosFromFirebase() {
            let paseosRef = Database.database().reference().child("paseos")
            paseosRef.observe(.value) { snapshot in
                // Limpiar la lista antes de agregar los nuevos datos
                self.paseos.removeAll()

                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot,
                       let paseoData = snapshot.value as? [String: Any],
                       let paseo = Paseo(dictionary: paseoData) {
                       self.paseos.append(paseo)
                    }
                }

                // Actualizar la tabla después de cargar los paseos
                self.tableview.reloadData()
            }
        }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return paseos.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaseoCell", for: indexPath)
            let paseo = paseos[indexPath.row]
            // Configurar la celda con los datos del paseo
            cell.textLabel?.text = "Nombre: \(paseo.nombre)"
            cell.detailTextLabel?.text = "Fecha: \(paseo.fecha) Hora: \(paseo.hora) Dirección: \(paseo.direccion)"

            // Añadir configuración adicional según tus necesidades
            return cell
        }
    
    // Implementa este método para permitir la edición de las celdas
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Implementa este método para definir el estilo de edición y las acciones disponibles
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let paseo = paseos[indexPath.row]
            paseos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Elimina el paseo de Firebase según nombre y fecha
            deletePaseoFromFirebase(nombre: paseo.nombre, fecha: paseo.fecha)
        }
    }

    func deletePaseoFromFirebase(nombre: String, fecha: String) {
        let paseosRef = Database.database().reference().child("paseos")
        
        // Busca el paseo por nombre y fecha y elimínalo
        paseosRef.queryOrdered(byChild: "nombre").queryEqual(toValue: nombre)
            .observeSingleEvent(of: .value) { snapshot in
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot {
                        // Verifica que la fecha también coincida
                        if let paseoData = snapshot.value as? [String: Any],
                           let paseoFecha = paseoData["fecha"] as? String, paseoFecha == fecha {
                            // Elimina el paseo de Firebase
                            paseosRef.child(snapshot.key).removeValue { error, _ in
                                if let error = error {
                                    print("Error al eliminar el paseo de Firebase: \(error.localizedDescription)")
                                } else {
                                    print("Paseo eliminado correctamente de Firebase")
                                }
                            }
                        }
                    }
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
