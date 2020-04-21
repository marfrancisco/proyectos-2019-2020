//
//  CustomTableViewCell.swift
//  Gestor
//
//  Created by Jacobo Diego Pita Hernandez on 9/4/18.
//  Copyright © 2018 Jacobo Diego Pita Hernandez. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet var indicadorVisual: UIView!
    
    @IBOutlet var cristalFondo: UIView!
    @IBOutlet weak var labelCell: UILabel!
    @IBOutlet weak var labelCell02 : UILabel!
    
    // MARK:- ACCIONES
  
    
    // MARK:- VARIABLES
    
        
    var visualEffectView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        generaImagenBorrosa()
        
        self.indicadorVisual.frame.size.height = 50
        self.indicadorVisual.frame.size.width = 50
       
        
        self.indicadorVisual.layer.cornerRadius = self.indicadorVisual.frame.size.width / 2
        self.indicadorVisual.clipsToBounds = true
      
//        var imagenFondoCelda:UIImageView?
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func generaImagenBorrosa(){
        
      
        
       
        visualEffectView   = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        visualEffectView.frame =  cristalFondo.bounds
        
        indicadorVisual.frame = CGRect(x: 50, y: 30, width: self.contentView.frame.size.width-100, height: self.contentView.frame.size.height-100)
      
        visualEffectView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
       
        cristalFondo.insertSubview(visualEffectView, at: 0)
        
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func  animacion() {
        
        let rotationTransform = CATransform3DScale(CATransform3DIdentity, 2.5, 2.5, 1.5)
        self.indicadorVisual.layer.transform = rotationTransform
        
        UIView.animate(withDuration: 2.25, delay: 0, options:
            [.curveEaseOut,.autoreverse,.repeat], animations: {
                
                self.indicadorVisual.layer.transform = CATransform3DIdentity
        }, completion: nil)
 
 }
  
}
