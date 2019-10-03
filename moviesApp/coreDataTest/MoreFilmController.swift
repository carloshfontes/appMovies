//
//  MoreFilmController.swift
//  coreDataTest
//
//  Created by Carlos Fontes on 25/07/19.
//  Copyright © 2019 Carlos Fontes. All rights reserved.
//

import UIKit
import CoreData

class MoreFilmController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var tituloFilme: UILabel!
    

    @IBOutlet weak var titlePage: UINavigationItem!
    
    var dataManager = DataManager()
    var db: OpaquePointer?
    
    var overview2 = String()
    var imageCorrect = UIImage()
    var titulo = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.titlePage.title = self.titulo
       self.overview.text = overview2
       self.image.image = self.imageCorrect
       self.tituloFilme.text = self.titulo
        
    }
    

    @IBAction func selectFilm(_ sender: Any) {
        
        saveNameOfMovie(with: self.titulo, self.overview2, self.imageCorrect.pngData()!)
        performSegue(withIdentifier: "one"
            , sender: nil)
    }
    
    @IBAction func back(_ sender: Any) {
    
        dismiss(animated: true, completion: nil)
    }
    
    
    func saveNameOfMovie(with name: String, _ texto: String, _ imagem: Data) {
        // Aqui ele instancia o container.
        let managedContext = dataManager.persistentContainer.viewContext
        
        // Aqui ele referencia a tabela da entidade escolhida.
        let entity = NSEntityDescription.entity(forEntityName: "Filme", in: managedContext)!
        
        // Aqui cria o objeto que será persistido.
        let movie = NSManagedObject(entity: entity, insertInto: managedContext)
        
        movie.setValue(name, forKey: "nome")
        movie.setValue(texto, forKey: "texto")
        movie.setValue(imagem, forKey: "imagem")
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

}
