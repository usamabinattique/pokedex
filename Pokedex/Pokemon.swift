//
//  Pokemon.swift
//  Pokedex
//
//  Created by S3 Technology on 08/02/2017.
//  Copyright © 2017 S3 Technologies. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name : String!
    private var _pokedexId : Int!
    private var _type: String!
    private var _description: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionText: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL: String!
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLevel: String{
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }

        var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }

    var defense: String {
        if _defense == nil {
            _defense = nil
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
 
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
 
    var nextEvolutionText: String {
        if _nextEvolutionText == nil {
            _nextEvolutionText = ""
        }
        return _nextEvolutionText
    }
    
    var name: String {
        return _name
    }
    var pokedexId: Int {
        return _pokedexId
    }
    
    init (name: String, pokedexId: Int){
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(URL_Base)\(URL_Pokemon)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetail(completed: @escaping DownloadComplete) {
       //created get request
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            if let dict = response.result.value as? Dictionary<String, AnyObject>{
                if let weight = dict["weight"] as? String{
                    self._weight = weight
                }
                if let height = dict["height"] as? String {
                    self._height = height
                }
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                if let defense = dict ["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                if let types = dict["types"] as? [Dictionary<String, String>], types.count > 0 {
                    for type in types {
                        if let typeValue =  type ["name"]{
                        self._type != nil ? (self._type! += "/\(typeValue.capitalized)") : (self._type = "\(typeValue.capitalized)")
                        }
                    }
              
                } else {
                    self._type = ""
                }
                if let discArr = dict ["descriptions"] as? [Dictionary<String, AnyObject>]{
                    if let url = discArr[0]["resource_uri"]{
                        let descURL = "\(URL_Base)\(url)"
                        
                        Alamofire.request(descURL).responseJSON(completionHandler: { (response) in
                            if let descDict = response.result.value as? Dictionary<String, AnyObject>{
                                if let description = descDict["description"] as? String{
                                    let newDesciption = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._description = newDesciption
                                    print(newDesciption)
                                }
                            }
                            completed()
                        })
                    }
                } else {
                    self._description = ""
                }
                if let evolution = dict["evolutions"] as? [Dictionary<String, AnyObject>], evolution.count > 0 {
                    if let nextEvo = evolution[0]["to"] as? String {
                        if nextEvo.range(of: "mega") == nil {
                            self._nextEvolutionName = nextEvo
                            if let uri = evolution[0]["resource_uri"] as? String {
                                
                                let newString = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoId = newString.replacingOccurrences(of: "/", with: "")
                    
                                self._nextEvolutionId = nextEvoId
                                
                                if let lvlExist = evolution[0]["level"] as? Int{

                                    self._nextEvolutionLevel = "\(lvlExist)"
                                }
                                else {
                                    self._nextEvolutionLevel = ""
                                }
                            }
                        }
                    }
                    print (self.nextEvolutionLevel)
                    print (self.nextEvolutionName)
                    print(self.nextEvolutionId)
                }
            }
          completed()
        }
    }
}





//if let name = types[0]["name"] {
//    self._type = name.capitalized
//}
//if types.count > 1 {
//    for x in 1..<types.count {
//        if let name = types[x]["name"] {
//            self._type! += "/\(name.capitalized)"
//        }
//    }
//}
//print (self._type)
//




















