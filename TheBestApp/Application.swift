//
//  Application.swift
//  TheBestApp
//
//  Created by Fabian David on 5/03/17.
//  Copyright © 2017 FDOS. All rights reserved.
//

import Foundation
import UIKit
import CoreData

//MARK: - Clase
// Esta clase identifia una aplicacion de la AppStore
class Application : NSManagedObject{
    
    
    //MARK: - Atributos
    // Declaracion de atributos de la clase Application.
    
    
    // Atributo: category, identifica la categoria a la que pertenece la aplicacion.
    @NSManaged var category : String!
    
    // Atributo: developer, identifica al desarrollador de la aplicacion.
    @NSManaged var developer : String!
    
    // Atributo: image, identifica la imagen de la aplicacion
    @NSManaged var image : NSData!
    
    // Atributo: imageURL, identifica la direccion donde se encuentra la imagen de la aplicacion
    @NSManaged var imageURL : String?
    
    // Atributo: name, identifica el nombre de la aplicacion
    @NSManaged var name : String!
    
    // Atributo: summary, identifica la descripcion de la aplicacion
    @NSManaged var summary : String!
    
    
    
    
    //MARK: - Metodos
    // Declaracion de los metodos de la clase Application.
    
    
    // Metodo: getAppFromJson
    // Este metodo recibe como parametro un diccionario de datos que trae la informacion del json correspondiente a una aplicacion.
    // No retorna y permite crear una aplicacion.
    func getAppFromJson(applications: [String: Any]) {
        guard let name = applications["im:name"] as? [String : String], let images = applications["im:image"] as? [[String : Any]], let summa = applications["summary"] as? [String : String], let deve = applications["im:artist"] as? [String : Any]
            else {
                return
        }
        let newCategoryApplication =  (applications["category"] as! [String : Any])["attributes"] as! [String : Any]
        guard let categoryId = newCategoryApplication["im:id"] as? String
            else {
                return
        }
        let url = images[2]
        self.imageURL = url["label"] as! String!
        self.name = name["label"]!
        self.developer = deve["label"]! as! String
        self.summary = summa["label"]
        self.category = categoryId
    }
}
