//
//  Category.swift
//  TheBestApp
//
//  Created by Fabian David on 5/03/17.
//  Copyright © 2017 FDOS. All rights reserved.
//

import Foundation
import UIKit
import CoreData

//MARK: - Clase
// Esta clase identifia una categoria a la que puede pertenecer una aplicacion.
class Category : NSManagedObject {
    
    
    //MARK: - Atributos
    // Declaracion de atributos de la clase Category.
    
    
    // Atributo: name, identifica el nombre de la categoria a la que la aplicacion califica
    @NSManaged var name : String?
    
    // Atributo: image, identifica la imagen de la categoria a la que
    @NSManaged var image : UIImage?
    
    // Atributo: id, representa el identificador unico de cada categoria
    @NSManaged var id : String?
    
    
    
    
    
    //MARK: - Metodos
    // Declaracion de los metodos de la clase Category
    
    // Metodo: getCategoryFromJson
    // Este metodo recibe como parametro un diccionario de datos que trae la informacion del json correspondiente a una categoria.
    // No retorna y permite crear una categoria.
    func getCategoryFromJson(categories : [String:Any]) {
        
        guard let id = categories["im:id"] as? String, let nameC = categories["label"] as? String else {
            return
        }
        self.id = id
        self.name = nameC
    }
    
}
