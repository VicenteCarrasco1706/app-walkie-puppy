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
        tableview.register(UITableView.self, forCellReuseIdentifier: "PaseoCell")
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
            cell.textLabel?.text = paseo.nombre
            // Añadir configuración adicional según tus necesidades
            return cell
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
