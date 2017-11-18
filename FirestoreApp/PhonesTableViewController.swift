//
//  PhonesTableViewController.swift
//  FirestoreApp
//
//  Created by Usuário Convidado on 17/11/17.
//  Copyright © 2017 FIAP. All rights reserved.
//

import UIKit
import Firebase

class PhonesTableViewController: UITableViewController {

    //eh daqui q a tabela vai receber as informacoes
    var phones: [Phone] = []
    
    //tipo do banco de dados representado no firebase
    lazy var firestore: Firestore = {
        
        //devolve o banco criado
        let store = Firestore.firestore()
        
        return store
        
    }()
    
    
    //referencia do listener do bd em tempo real
    var firestoreListener: ListenerRegistration!
    
    override func viewDidLoad() {
        
        //quando carrega a view
        super.viewDidLoad()
        
        //informo qual a colecao (tabela) que vou ficar ouvindo, pra nao ficar ouvindo tudo
        //e ja retorno os dados ordenados
        //quando chamo esse metodo, ele devolve uma closure
        firestoreListener = firestore.collection("phones").order(by: "model", descending: false).addSnapshotListener({ (snapshot: QuerySnapshot?, error: Error?) in
            
            if error == nil {
                
                //se nao deu pau, desembrulho o dado...e o snapshot documents devolve apenas o registro principal e nao a arvore (todas as tabelas relacionadas)
                guard let snapshot = snapshot else {return}
                
                self.phones.removeAll()
                
                //percorro os registros da tabela
                for document in snapshot.documents {
                
                    //o document.data devolve um dicionario
                    let data = document.data()
                    let model = data["model"] as! String
                    let manufacturer = data["manufacture"] as! String
                    let year = data["year"] as! Int
                    let price = data["price"] as! Double
                    
                    //para pegar o ID eh assim
                    let id = document.documentID
                    
                    let phone = Phone(id: id, model: model, manufacturer: manufacturer, price: price, year: year)
                    
                    //como estou dentro de uma closure, coloco o self
                    self.phones.append(phone)
                    
                }

                //atualizo a tableview
                self.tableView.reloadData()
            }
            
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let phone = sender as? Phone {
            let vc = segue.destination as! PhoneViewController
            vc.phone = phone
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        //vou ter a qtd de linhas que estiver na tabela
        return phones.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let phone = phones[indexPath.row]
        
        //campos que vai aparecer na lista
        cell.textLabel?.text = phone.model
        cell.detailTextLabel?.text = phone.manufacturer

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    //Deletando objeto do firebase
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
 
            //pegando o documento especifico daquela colecao
            let phone = phones[indexPath.row]
            firestore.collection("phones").document(phone.id).delete()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let phone = phones[indexPath.row]
        
        //executa uma segue
        performSegue(withIdentifier: "editSegue", sender: phone)
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}
