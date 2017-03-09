//
//  AplicationsCollectionViewController.swift
//  TheBestApp
//
//  Created by Fabian David on 6/03/17.
//  Copyright © 2017 FDOS. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class AplicationsCollectionViewController: UICollectionViewController {
    
    //MARK: - Atributos
    // Atributo: appsList, arreglo que contiene las aplicaciones de una determinada categoria en una lista.
    var appsList : [Application] = []
    
    // Atributo: category, categoria a la que pertenecen las aplicaciones mostradas
    var category : Category!

    @IBOutlet weak var applicationCollection: UICollectionView!
    
    
    //MARK: - Metodos principales de la vista.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = category.name
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    // Metodo: numberOfSections, su principal funcion es la de determinar cuantas secciones hay dentro de la coleccion de apps.
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    // Metodo: collectionView, este metodo se encarga de de definir el numero de filas que habra en cada seccion de las aplicaicones.
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appsList.count
    }

    // Metodo: collectionView, teien como finalidad especificar las celdas del collection por cada aplicacion.
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let application = appsList[indexPath.row]
        
        let cell = applicationCollection.dequeueReusableCell(withReuseIdentifier: "applicationCell", for: indexPath) as! ApplicationCell
        
        cell.application = application
        return cell
    }
    
   //Metodo: prepare, (Meotdo de UICollectionViewDataSource) este metodo tiene como funcion principal enviar la informaicon correspondiente de las aplicaciones por cada aplicacion.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsApp"{
            if let index = self.applicationCollection.indexPath(for: sender as! UICollectionViewCell) {
                
                let desVC = segue.destination as! DetailOfTheApplicationController
                desVC.application = appsList[index.row]
            }
        }
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
}
