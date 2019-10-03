//
//  Api.swift
//  coreDataTest
//
//  Created by Carlos Fontes on 25/07/19.
//  Copyright © 2019 Carlos Fontes. All rights reserved.
//

import UIKit


class Api {

    let session = URLSession.shared
    var arrayImages = [String]()

    
    func getData(_ url: String, completion: @escaping (Results) -> Void){
        
        let urlApi = URL(string: url)!
        
        let task = session.dataTask(with: urlApi) { data, response, error in
            completion(self.tratarResposta(data: data, response: response, error: error)! )
        }
        task.resume()
    }
    
    func getData2(_ valor: String, completion: @escaping (UIImage) -> Void) {
        print(valor)
        
        if let url = NSURL(string: "https://image.tmdb.org/t/p/w500\(valor)"){
        
            let task2 = session.dataTask(with: url as URL) { data, response, error in
                completion(self.tratarRespostaImagens(data2: data, response: response, error: error)!)
            }
            
            task2.resume()
            
        }
        
    }
    
    func tratarResposta(data: Data?, response: URLResponse?, error: Error?) -> Results?{

        let decoder = JSONDecoder()

        do {
            let results = try decoder.decode(Results.self, from: data!)
            return results
        } catch {
            print(error)
        }
        
        print("chegando aq")
        return nil
    }
    
    func tratarRespostaImagens(data2: Data?, response: URLResponse?, error: Error?) -> UIImage?{
        
        if let err = error {
                print("Error: \(err)")
                return nil
        }
        
        
        if let http = response as? HTTPURLResponse {
            if http.statusCode == 200 {
                let downloadedImage = UIImage(data: data2!)
                return downloadedImage
            }
        }
        
        return UIImage()
    }
    
    
    
}

