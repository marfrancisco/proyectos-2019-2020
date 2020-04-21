//
//  CustomTableViewCell002.swift
//  Gestor
//
//  Created by Jacobo Diego Pita Hernandez on 27/4/18.
//  Copyright © 2018 Jacobo Diego Pita Hernandez. All rights reserved.
//

import UIKit

class CustomTableViewCell002: UITableViewCell {


    //    MARK: - IBOLETS

    @IBOutlet var label001: UILabel!
    @IBOutlet var label002: UILabel!
    @IBOutlet var imagen: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Swift 4.2 onwards
        return UITableView.automaticDimension
        
        // Swift 4.1 and below
      
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
//    func generaImagenBorrosa(){
//
//       let visualEffectView   = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
//        visualEffectView.frame =  (self.imageVIewCell002.bounds.insetBy(dx: 0, dy: -50).offsetBy(dx: 0, dy: -50))
//
//ç
    
//        visualEffectView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
//        self.imageVIewCell002.insertSubview(visualEffectView, at: 0)
//
//    }
}
