//
//  HomeViewController.swift
//  app-walkie-puppy
//
//  Created by DAMII on 18/11/23.
//

import UIKit
enum ProviderType: String {
    case basic
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var providerLabel: UITextField!
    @IBOutlet weak var closeSessionButton: UIButton!
    
    private let email: String
    private let provider: ProviderType
    
    init(email: String, provider: ProviderType){
        self.email = email
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
