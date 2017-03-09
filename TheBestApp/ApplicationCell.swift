//
//  ApplicationCell.swift
//  TheBestApp
//
//  Created by Fabian David on 6/03/17.
//  Copyright © 2017 FDOS. All rights reserved.
//

import UIKit

class ApplicationCell: UICollectionViewCell {
    
    //MARK: - Atributos
    
    // Atributo: applicationImage, este atributo hace referencia a la imagen de la aplicacion en la vista.
    @IBOutlet weak var applicationImage: UIImageView!
    
    // Atributo: applicationNameLabel, este atributo hace referencia al nombre de la aplicacion en la vista.
    @IBOutlet weak var applicationNameLabel: UILabel!
    
    // Atributo: applicationDevLabel, este atributo hae referencia al nombre del desarrollador de la aplicacion en la vista.
    @IBOutlet weak var applicationDevLabel: UILabel!
    
    // Atributo: application, llama al metodo updateView
    var application : Application! {
        didSet{
            self.updateView()
        }
    }
    
    //MARK: - Metodos
    
    // Metodo: updateiew, su principal funcion es la de refrescar la vista de las aplicaciones mostrando sus nombres, desarrolladores y respectivas imagenes.
    func updateView(){
        self.applicationNameLabel.text  =   application.name
        self.applicationDevLabel.text   =   application.developer
        
        if let image = application.imageURL {
            let service = Service(url: URL(string:image)!)
            service.downloadImage({ (imageData) in
                let image = UIImage(data: imageData as Data)
                DispatchQueue.main.async {
                    self.applicationImage.image = image
                }
            })
        }
    }
   
}
