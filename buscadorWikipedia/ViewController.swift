//
//  ViewController.swift
//  buscadorWikipedia
//
//  Created by Ramiro y Jennifer on 06/05/21.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var buscarTextField: UITextField!
    @IBOutlet weak var WebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func buscarWikipedia(palabras: String){
        if let urlAPI = URL(string: "https://es.wikipedia.org/w/api.php?action=query&prop=extracts&format=json&titles=\(palabras.replacingOccurrences(of: " ", with: "%20"))"){
            
            let peticion = URLRequest(url: urlAPI)
            
            let tarea = URLSession.shared.dataTask(with: peticion) { (datos, respuesta, error) in
                if error != nil{
                    print(error?.localizedDescription)
                }
                else{
                    do {
                        let objJson = try JSONSerialization.jsonObject(with: datos!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        let querySubJson = objJson["query"] as! [String: Any]
                        let pagesSubJson = querySubJson["pages"] as! [String: Any]
                        let pageId = pagesSubJson.keys
                        let llaveExtracto = pageId.first!
                        
                        let idSubJson = pagesSubJson[llaveExtracto] as! [String: Any]
                        let extracto = idSubJson["extract"] as? String
                        
                        DispatchQueue.main.async {
                            self.WebView.loadHTMLString(extracto ?? "<h1>No se obtuvieron resultados</h1>", baseURL: nil)
                        }
                    } catch {
                        print("Error al procesar el Json \(error.localizedDescription)")
                    }
                }
            }
            tarea.resume()
        }
    }

    
    @IBAction func buscarButton(_ sender: UIButton) {
        buscarTextField.resignFirstResponder()
        guard let palabraBuscar = buscarTextField.text else {
            return
        }
        buscarWikipedia(palabras: palabraBuscar)
    }
    

}

