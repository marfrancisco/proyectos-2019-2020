//
//  ViewController007.swift
//  Gestor
//
//  Created by Jacobo Diego Pita Hernandez on 17/04/2019.
//  Copyright © 2019 Jacobo Diego Pita Hernandez. All rights reserved.
//

import UIKit

class ViewController007: UITableViewController {

    
    //    MARK : VARIABLES
    
    var tareaActual:Task?
    var currentDay:[Day] = []
    
    
    @IBOutlet var switchFotosTimeLine: UISwitch!
    @IBOutlet var switchDetenerTiempo: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let rightButton = self.editButtonItem
        rightButton.title = "Ajustes"
        self.navigationItem.rightBarButtonItem = rightButton
        rightButton.isEnabled = false
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white

        switchFotosTimeLine.isOn = tareaActual!.opcShowPhotoInDays
        switchDetenerTiempo.isOn = tareaActual!.opcFinishCount
  
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
        switch indexPath.section {
        case 1:
            
            switch indexPath.row {
            case 1:
                
                if (!tareaActual!.timerActive) {            self.reiniciarContador()
                } else {
                
                }
           
            default: break
            }
        default:
            break
        }
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 2
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
//        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.gray
//
        let header = view as! UITableViewHeaderFooterView
       header.textLabel?.font = UIFont(name: "Futura", size: 12)!
       header.textLabel?.textColor = UIColor.lightGray
    
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
       
        switch section {
        case 0:
            return 1
            
        case 1:
            return 2
        
        default:
            break
        }
        
       return 1
    }
    
   
    @IBAction func switchDetenerTiempo(_ sender: Any) {
        
        if switchDetenerTiempo.isOn {
            
            if self.tareaActual!.timerActive {
                
                let alert = UIAlertController(title: "", message: "No se puede detener la tarea mientras el cronometro esté activo.", preferredStyle: UIAlertController.Style.actionSheet)
                
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
                alert.view.tintColor = UIColor.red
                self.present(alert, animated: true, completion: nil)
                
                switchDetenerTiempo.isOn = false
                
                return
            }
            
            tareaActual?.opcFinishCount = true
            tareaActual?.dateFinishCount = NSDate()
            actualizarDatos()
            
        }
        else
        {
            tareaActual?.opcFinishCount = false
            actualizarDatos()
        }
    }
    
    func reiniciarContador(){
        
        let fechaActual = Date()
        let dias:Int = MetodosEstaticos.calculaDiasEntreDosFechas(start: tareaActual!.createDate! as Date, end: fechaActual as Date)
        
        let mensaje = String(format: "Se borrarán  %i anotaciones añadidas durante %i días", currentDay.count,dias)
   
        let myalert = UIAlertController(title: "REINICIAR CONTADOR", message: mensaje, preferredStyle: UIAlertController.Style.actionSheet)
        
        myalert.addAction(UIAlertAction(title: "Aceptar", style: .destructive) { (action:UIAlertAction!) in
            self.tareaActual?.createDate = fechaActual as NSDate
            
            self.borrarTodos()
            self.actualizarDatos()
        })
        myalert.addAction(UIAlertAction(title: "Cancelar", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel")
        })
        
        self.present(myalert, animated: true)

    }
    //   MARK : METODOS UTILES
    
    
    // MARK: IBACTIONS
     
     @IBAction func switchMostrasFotosTimeLine(_ sender: Any) {
        
        if switchFotosTimeLine.isOn {
            
            tareaActual?.opcShowPhotoInDays = true
            actualizarDatos()
        }
        else
        {
            tareaActual?.opcShowPhotoInDays = false
            actualizarDatos()
        }
     }
    
    //     MARK: METODOS PERSISTENCIA
    func borrarTodos(){
        for recorrido in 0..<self.currentDay.count {
            ViewController002.conexion().delete(self.currentDay[recorrido])
        }
    }
    
    func actualizarDatos() {
        do {
            try ViewController002.conexion().save()
            
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
        }
        
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
  

}
