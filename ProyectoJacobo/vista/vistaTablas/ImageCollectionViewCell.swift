//
//  ImageCollectionViewCell.swift
//  Gestor
//
//  Created by jacobo on 2/5/18.
//  Copyright © 2018 Jacobo Diego Pita Hernandez. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet var eiquetaNumeroComparado: UILabel!
    
    @IBOutlet weak var imagenColeccion: UIImageView!
    
    @IBOutlet weak var tituloFoto: UILabel!
  
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        imagenColeccion.layer.borderColor = UIColor.blue.cgColor
        isSelected = false
        
        imagenColeccion.frame = CGRect(x: 0, y: 0, width: 100, height: 300 )
        
        self.eiquetaNumeroComparado.isHidden = true
        
        
    }
    override var isSelected: Bool {
        didSet {
            
//            eiquetaNumeroComparado.isHidden = isSelected ? false : true
            self.eiquetaNumeroComparado.isHidden = true
            if isSelected {
//            imagenColeccion.layer.borderWidth = isSelected ? 10 : 0
            
                self.eiquetaNumeroComparado.isHidden = false
            
       
            }
        
    }
    
}
}
