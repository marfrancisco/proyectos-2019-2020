//
//  ViewController006.swift
//  Gestor
//
//  Created by Jacobo Diego Pita Hernandez on 04/04/2019.
//  Copyright © 2019 Jacobo Diego Pita Hernandez. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController006: UIViewController {


    
    @IBOutlet var imagen001: UIImageView!
    @IBOutlet var imagen002: UIImageView!
    
    @IBOutlet var etiquetaDia01: UILabel!
    @IBOutlet var etiquetaDia02: UILabel!
    
    @IBOutlet var contenedorImagenMovimiento: UIView!
    
    public var fotosComparacion:[Day] = []
    public var diaCreacion:Date?
    
    var numSecuenciaDiapositiva:Int = 0
    var iniciandoAnimacion:Bool = true
    var muestraFechas:Bool = true
    var startStopAnimacion = true
    
    var diapositivaA:Int = 1
    var diapositivaB:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if fotosComparacion.count > 2 {
            numSecuenciaDiapositiva = 1
            
            diapositivaA = 0
            diapositivaB = 1
        }
        
        let contenidoEtiquetaDia001 = MetodosEstaticos.calculaDiasEntreDosFechas(start: diaCreacion! as Date, end: fotosComparacion[diapositivaA].dateRecord! as Date)
        
        let contenidoEtiqueta002 = MetodosEstaticos.calculaDiasEntreDosFechas(start: diaCreacion! as Date, end: fotosComparacion[diapositivaB].dateRecord! as Date)
        
        etiquetaDia01.text = MetodosEstaticos.creaStringDias(numeroDia: contenidoEtiquetaDia001)
        
        etiquetaDia02.text = MetodosEstaticos.creaStringDias(numeroDia: contenidoEtiqueta002)
        
        etiquetaDia02.alpha = 0
        
        self.imagen001.frame = CGRect (x:0, y:self.imagen001.frame.origin.y, width: self.imagen001.frame.size.width, height: self.imagen001.frame.size.height)
        
        imagen001.image = UIImage (data: fotosComparacion[diapositivaA].photoAdd! as Data)
        imagen002.image = UIImage (data: fotosComparacion[diapositivaB].photoAdd! as Data)
        
        
       
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
   
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            self.inicioAnimacion()
        }
        
     
    }

    override func viewWillDisappear(_ animated: Bool) {
        
        startStopAnimacion = false
        
    }
    @objc func doubleTapped() {
        
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        
        if startStopAnimacion {
            
            generator.impactOccurred()
            startStopAnimacion = false
            
        }
        else
        {
            generator.impactOccurred()
            startStopAnimacion = true
            actualizaFotos()
        }
    }
    
    func actualizaEtiqueta(unIndice:Int)->Int{
        
        let dias = MetodosEstaticos.calculaDiasEntreDosFechas(start: diaCreacion! as Date, end: fotosComparacion[unIndice].dateRecord! as Date)
        
        return dias
    }

    func cambiaDiapositiva(){
        
        if (numSecuenciaDiapositiva == fotosComparacion.count-1) {
            
            numSecuenciaDiapositiva = 0
        } else {
            
            numSecuenciaDiapositiva = numSecuenciaDiapositiva+1
        }
        
    }
    func actualizaFotos() {
        
        if startStopAnimacion {
            
            if iniciandoAnimacion {
                inicioAnimacion()
                print ("principio")
            }
            else
            {
                finalizaAnimacion()
                print("final")
            }
        }
    }
    func inicioAnimacion(){
        let screen = UIScreen.main.bounds
        UIView.animate(withDuration: 4, delay: 0, options: [.allowUserInteraction], animations: {
            
            self.etiquetaDia01.alpha = 0
            self.etiquetaDia02.alpha = 1
            
            self.contenedorImagenMovimiento.frame = CGRect (x:screen.width, y:self.contenedorImagenMovimiento.frame.origin.y, width: self.contenedorImagenMovimiento.frame.size.width-screen.width, height: self.contenedorImagenMovimiento.frame.size.height)
            
            self.imagen001.frame = CGRect (x:-screen.width, y:self.imagen001.frame.origin.y, width: self.imagen001.frame.size.width, height: self.imagen001.frame.size.height)
            
            
            
        }, completion:{ (t) -> Void in
            self.iniciandoAnimacion = false
//          2
            self.cambiaDiapositiva()
//          3
            self.actualizaFotos()
//          4
            self.imagen001.image = UIImage (data: self.fotosComparacion[self.numSecuenciaDiapositiva].photoAdd! as Data)
             self.etiquetaDia01.text = MetodosEstaticos.creaStringDias(numeroDia: self.actualizaEtiqueta(unIndice: self.numSecuenciaDiapositiva))
        })
    }
    func finalizaAnimacion(){
        let screen = UIScreen.main.bounds
        UIView.animate(withDuration: 4, delay: 0, options: [.allowUserInteraction], animations: {
            
            self.etiquetaDia01.alpha = 1
            self.etiquetaDia02.alpha = 0
            
            self.contenedorImagenMovimiento.frame = CGRect (x:0, y:self.contenedorImagenMovimiento.frame.origin.y, width: screen.width, height: self.contenedorImagenMovimiento.frame.size.height)
            
            self.imagen001.frame = CGRect (x:0, y:self.imagen001.frame.origin.y, width: self.imagen001.frame.size.width, height: self.imagen001.frame.size.height)
            
            
        }, completion:{ (t) -> Void in
            self.iniciandoAnimacion = true
            self.cambiaDiapositiva()
            self.actualizaFotos()
           
            self.imagen002.image = UIImage (data: self.fotosComparacion[self.numSecuenciaDiapositiva].photoAdd! as Data)
            self.etiquetaDia02.text = MetodosEstaticos.creaStringDias(numeroDia: self.actualizaEtiqueta(unIndice: self.numSecuenciaDiapositiva))
        })
        
    }
    
    @IBAction func muestraFechas(_ sender: Any) {
        
        if muestraFechas {
            self.etiquetaDia02.isHidden = true
            self.etiquetaDia01.isHidden = true
            muestraFechas = false
        }
        else
        {
            self.etiquetaDia02.isHidden = false
            self.etiquetaDia01.isHidden = false
            muestraFechas = true
        }
        
    }
    
    //    MARK: - METODOS UTILES
    func convierteEnRedondo(unaEtiqueta:UILabel)  {
        unaEtiqueta.layer.cornerRadius = unaEtiqueta.frame.size.width / 2
       unaEtiqueta.clipsToBounds = true
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UILabel {
    
    func roundedImage() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    
}
