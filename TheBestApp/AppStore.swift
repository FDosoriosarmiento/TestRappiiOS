//
//  AppStore.swift
//  TheBestApp
//
//  Created by Fabian David on 5/03/17.
//  Copyright © 2017 FDOS. All rights reserved.
//

import Foundation
import UIKit
import CoreData

//MARK: - Clase
// Clase AppStore,  esta clase contiene todos la informacion de las aplicaciones y las distintas categorias.
class AppStore: NSObject, NSFetchedResultsControllerDelegate {
    
    
    //MARK: - Atributos
    
    var context : NSManagedObjectContext! = nil
    var fetchResultsController : NSFetchedResultsController<Application>!
    
    //CategoriesList, lista de las categorias que puede tener la AppStore
    var categoriesList : [Category] = []
    
    //AplicationsList, lista de aplicaciones que podemos encontrar en la AppStore
    var applicationsList : [Application] = []
    
    
    
    
    
    //MARK: - Metodos
    
    // Metodo super
    override init() {
        super.init()
        getContext()
    }
    
    
    // Metodo: getContext(), se obtiene de la clase AppDelegate el manejador de objetos para realziar operaciones
    func getContext() {
        if let container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer{
            self.context = container.viewContext
        }
    }
    
    // Metodo: getCoreData, este metodo obtiene todas las aplicaciones y categorias que contiene CoreData
    func getCoreData(){
        if self.context != nil {
            
            // Elementos de la entidad Application
            let requestApplication : NSFetchRequest<Application> = NSFetchRequest(entityName : "Application")
            do {
                self.applicationsList = try context.fetch(requestApplication)
            }
            catch{
                print("No se pueden obtener las aplicaciones: \(error)")
            }
            
            // Elementos de la entidad Application
            let requestCategory :NSFetchRequest<Category> = NSFetchRequest(entityName : "Category")
            do{
                self.categoriesList = try context.fetch(requestCategory)
            }
            catch{
                print("No se pueden obtener las categorias: \(error)")
            }
            
        }
    }
    
    // Metodo: saveChangesInCoreData, guarda las peticiones de contenido,
    // NSManagedObjectContext
    func saveChangesInCoreData()  {
        do{
            try context.save()
        }
        catch{
            print("Error al guardar los cambios: \(error)")
            
        }
    }
    
    
    //Metodo: clearCurrentCoreData, realiza una limpiaza de todos los datos.
    func clearCurretCoreData(){
        
        // Categorias
        let fetchCategory = NSFetchRequest<NSFetchRequestResult>(entityName : "Category")
        let requestCategory = NSBatchDeleteRequest(fetchRequest: fetchCategory)
        
        // Aplicaciones
        let fetchApplications = NSFetchRequest<NSFetchRequestResult>(entityName : "Application")
        let requestApplications = NSBatchDeleteRequest(fetchRequest: fetchApplications)
        do{
            try context.execute(requestCategory)
            try context.execute(requestApplications)
        }
        catch{
            print("Error al guardar los cambios: \(error)")
            
        }
    }
    
    // Metodo: getApplicationsByIdCategory, este metodo recibe como parametro el id de una categoria que define una serie de aplicaciones que pertenecen a ella. Este metodo tiene como funcion principal el encontrar las aplicaciones que pertenecen a una categoria en especificada.
    func getApplicationsByIdCategory(idCategory : String) -> [Application] {
        var applicationCategory : [Application] = []
        
        for app in applicationsList{
            if(app.category == idCategory){
                applicationCategory.append(app)
            }
        }
        return applicationCategory
    }
    
    // Metodo: createNewCategory, este metodo recibe como parametro un diccionario que contiene informacion sobre las categorias. Este metodo tiene como funcion principal el crear una nueva categoria.
    func createNewCategory(categoryDict : [String : Any]) {
        
        let category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context) as? Category
        category?.getCategoryFromJson(categories : categoryDict)
        
        // Validacion para la nueva categoria, tambien se valida su existencia.
        if category?.id != nil {
            if !categoriesList.contains(where: { $0.id == category?.id }) {
                self.categoriesList.append(category!)
                
            }else{
                print("La categoria que se queire agregar ya existe.")
                context.delete(category!)
            }
        }else{
            print("La creacion de la categoria no fue realizada con exito.")
        }
        
    }
    
    // Metodo: requestApplications, metodo que recibe como parametro un diccionario que contiene informaicon sobre las aplicaciones y las categorias. Este metodo tiene como funcion principal el crear las aplicaciones con la informacion del JSON.
    func requestApplications(param : [[String : Any]]) {
        for case let parameter in param {
            
            // Se llama al metodo que limpia la informacio para evitar errores.
            clearCurretCoreData()
            
            // Se analiza el diccionario donde se encuentra una categoria.
            let newCategory =  (parameter["category"] as! [String : Any])["attributes"] as! [ String : Any ]
            
            // Primero se crea una categoria, luego se crea una aplicacion.
            self.createNewCategory(categoryDict: newCategory)
            
            // Creacion de una aplicacion
            let app = NSEntityDescription.insertNewObject(forEntityName: "Application", into: context ) as? Application
            app?.getAppFromJson(applications : parameter)
            
            // Esta validacion sirve para verificar que una aplicacion se ha mapeado correctamente
            if app?.name != nil {
                // Si es asi, la aplicacion es agregada a lista de aplicaciones.
                self.applicationsList.append(app!)
                
            }else{
                print("No se ha podido crear la aplicacion, por favor verifica la informacion.")
            }
        }
        // Se llama al metodo que permite guardar todos los cambios en CoreData
        saveChangesInCoreData()
    }
}
