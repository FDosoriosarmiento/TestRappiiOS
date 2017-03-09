//
//  DetailOfTheApplicationController.swift
//  TheBestApp
//
//  Created by Fabian David on 6/03/17.
//  Copyright © 2017 FDOS. All rights reserved.
//

import UIKit

class DetailOfTheApplicationController: UIViewController {
    
    //MARK: - Atributos
    
    // Atributo: ApplicationNameLabel, identifica al nombre de la aplicacion en la vista.
    @IBOutlet weak var applicationNameLabel: UILabel!
    
    // Atributo: applicationDevLabel, este atributo hace referencia al nombre del desarrollador de la aplicacion en la vista.
    @IBOutlet weak var applicationDevLabel: UILabel!
    
    // Atributo: applicationSummaryLabel, este atributo hace referencia a la descripcion de la aplicacion en la vista.
    @IBOutlet weak var applicationSummaryLabel: UILabel!
    
    // Atributo: applicationImage, este atributo hace referencia a la imagen de la aplicacion en la vista.
    @IBOutlet weak var applicationImage: UIImageView!

    // Atributo: application, variable que identifica la aplicacion
    var application: Application!
    
    
    
    //MARK: - Metodos
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        applicationNameLabel.text = application.name
        applicationDevLabel.text = application.developer
        applicationSummaryLabel.text = application.summary
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
