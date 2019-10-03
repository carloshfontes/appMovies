//
//  FirstViewController.swift
//  coreDataTest
//
//  Created by Carlos Fontes on 19/07/19.
//  Copyright © 2019 Carlos Fontes. All rights reserved.
//

import UIKit
import CoreData

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var namePerson: UILabel!
    
    var flag = false
    let dataManager = DataManager()
//    var movies = [NSManagedObject]()
    var images = [String]()
    var movies = [String]()
    var generos: String!
    var moviesAll = [String]()
    var moviesApi: Results?
    var imagesApi = [UIImage]()
    var overviewApi = [String]()
    let api = Api()
    
    var arrayzaoImagens = [String]()
    
    var imageNextPage = UIImage()
    var overview = ""
    var titulo = ""
    var averageFilme = ""
    
    let userDefault = DefaultUser()
    @IBOutlet weak var viewLoading: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        self.tableView.isHidden = true
        self.apiMovies()

       
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        if
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        if imagesApi.count > 0 {
            tableView.reloadData()
        }
    }
    
    func apiMovies(){
        
        let language = userDefault.getValue() as! String

        
        let url = "https://api.themoviedb.org/3/discover/movie?api_key=0e971c7b20bccd213d26fd99f69f725e&language=\(language)&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&year=2019"

        api.getData(url, completion: { (data) in
            
            DispatchQueue.main.async {
                self.startIndicator()
                self.moviesApi = data
                self.getImages {
                    print("pronto")
                }
                
                
                self.stopIndicator()
                self.viewLoading.isHidden = true
                self.tableView.isHidden = false
            }
            
        })
    }
    
    func getImages(completion: ()-> Void){
        
        guard let dados = moviesApi?.results else {
            print("error")
            return
        }
        
        for i in dados{
            self.api.getData2(i.poster_path, completion: { (data) in
                self.imagesApi.append(data)
            })
        }
        self.tableView.reloadData()
        completion()
    }


    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rows = moviesApi?.results, rows.count > 0 else {
            return 0
        }
        
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
        
        guard let titleMovie = moviesApi?.results[indexPath.row].title else {
            return cell
        }
        
        cell.nameMovie.text = titleMovie
        
        if imagesApi.count > 0 {
            cell.imageMovie.image = imagesApi[indexPath.row]
        }
    

        return cell

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let data = segue.destination as? MoreFilmController


        data?.imageCorrect = self.imageNextPage
        data?.overview2 = self.overview
        data?.titulo = self.titulo
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if imagesApi.count > 0 {
            self.imageNextPage = imagesApi[indexPath.row]
        }
        
        guard let movies = moviesApi?.results, movies.count > 0 else {
            return
        }
        
        
        self.overview = movies[indexPath.row].overview
        self.titulo = movies[indexPath.row].title
        performSegue(withIdentifier: "pageOverview", sender: nil)
    }
    
    func startIndicator(){
        self.indicator.startAnimating()
    }
    
    func stopIndicator(){
        self.indicator.stopAnimating()
    }
    
    func loadData() {
        
        // Aqui ele recupera os dados referente a entidade escolhida.
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pessoa")
        
        // Aqui ele instancia o container.
        let context = dataManager.persistentContainer.viewContext
        do{
            let results = try context.fetch(fetchRequest)
            let person = results as! [NSManagedObject]
            self.namePerson.text = person[0].value(forKey: "nome") as? String


            
        }catch{
            fatalError("Error is retriving titles items")
        }
    }
    
    

    
}

//
////
////  FirstViewController.swift
////  coreDataTest
////
////  Created by Carlos Fontes on 19/07/19.
////  Copyright © 2019 Carlos Fontes. All rights reserved.
////
//
//import UIKit
//import CoreData
//
//class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//
//    @IBOutlet weak var indicator: UIActivityIndicatorView!
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var namePerson: UILabel!
//
//    var flag = false
//    let dataManager = DataManager()
//    //    var movies = [NSManagedObject]()
//    var images = [String]()
//    var movies = [String]()
//    var generos: String!
//    var moviesAll = [String]()
//    var moviesApi = [[String: Any]]()
//    var imagesApi = [UIImage]()
//    var overviewApi = [String]()
//    let api = Api()
//
//    var arrayzaoImagens = [String]()
//
//    var imageNextPage = UIImage()
//    var overview = ""
//    var titulo = ""
//    var averageFilme = ""
//
//    let userDefault = DefaultUser()
//    @IBOutlet weak var viewLoading: UIView!
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        loadData()
//
//        self.tableView.isHidden = true
//        self.apiMovies()
//
//
//
//    }
//
//    func apiMovies(){
//
//        let language = userDefault.getValue() as! String
//
//
//        let url = "https://api.themoviedb.org/3/discover/movie?api_key=0e971c7b20bccd213d26fd99f69f725e&language=\(language)&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&year=2019"
//        api.getData(url, completion: { (data) in
//            
//            DispatchQueue.main.async {
//                self.startIndicator()
//                self.moviesApi = data
//
//                self.getDatas(data, completion: {
//                    self.tableView.reloadData()
//                    print(self.moviesAll.count)
//
//                    print(self.imagesApi.count)
//                })
//                //                self.tableView.reloadData()
//                self.stopIndicator()
//                self.viewLoading.isHidden = true
//                self.tableView.isHidden = false
//
//            }
//
//        })
//    }
//
//    func getDatas(_ data: [[String: Any]], completion: ()-> Void){
//
//        for i in data {
//            for (chave, valor) in i {
//                if chave == "title"{
//                    self.moviesAll.append(valor as! String)
//                }
//
//                if chave == "poster_path"{
//                    self.api.getData2("\(valor)", completion: { (data2) in
//                        self.imagesApi.append(data2)
//                    })
//
//                }
//
//                if chave == "overview" {
//                    self.overviewApi.append(valor as! String)
//                }
//            }
//        }
//        completion()
//
//    }
//    
//
//
//
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return imagesApi.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCell
//        cell.nameMovie.text = moviesAll[indexPath.row]
//        cell.imageMovie.image = imagesApi[indexPath.row]
//
//        return cell
//
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let data = segue.destination as? MoreFilmController
//
//
//
//        data?.imageCorrect = self.imageNextPage
//        data?.overview2 = self.overview
//        data?.titulo = self.titulo
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        self.imageNextPage = imagesApi[indexPath.row]
//        self.overview = overviewApi[indexPath.row]
//        self.titulo = moviesAll[indexPath.row]
//        performSegue(withIdentifier: "pageOverview", sender: nil)
//    }
//    
//    func startIndicator(){
//        self.indicator.startAnimating()
//    }
//
//    func stopIndicator(){
//        self.indicator.stopAnimating()
//    }
//
//    func loadData() {
//
//        // Aqui ele recupera os dados referente a entidade escolhida.
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pessoa")
//
//        // Aqui ele instancia o container.
//        let context = dataManager.persistentContainer.viewContext
//        do{
//            let results = try context.fetch(fetchRequest)
//            let person = results as! [NSManagedObject]
//            self.namePerson.text = person[0].value(forKey: "nome") as? String
//
//
//
//        }catch{
//            fatalError("Error is retriving titles items")
//        }
//    }
//
//
//
//
//}


