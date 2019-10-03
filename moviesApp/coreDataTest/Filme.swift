//
//  Filme.swift
//  coreDataTest
//
//  Created by Carlos Fontes on 31/07/19.
//  Copyright © 2019 Carlos Fontes. All rights reserved.
//

import Foundation

struct Filmee: Codable {
    
    let title: String
    let poster_path: String
    let overview: String
    
}

struct Filme2: Codable {
    
    let title: String
    let overview: String
    var poster_path = String()
}


struct ResultsSearch: Codable {
    
    let results: [Filme2]
}

struct Results: Codable {

    let results: [Filmee]

}

