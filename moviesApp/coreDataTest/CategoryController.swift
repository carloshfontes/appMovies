//
//  CategoryController.swift
//  coreDataTest
//
//  Created by Carlos Fontes on 24/07/19.
//  Copyright © 2019 Carlos Fontes. All rights reserved.
//

import UIKit
import CoreData

class CategoryController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let language = DefaultUser()

    var generos = ""
    
    var categoryEN = [
    "Action", "Adventure", "Animation", "Comedy", "Crime", "Documentary","Drama", "Family", "Fantasy", "History", "Horror", "Music", "Mystery", "Romance", "Science Fiction", "TV Movie", "Thriller", "War", "Western"    ]
    
    var categoryValues = [
    "28", "12", "16", "35", "80", "99", "18", "10751", "14", "36", "27", "10402", "9648", "10749", "878", "10770", "53", "10752", "37"]
    
    var arrayCategory = [String: Any]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sent = segue.destination as? FirstViewController
        sent?.generos = self.generos
        
    }
    
    @IBAction func prosseguirButton(_ sender: Any) {
        
        
        performSegue(withIdentifier: "bemVindo", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        
        
        return categoryEN.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! CategoryCell
        
        cell.categoriaTexto.text = categoryEN[indexPath.row]
        cell.check.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! CategoryCell
        self.generos = categoryValues[indexPath.row]
//        cell.check.isHidden = false
    }
    
    func getCategory(completion: @escaping ([String: Any]) -> Void){
        
        let session = URLSession.shared
        
        let urlCategory = "https://api.themoviedb.org/3/genre/movie/list?api_key=0e971c7b20bccd213d26fd99f69f725e&language=\(language.getValue())"
        
        let url = URL(string: urlCategory)!
        
        let task = session.dataTask(with:  url) { data, response, error in
            completion(self.tratarResposta(data: data, response: response, error: error) as! [String: Any])
        }
        task.resume()
    }
    
    func tratarResposta(data: Data?, response: URLResponse?, error: Error?) -> Any?{
        guard let dataResponse = data,
            error == nil else {
                print(error?.localizedDescription ?? "Response Error")
                return nil }
        do{
            let jsonResponse = try JSONSerialization.jsonObject(with:
                dataResponse, options: [])
            
            guard let jsonTest = jsonResponse as? [String: Any] else {
                return nil
            }
            
//            guard let data = jsonTest[()] else {
//                return jsonResponse as! [String: Any]
//            }

            return jsonTest

//            return jsonResponse as! [String: Any]
        }catch {
            print("Erro no tratar erro")
        }

        return nil
    }
}
