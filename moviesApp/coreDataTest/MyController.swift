//
//  MyController.swift
//  coreDataTest
//
//  Created by Carlos Fontes on 25/07/19.
//  Copyright © 2019 Carlos Fontes. All rights reserved.
//

import UIKit
import CoreData

class MyController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var tableView: UITableView!
    var dataManager = DataManager()
    var db: OpaquePointer?
    var nomes = [String]()
    var imagens = [Data]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
//        print(nomes.count)
        // Do any additional setup after loading the view.
    }
    

    @IBAction func add(_ sender: Any) {
        performSegue(withIdentifier: "add", sender: nil)
    }
    

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nomes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        
//        print(nomes[indexPath.row])
        cell.nameMovie.text = nomes[indexPath.row]
        cell.imageMovie.image = UIImage(data: imagens[indexPath.row])
//        print(nomes[indexPath.row])
        
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        if(editingStyle == UITableViewCell.EditingStyle.delete) {
//
//            nomes.remove(at: indexPath.row)
//            imagens.remove(at: indexPath.row)
//            self.tableView.deleteRows(at: [indexPath], with: .fade)
//            self.deleteAllData("Filme", nomes[indexPath.row])
//            self.tableView.reloadData()
//
//
//        }
//    }
    
    
    
    func loadData(){
        
        // Aqui ele recupera os dados referente a entidade escolhida.
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Filme")
        
        // Aqui ele instancia o container.
        let context = dataManager.persistentContainer.viewContext
        do{
            let results = try context.fetch(fetchRequest)
            let movie = results as! [NSManagedObject]
            //            self.namePerson.text = person[0].value(forKey: "nome") as! String
            //            print(movie.count, movie.description)
            
            for i in movie {
                nomes.append(i.value(forKey: "nome") as! String)
                imagens.append(i.value(forKey: "imagem") as! Data)
            }
            
            //            return movie
        }catch{
            fatalError("Error is retriving titles items")
        }
    }
    
    
    func deleteAllData(_ entity:String, _ data: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        let context = dataManager.persistentContainer.viewContext
        
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                
                if (objectData.value(forKey: "nome") as! String) == data {
                    context.delete(objectData)
                    print("Entrei aqui")
                }
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
}
