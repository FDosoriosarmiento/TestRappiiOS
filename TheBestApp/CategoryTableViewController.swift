//
//  CategoryTableViewController.swift
//  TheBestApp
//
//  Created by Fabian David on 6/03/17.
//  Copyright © 2017 FDOS. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController, NSFetchedResultsControllerDelegate { /*UIViewController, UITableViewDataSource, UITableViewDelagate*/
    let defaults = UserDefaults.standard
    
    
    //MARK: - Atributos
    // Declaracion de los atributos de la clase para la vista de Categorias
    
    // Variable: URL, direccion del JSON que contiene toda la informacion
    let url  = URL(string : "https://itunes.apple.com/us/rss/topfreeapplications/limit=20/json")
    
    // Variable: PlayStore, instancia de la clase AppStore que alberga la informaicon de las aplicaciones y las categorias.
    var appStore : AppStore!
    
    // Variable: semaforo, esta variable sirve para identificar y escuchar la finalizacion de las tareas.
    var semaforo = DispatchSemaphore( value: 0 )
    
    // Variable: categoryTableViewController, identifica al table view que muestra las categorias.
    @IBOutlet var categoryTableViewController: UITableView!
    
    
    
    
    //MARK: - Metodos principales de la vista
    
    // Metodo principal de la vista
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Inicializacion de la AppStore contenedor de las aplicaciones y las categorias
        self.appStore = AppStore()
        
        // Se llama al metodo getInfo() que trae toda la informacion
        self.getInfo()
        semaforo.wait()
        
        self.appStore.categoriesList = appStore.categoriesList.sorted(by: { (cat1 , cat2) -> Bool in
            return cat1.name! < cat2.name!
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: - Metodos
    // Metodo: getInfo, este meotdo tiene como funcion principal cargar toda la informacion del JSON o de CoreData
    func getInfo() {
        if Service.isConnectedToNetwork() {
            let service = URLSession.shared.dataTask(with: url!) { (data, reponse, error) in
                if(error != nil){
                    print(error.debugDescription)
                }else{
                    let json = Service.parseJSONFromData(data)
                    let optionalData = json?["feed"] as! [String : Any]
                    let enter = optionalData["entry"] as! [[String : Any]]
                    self.appStore.requestApplications(param: enter)
            }
                self.semaforo.signal()
        }
            service.resume()
        }else{
            appStore.getCoreData()
            self.semaforo.signal()
        }
        
    }
    
    // Metodo: prepare, (Meotdo de UITableViewDataSource) este metodo tiene como funcion principal enviar la informaicon correspondiente de las aplicaciones por cada categoria.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "appsPerCategory"{
            
            if let index = self.tableView.indexPath(for: sender as! UITableViewCell) {
                let ap = segue.destination as! AplicationsCollectionViewController
                ap.appsList = appStore.getApplicationsByIdCategory(idCategory: appStore.categoriesList[index.row].id!)
                ap.category = appStore.categoriesList[index.row]
            }
        }
        
    }
    
    
    
    
    //MARK: - UITableViewDaraSource
    
    // Metodo que especifica cuantas secciones hay
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Dada una seccion, cuantas filas debe contener esa seccion indicada
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.appStore.categoriesList.count
        //return self."arry de apps".count
    }
    
    // Para todas y cada una de las celdas que deben ser mostradas en pantalla
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = appStore.categoriesList[indexPath.row]
        let cellId = "categoryCell"
        
        let cellCategory = categoryTableViewController.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CategoryCell
        cellCategory.categoryNameLabel.text = category.name
        
        //let app = arrayDeApps[indexPath.row]
        //let cellId = "AppCell"
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: <#T##IndexPath#>)
        //cell.textLabel?.text = arrayDeApps.name
        //cell.imageView?.image = arrayDeApps.image
        return cellCategory
    }
}
