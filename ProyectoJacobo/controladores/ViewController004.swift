//
//  ViewController004.swift
//  Gestor
//
//  Created by jacobo on 3/5/18.
//  Copyright © 2018 Jacobo Diego Pita Hernandez. All rights reserved.
//

import UIKit

class ViewController004: UIViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {

    // MARK: - ATRIBUTOS
    var blurOnceTime:Bool = true
    
    var altura:CGFloat = 0.0
    
    var visualEffectView = UIView()
    
    var fechaFotoSeleccionadaRecibida:Date?
    
    var soloFotos: [Day] = []
  
    var diaCreacion:Date?
    var visualEffectView2 = UIVisualEffectView()
    var lastContentOffset: CGFloat = 0
 
     // MARK : - IBOULETS
    
    @IBOutlet weak var tabla004: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabla004.delegate = self
        tabla004.dataSource = self
        
       // generaImagenBorrosa()
       // navigationColorAzulManual()
        
        for busquedaFoto in 0..<soloFotos.count {
            
            if soloFotos[busquedaFoto].dateRecord! as Date == fechaFotoSeleccionadaRecibida  {
                
                DispatchQueue.main.async {
                    let index = IndexPath(row: busquedaFoto
                        , section: 0) // use your index number or Indexpath
                    self.tabla004.scrollToRow(at: index,at: .top, animated: true) //here .middle is the scroll position can change it as per your need
                }
            }
            
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        visualEffectView.isHidden = false
        visualEffectView2.isHidden = false
        
        fechaFotoSeleccionadaRecibida = nil
       
    }
   
    override func viewWillDisappear(_ animated: Bool) {
     
        visualEffectView.isHidden = true
        visualEffectView2.isHidden = true
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK : - DELEGADO TABLA
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        
        
        let cell = tabla004.dequeueReusableCell(withIdentifier: "TableViewControllerCell004", for: indexPath) as! TableViewCell004
      
        let img = soloFotos[indexPath.row]
        
        if img.photoAdd != nil {
            
            let rotateImg:UIImage = UIImage (data: img.photoAdd! as Data)!
            
            
            cell.imagenCell004.image = rotateImg
            
            altura = cell.imagenCell004.frame.height
            
            cell.comentariosCell004.text = img.coments
            
        }
        
        let dias = MetodosEstaticos.calculaDiasEntreDosFechas(start: diaCreacion! , end: img.dateRecord! as Date)
        
        cell.tituloCell004.text = MetodosEstaticos.creaStringDias(numeroDia: dias)
         
        
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soloFotos.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

            return 670
        }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if (scrollView.contentOffset.y < self.lastContentOffset && scrollView.contentOffset.y < 0) {
            
            if visualEffectView2.isHidden == false {
                
                UIView.animate(withDuration: 0.5, animations: {
                    
                    self.visualEffectView.alpha = 1
                    self.visualEffectView2.alpha = 0
                    
                }, completion: nil)
                
            }
            
        }
        
       
        
    }
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y == 0 {
            
            
            
        }
       
            
            if visualEffectView2.isHidden == false {
                
                UIView.animate(withDuration: 0.5, animations: {
                    
                    self.visualEffectView.alpha = 1
                    self.visualEffectView2.alpha = 0
                    
                }, completion: nil)
                
            }
       
        
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
       
        self.lastContentOffset = scrollView.contentOffset.y
        
        if visualEffectView2.alpha == 0 {
       
        visualEffectView2.alpha = 0
        visualEffectView2.isHidden = false
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.visualEffectView2.alpha = 1
            self.visualEffectView.alpha = 0
            
        }, completion: nil)
        }
    }

    // MARK: - METODOS UTILES
    func navigationColorAzulManual(){
        
        visualEffectView.frame =  (self.navigationController?.navigationBar.bounds.insetBy(dx: 0, dy: -50).offsetBy(dx: 0, dy: -50))!
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        visualEffectView.backgroundColor = UIColor.gray
        self.navigationController?.navigationBar.insertSubview(visualEffectView, at: 0)
        
        
    }
    
    func generaImagenBorrosa(){
        
        visualEffectView2   = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        visualEffectView2.frame =  (self.navigationController?.navigationBar.bounds.insetBy(dx: 0, dy: -50).offsetBy(dx: 0, dy: -50))!
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        visualEffectView2.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        self.navigationController?.navigationBar.insertSubview(visualEffectView2, at: 0)
        
        visualEffectView2.alpha = 0.0
        
    }
    
    func generaImagenBorrosa2(unaImagen:UIView){
        
      let unaImagen   = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        unaImagen.frame =  (self.navigationController?.navigationBar.bounds.insetBy(dx: 0, dy: -50).offsetBy(dx: 0, dy: -50))!
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        unaImagen.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        self.navigationController?.navigationBar.insertSubview(visualEffectView2, at: 0)
        
       unaImagen.alpha = 0.0
        
    }
    

}
