//
//  Service.swift
//  TheBestApp
//
//  Created by Fabian David on 6/03/17.
//  Copyright © 2017 FDOS. All rights reserved.
//

import Foundation
import SystemConfiguration

//MARK: - Clase
// Clase Service, clase que permite interactuar con funciones de red de los dispositivos.
class Service{
    
    
    
    //MARK: - Atributos
    // Variable: configuration, variable que permite identificar la configuraicond el SessionURL
    lazy var configuration: URLSessionConfiguration = URLSessionConfiguration.default
    
    // Variable: session, varibale que permite identificar la sesion.
    lazy var session: URLSession = URLSession(configuration: self.configuration)
    
    // Variable: URL.
    let url: URL
    
    
    
    //MARK: - Metodos
    // Metodo constructor del URL
    init(url: URL) {
        self.url = url
    }
    
    // Metodo dowloadImage, su funcion principal es obtener una imagen a partir de una url definida.
    //Función empleadas para descargar imagenes dada la URL
    typealias imageDataHandler = ((Data) -> Void)
    
    func downloadImage(_ completion: @escaping imageDataHandler) {
        let request = URLRequest(url: self.url)
        let dataTask = session.dataTask(with: request, completionHandler: { (data, response, error) in
            if error == nil {
                if let httpResponse = response as? HTTPURLResponse {
                    switch (httpResponse.statusCode) {
                    case 200:
                        if let data = data {
                            completion(data)
                        }
                    default:
                        print(httpResponse.statusCode)
                    }
                }
            } else {
                print("Error: \(error?.localizedDescription)")
            }
        })
        
        dataTask.resume()
    }
}



extension Service
{
    // Metodo: parseJSONFromData, su funcion principal es la de obtener los datos del JSON y mapearlos.
    static func parseJSONFromData(_ jsonData: Data?) -> [String : AnyObject]? {
        if let data = jsonData {
            do {
                let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : AnyObject]
                return jsonDictionary
                
            } catch let error as NSError {
                print("Error con los datos del JSON \(error.localizedDescription)")
            }
        }
        return nil
    }
    
    // Metodo: isConnectedToNetwork, su funcion principal es verificar si el dispositivo en el que se ejecuta la app esta conectado a internet.
    static func isConnectedToNetwork() -> Bool{
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}
