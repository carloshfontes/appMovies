//
//  ViewInit.swift
//  coreDataTest
//
//  Created by Carlos Fontes on 24/07/19.
//  Copyright © 2019 Carlos Fontes. All rights reserved.
//

import UIKit
import CoreData

struct DefaultUser {
    
    func setLanguage(_ language: String){
        UserDefaults.standard.setValue(language, forKey: "language")
    }
    
    func getValue() -> Any {
        return UserDefaults.standard.object(forKey: "language") as Any
    }
}

class ViewInit: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var viewError: UIView!
    @IBOutlet weak var textError: UILabel!
    @IBOutlet weak var bgInit: UIView!
    @IBOutlet weak var textInit: UILabel!
    
    @IBOutlet weak var language: UISegmentedControl!
    
    
    var dataManager = DataManager()
    var db: OpaquePointer?
    var userDefault = DefaultUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewError.center.y -= 140
        
//        let locale = Locale.current.identifier
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sleep(1)
        posicaoBGinit()
        deleteAllData("Pessoa")
//        deleteAllData2("Filme")
        let returnDB = loadData()
        if returnDB != [] {
            performSegue(withIdentifier: "one2", sender: nil)
        }
        
        
    }
    
    @IBAction func add(_ sender: Any) {
        guard let namePerson = self.name.text, namePerson.count > 0 else {
            UIView.animate(withDuration: 2.0, animations: {
                self.viewError.center.y += 140
            })
            return
        }
        
        saveNameOfMovie(with: namePerson)
        
        performSegue(withIdentifier: "bemVindo", sender: nil)

    }
    
    func posicaoBGinit(){
        UIView.animate(withDuration: 2.0, animations: {
            self.bgInit.center.x = -220
        })
    }
    
    @IBAction func changeLanguage(_ sender: Any) {
        
        if self.language.selectedSegmentIndex == 0 {
            userDefault.setLanguage("en-US")
        }else if self.language.selectedSegmentIndex == 1 {
            userDefault.setLanguage("pt-BR")
        }
    }
    
    
    func saveNameOfMovie(with name: String) {
        // Aqui ele instancia o container.
        let managedContext = dataManager.persistentContainer.viewContext
        
        // Aqui ele referencia a tabela da entidade escolhida.
        let entity = NSEntityDescription.entity(forEntityName: "Pessoa", in: managedContext)!
        
        // Aqui cria o objeto que será persistido.
        let movie = NSManagedObject(entity: entity, insertInto: managedContext)
        
        movie.setValue(name, forKey: "nome")
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteAllData(_ entity:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        let context = dataManager.persistentContainer.viewContext

        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                context.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
    
    func loadData() -> [NSManagedObject]{
        
        // Aqui ele recupera os dados referente a entidade escolhida.
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pessoa")
        
        // Aqui ele instancia o container.
        let context = dataManager.persistentContainer.viewContext
        do{
            let results = try context.fetch(fetchRequest)
            let person = results as! [NSManagedObject]
//            self.namePerson.text = person[0].value(forKey: "nome") as! String

            return person
        }catch{
            fatalError("Error is retriving titles items")
        }
    }
    
//
//    func deleteAllData2(_ entity:String) {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
//        fetchRequest.returnsObjectsAsFaults = false
//        let context = dataManager.persistentContainer.viewContext
//
//        do {
//            let results = try context.fetch(fetchRequest)
//            for object in results {
//                guard let objectData = object as? NSManagedObject else {continue}
//                    context.delete(objectData)
//            }
//        } catch let error {
//            print("Detele all data in \(entity) error :", error)
//        }
//    }



}
