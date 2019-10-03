//
//  ViewController.swift
//  coreDataTest
//
//  Created by Carlos Fontes on 19/07/19.
//  Copyright © 2019 Carlos Fontes. All rights reserved.
//

import UIKit
import CoreData
import SQLite3

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    
    @IBOutlet weak var nomeFilme: UITextField!
    
    let session = URLSession.shared
    var dataManager = DataManager()
    var db: OpaquePointer?
    let api = Api()
    var movies: ResultsSearch?
    let userDefault = DefaultUser()
    var imagens = [UIImage]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nomeFilme.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        buscar(self)
        return true
    }
    
    
    @IBAction func buscar(_ sender: Any) {
        
        guard let dados = self.nomeFilme.text, dados.count > 0 else {
            return
        }
        
        self.apiMovies(dados)
        
    }
    
    func apiMovies(_ data: String){
        
        let language = userDefault.getValue() as! String
        
        
        let url = "https://api.themoviedb.org/3/search/movie?api_key=0e971c7b20bccd213d26fd99f69f725e&language=\(language)&query=\(data)&page=1&include_adult=false"
        
        tarefa(url, completion: { (data) in
            
            DispatchQueue.main.async {
                self.movies = data
                self.tableView.reloadData()
                self.getImages {
                    print("OK IMAGES 2")
                }
            }
        })
    }
    
    func getImages(completion: ()-> Void){
        
        guard let dados = movies?.results else {
            print("error")
            return
        }
        
        for i in dados{
            self.api.getData2(i.poster_path, completion: { (data) in
                self.imagens.append(data)
            })
        }
        self.tableView.reloadData()
        completion()
    }
    
    func tarefa(_ url: String, completion: @escaping (ResultsSearch) -> Void){
        
        let urlApi = URL(string: url)!
        
        let task = session.dataTask(with: urlApi) { data, response, error in
            completion(self.tratarTarefa(data: data, response: response, error: error)! )
        }
        task.resume()
    }
    
    
    func tratarTarefa(data: Data?, response: URLResponse?, error: Error?) -> ResultsSearch?{
        let decoder = JSONDecoder()
        
        do {
            let results = try decoder.decode(ResultsSearch.self, from: data!)
            return results
        } catch {
            print(error)
        }
        
        return nil
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let filmes = self.movies, filmes.results.count > 0 else {
            return 0
        }
        
        return filmes.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        
        
        guard let titulo = self.movies?.results[indexPath.row].title else {
            return cell
        }
        cell.nameMovie.text = titulo
    
        
        
        return cell

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

}


