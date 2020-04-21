//
//  ViewController005.swift
//  Gestor
//
//  Created by Jacobo Diego Pita Hernandez on 05/02/2019.
//  Copyright © 2019 Jacobo Diego Pita Hernandez. All rights reserved.
//

import UIKit

class ViewController005: UIViewController {

//- VARIABLES QUE RECIBE VIEWCONTROLLER 003B
   
    var getImage:UIImage?
    var getComment:String?
    
    @IBOutlet weak var imageViewPreview: UIImageView!
    
    @IBOutlet weak var toolbarCustom: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    
     
        
    }
    override func viewWillAppear(_ animated: Bool) {
       
       imageViewPreview.image = getImage!
        
        
    
    }
   
//    ACTIONS
    
    @IBAction func pushCancel(_ sender: Any) {
//
//          let MainStory:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//
//        let vc002 = MainStory.instantiateViewController(withIdentifier: "ViewController002") as! ViewController002
//
//        self.navigationController?.pushViewController(vc002, animated: true)
    }
    
   
    @IBAction func pushDone(_ sender: Any) {
//
//        getComment = "prueba"
//
     let MainStory:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
      let vc002 = MainStory.instantiateViewController(withIdentifier: "ViewController002") as! ViewController002
//
//        vc002.guardarImagen(unaImagen: imageViewPreview.image!, unComentario: getComment!)
       
      
     self.navigationController?.pushViewController(vc002, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PhotoSave" {
//      
//            let ObjetoPantalla2:ViewController002 = (segue.destination as! ViewController002)
//            
//            ObjetoPantalla2.guardarImagen(unaImagen: getImage!, unComentario: "mierda")
       
            
        }
    }
}

