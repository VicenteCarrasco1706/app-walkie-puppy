import UIKit
import FirebaseDatabase

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
    }
    
    func setupTableView() {
        tableview.dataSource = self
        tableview.delegate = self
    }

    func loadPaseosFromFirebase() {
        let paseosRef = Database.database().reference().child("paseos")
        paseosRef.observe(.value) { snapshot in
            self.paseos.removeAll()

            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let paseoData = snapshot.value as? [String: Any],
                   let paseo = Paseo(dictionary: paseoData) {
                   self.paseos.append(paseo)
                }
            }

            self.tableview.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paseos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaseoCell", for: indexPath)
        let paseo = paseos[indexPath.row]

        cell.textLabel?.text = "Nombre: \(paseo.nombre)"
        cell.detailTextLabel?.text = "Fecha: \(paseo.fecha) Hora: \(paseo.hora) Dirección: \(paseo.direccion)"

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let paseo = paseos[indexPath.row]

            mostrarVentanaCalificacion { calificacion in
                if let calificacion = calificacion {
                    self.deletePaseoFromFirebase(nombre: paseo.nombre, fecha: paseo.fecha, calificacion: calificacion)
                    self.paseos.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }

    func deletePaseoFromFirebase(nombre: String, fecha: String, calificacion: Int) {
        let paseosRef = Database.database().reference().child("paseos")
        
        paseosRef.queryOrdered(byChild: "nombre").queryEqual(toValue: nombre)
            .observeSingleEvent(of: .value) { snapshot in
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot {
                        if let paseoData = snapshot.value as? [String: Any],
                           let paseoFecha = paseoData["fecha"] as? String, paseoFecha == fecha {
                            paseosRef.child(snapshot.key).removeValue { error, _ in
                                if let error = error {
                                    print("Error al eliminar el paseo de Firebase: \(error.localizedDescription)")
                                } else {
                                    print("Paseo eliminado correctamente de Firebase")
                                    // Realiza acciones adicionales según la calificación aquí
                                }
                            }
                        }
                    }
                }
        }
    }

    func mostrarVentanaCalificacion(completion: @escaping (Int?) -> Void) {
        let alertController = UIAlertController(title: "Calificar paseo", message: "Por favor, primero califica este paseo de 1 a 5", preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "Calificación"
            textField.keyboardType = .numberPad
        }

        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { _ in
            completion(nil)
        }

        let saveAction = UIAlertAction(title: "Guardar", style: .default) { _ in
            if let textField = alertController.textFields?.first,
               let calificacionString = textField.text,
               let calificacion = Int(calificacionString) {
                completion(calificacion)
            } else {
                completion(nil)
            }
        }

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        present(alertController, animated: true)
    }

    // ... Otros métodos y funciones
}
