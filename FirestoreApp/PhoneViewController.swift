//
//  PhoneViewController.swift
//  FirestoreApp
//
//  Created by Usuário Convidado on 17/11/17.
//  Copyright © 2017 FIAP. All rights reserved.
//

import UIKit
import Firebase

class PhoneViewController: UIViewController {

    @IBOutlet weak var tfModel: UITextField!
    @IBOutlet weak var tfManufacture: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var tfYear: UITextField!
    
    //tipo do banco de dados representado no firebase
    lazy var firestore: Firestore = {
        
        //devolve o banco criado
        let store = Firestore.firestore()
        
        return store
        
    }()
    
    var phone: Phone!
    
    @IBAction func save(_ sender: Any) {
        
        //tenho que salvar um dicionario para add ao banco
        
        var phoneDict: [String: Any] = [:]
        phoneDict["model"] = tfModel.text!
        phoneDict["manufacture"] = tfManufacture.text!
        phoneDict["price"] = Double(tfPrice.text!)! //melhorar com numberformatter
        phoneDict["year"] = Int(tfYear.text!)!
        
        if phone == nil {
            //adiciono um registro na nuvem (insert no real time data base)
            firestore.collection("phones").addDocument(data: phoneDict) { (error: Error?) in
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            //edito um registro
            firestore.collection("phones").document(phone.id).setData(phoneDict, completion: { (error) in
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //significa que estou no modo edicao
        if phone != nil {
        
            tfModel.text = phone.model
            tfYear.text = "\(phone.year)"
            tfPrice.text = "\(phone.price)"
            tfManufacture.text = phone.manufacturer
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
