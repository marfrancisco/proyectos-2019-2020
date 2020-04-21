//
//  CollectionViewController001.swift
//  Gestor
//
//  Created by jacobo on 2/5/18.
//  Copyright © 2018 Jacobo Diego Pita Hernandez. All rights reserved.
//

import UIKit
import CoreData



class CollectionViewController001: UICollectionViewController, UICollectionViewDelegateFlowLayout  {

    // MARK : - ATRIBUTOS
   
    //
    
    var soloFotos: [Day] = []
    
    var fotoSeleccionadas:[Day] = []
    var diaCreacion:Date?
    var fechaFotoSeleccionada:Date?
    
    private var visualEffectView = UIView()
    private var comparandoFotos:Bool = false
    
    // MARK: - INICIO/FIN
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.delegate = self
        collectionView?.dataSource = self
        
//        collectionView?.allowsMultipleSelection = true

//        navigationColorAzulManual()

    }
    
    @objc func iniciarSeleccionFotosComparacion(){
        
        comparandoFotos = true
     
        let botonIniciaComparacion = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(accionIniciarFotosComparacion))
        let botonCancelarComparacion = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(restauraMenuComparacion))
         self.navigationItem.setRightBarButtonItems([botonIniciaComparacion,botonCancelarComparacion], animated: true)
        
    }
    @objc func deshacerComparacion(){
        
        
    }
    @objc func accionIniciarFotosComparacion(){
        
        if fotoSeleccionadas.count>=2{
            
            self.performSegue(withIdentifier: "collectionToVC006",sender:self)
        }
    }
    @objc func restauraMenuComparacion(){
        
        comparandoFotos = false
        
        if (fotoSeleccionadas.count>0) {
           fotoSeleccionadas.removeAll()
        }
        
        let botonIniciarMenuComparacion = UIButton(type: .custom)
        botonIniciarMenuComparacion.setImage(UIImage(named: "iconoComparacion"), for: .normal)
        botonIniciarMenuComparacion.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        botonIniciarMenuComparacion.addTarget(self, action: #selector(iniciarSeleccionFotosComparacion), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: botonIniciarMenuComparacion)
        
        self.navigationItem.setRightBarButtonItems([item1], animated: true)
        
        collectionView?.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
       
        
        
        let itemSize = UIScreen.main.bounds.width/3 - 3
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 5, right: 0)
        layout.itemSize = CGSize (width: itemSize, height: itemSize)
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        
        visualEffectView.isHidden = false
        restauraMenuComparacion()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        visualEffectView.isHidden = true
        restauraMenuComparacion()
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK : - ACTION
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "collectioToView004" {
            
            let objViewController:ViewController004 = segue.destination as! ViewController004
            
            objViewController.soloFotos = self.soloFotos
            objViewController.diaCreacion = diaCreacion
            objViewController.fechaFotoSeleccionadaRecibida = fechaFotoSeleccionada
        }
        
        if segue.identifier == "collectionToVC006" {
            
            let objViewController:ViewController006 = segue.destination as! ViewController006
            objViewController.fotosComparacion = fotoSeleccionadas
            objViewController.diaCreacion = diaCreacion
            
            
        }
    }

    // MARK: - UICollectionViewDataSource
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenSize = UIScreen.main.bounds
        
        return CGSize(width: (screenSize.width*0.94)/3, height:220)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }

  
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return soloFotos.count
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCollectionView", for: indexPath) as! ImageCollectionViewCell
        
        
        
        if comparandoFotos {
            
            cell.eiquetaNumeroComparado.isHidden = false
        
            
            if  (comprubaQueNoEstáSeleccionado(unaFoto: soloFotos[indexPath.row].photoAdd!) == false ) {
                fotoSeleccionadas.append(soloFotos[indexPath.row])
                self.collectionView?.reloadItems(at: [indexPath])
           
            }
        }
        else
        {
            cell.eiquetaNumeroComparado.isHidden = true
            let fotoSeleccionada = soloFotos[indexPath.row]
            self.fechaFotoSeleccionada = fotoSeleccionada.dateRecord! as Date
            self.performSegue(withIdentifier: "collectioToView004",sender:self)
            self.collectionView?.reloadItems(at: [indexPath])
        }
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCollectionView", for: indexPath) as! ImageCollectionViewCell
        
        
        if comparandoFotos {
            cell.eiquetaNumeroComparado.isHidden = false
            
            cell.eiquetaNumeroComparado.text = String(format: "%i", fotoSeleccionadas.count)
            
        
        } else {
            cell.eiquetaNumeroComparado.isHidden = true
            
            
        }
        
        cell.setNeedsDisplay()
        
        let img = soloFotos[indexPath.row]
        
        if img.photoAdd != nil {
            
            let rotateImg:UIImage = UIImage (data: img.photoAdd! as Data)!
            
            
            let result:UIImage = MetodosEstaticos.imageRotatedByDegrees(oldImage: rotateImg, deg: 90 )
            
            cell.imagenColeccion.image = result
            
            
            let dias = MetodosEstaticos.calculaDiasEntreDosFechas(start: diaCreacion! as Date, end: img.dateRecord! as Date)
            cell.tituloFoto.text = MetodosEstaticos.creaStringDias(numeroDia: dias)
            
         
            
        }
        
        return cell
    }
    
    // MARK : - METODOS UTILES
    
    func navigationColorAzulManual(){
        
        visualEffectView.frame =  (self.navigationController?.navigationBar.bounds.insetBy(dx: 0, dy: -50).offsetBy(dx: 0, dy: -50))!
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        visualEffectView.backgroundColor = UIColor.gray
        self.navigationController?.navigationBar.insertSubview(visualEffectView, at: 0)
        
        
    }
    // MARK: METODO UTILES
    
    func comprubaQueNoEstáSeleccionado(unaFoto:NSData) -> Bool {
        
        var existe:Bool = false
        
        for recorrido in 0..<fotoSeleccionadas.count {
            
            if fotoSeleccionadas[recorrido].photoAdd == unaFoto {
                
                existe = true
            }
        }
        return existe
        
    }
    
   
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
    
}
