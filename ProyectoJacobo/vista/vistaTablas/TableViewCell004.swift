//
//  TableViewCell004.swift
//  Gestor
//
//  Created by jacobo on 3/5/18.
//  Copyright © 2018 Jacobo Diego Pita Hernandez. All rights reserved.
//

import UIKit

class TableViewCell004: UITableViewCell {

    // MARK: - ATRIBUTOS
  
    // MARK: - IBOULETS
    
    @IBOutlet weak var imagenCell004: UIImageView!
    
    @IBOutlet var containerTitleLabel: UIView!
    @IBOutlet weak var tituloCell004: UILabel!
    
    @IBOutlet var containerComentLabel: UIView!
    @IBOutlet weak var comentariosCell004: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configLabelsContainr()
      
        
        // Initialization code
    }

    func configLabelsContainr() {
        containerTitleLabel.layer.masksToBounds = true
        containerTitleLabel.layer.cornerRadius = 20
        
        addBlurArea(area: containerTitleLabel.bounds, style: UIBlurEffect.Style.regular, view: containerTitleLabel)
        containerComentLabel.layer.masksToBounds = true
        containerComentLabel.layer.cornerRadius = 10
        
        addBlurArea(area: containerComentLabel.bounds, style: UIBlurEffect.Style.regular, view: containerComentLabel)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    func addBlurArea(area: CGRect, style: UIBlurEffect.Style, view:UIView) {
        let effect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: effect)
        
        let container = UIView(frame: area)
        blurView.frame = CGRect(x: 0, y: 0, width: area.width, height: area.height)
        container.addSubview(blurView)
        container.alpha = 0.8
       
         view.insertSubview(blurView, at: 0)
        
        
       
//        containerTitleLabel.backgroundColor = UIColor.white.withAlphaComponent(0.8)
    
    }
    
    
}
