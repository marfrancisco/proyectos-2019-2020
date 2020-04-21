//
//  ViewController.swift
//  Gestor
//
//  Created by Jacobo Diego Pita Hernandez on 8/4/18.
//  Copyright © 2018 Jacobo Diego Pita Hernandez. All rights reserved.
//

import UIKit
import CoreData
import AudioToolbox

class ViewController: UIViewController, UITableViewDelegate,
UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    //    MARK: - ATRIBUTOS
    
    var tasks : [Task] = []
    var fetchResultController : NSFetchedResultsController<Task>!
    
    //    MARK: - IBOULETS
    
    @IBOutlet weak var tableView: UITableView!
    
   
    //    MARK: - IBACTION
  
    
    @IBAction func addTask(sender: AnyObject){
        
    let alert = UIAlertController(title: "Nueva Tarea",
                                      message: "Añade un título",
                                      preferredStyle: .alert)
        
    let saveAction = UIAlertAction(title: "Guardar",
                                       style: .default,
                                       handler: { (action:UIAlertAction) -> Void in
                                        
                                        //Guardamos el texto del textField en el array tasks y recargamos la table view
                                        
                                        let textField = alert.textFields!.first
                                        //     tasks.append(textField!.text!)
                                        self.guardaTareaEnCoreData(nombreTarea: textField!.text!)
                                        
                                        
        })
        
        let cancelAction = UIAlertAction(title: "Cancelar",
                                         style: .default) { (action: UIAlertAction) -> Void in
        }
        alert.addTextField {
            (textField: UITextField) -> Void in
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert,
                animated: true,
                completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "pantallaDosSegue" {
            
            let indice = tableView.indexPathForSelectedRow?.row
            let task = tasks[indice!]
            
            
            var fechaAdecuada = Date()
            
            if task.opcFinishCount {

              
                fechaAdecuada = task.dateFinishCount! as Date

            }
            
            let dias:Int = MetodosEstaticos.calculaDiasEntreDosFechas(start: task.createDate! as Date, end: fechaAdecuada)
            let mensaje:String = MetodosEstaticos.creaStringDias(numeroDia: dias)
            
            let ObjetoPantalla2:ViewController002 = segue.destination as! ViewController002
            
            ObjetoPantalla2.nombreDiaRecibido = mensaje
            ObjetoPantalla2.titulo = task.name
            ObjetoPantalla2.idTask = task.idTask
         
        }
    }
    
    
    //    MARK: - FUNCIONES DE TABLA
    
    func modificarNombreTarea(tareaSeleccionada:IndexPath){
        
        let nombreTareaSelecionada = (self.tasks[tareaSeleccionada.row].name!)
        
        let alert = UIAlertController(title: "Editar tarea",
                                      message: "Modifica el nombre",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Guardar",
                                       style: .default,
                                       handler: { (action:UIAlertAction) -> Void in
                                        
                                        
                                        let textField = alert.textFields!.first
                                        
                                        self.tasks[tareaSeleccionada.row].name = textField!.text!
                                        
                                        self.actualizarDatos()
                                        
        })
        
        let cancelAction = UIAlertAction(title: "Cancelar",
                                         style: .default) { (action: UIAlertAction) -> Void in
        }
        alert.addTextField {
            (textField: UITextField) -> Void in
            textField.text = nombreTareaSelecionada
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert,
                animated: true,
                completion: nil)
        
    }

    func borrarTarea(tareaSeleccionada:IndexPath){
        
        if self.tasks[tareaSeleccionada.row].timerActive {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate.magnitude)
            
            let alert = UIAlertController(title: "", message: "No se puede eliminar mientras el cronometro esté activo.", preferredStyle: UIAlertController.Style.actionSheet)
            
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
            alert.view.tintColor = UIColor.red
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        let contexto = self.conexion()
        let tareaParaBorrar = self.fetchResultController.object(at: tareaSeleccionada)
        contexto.delete(tareaParaBorrar)
        
        do {
            try contexto.save()
        } catch {
            print("Ha habido un error al BORRAR")
        }
        
    }
    //    MARK: - FUNCIONES DE INICIO/FIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = UITableView.automaticDimension;
  
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        actualizarDatos()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        recuperaTareasDeCoreData()
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //    MARK: - CONEXION BASE DE DATOS
    
    func actualizarDatos() {
        do {
            try conexion().save()
            
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
        }
        
    }
    
    func recuperaTareasDeCoreData(){
        
        let contexto = conexion()
        
        let fetchRequest : NSFetchRequest<Task> = Task.fetchRequest()
        let orderbyDate = NSSortDescriptor(key: "useDate", ascending: false)
        fetchRequest.sortDescriptors = [orderbyDate]
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchResultController.delegate = self
        
        do {
            try fetchResultController.performFetch()
            tasks = fetchResultController.fetchedObjects!
            
        } catch let error as NSError {
            print ("No se pudo recuperar",error.localizedDescription)
        }
        
        tableView.reloadData()
    }
 
    func guardaTareaEnCoreData(nombreTarea:String){
        
        //        Busca la entidad tarea en BBDD y lo convierte en objeto
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: conexion())!
        let task = Task(entity: entity, insertInto: conexion())
        //      1.  propiedad que establece la posición del dashboar
        task.stateDashboard = 1
        //        2. Propiedad que establece el nombre de la tarea
        task.name = nombreTarea
        //        3. Propiedad que establece la fecha de creacion
        let currentDate = NSDate()
        task.createDate = currentDate
        //        4. Propiedad que le asigna un id único a la tarea
        task.idTask = UUID().uuidString
        
        //        añadimos al Array
        tasks.append(task)
        
        
    }
    
    // MARK: - METODOS TABLA
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let botonEditar = UIContextualAction(style: .normal, title: "Editar") { (action, view, handler) in
            self.modificarNombreTarea(tareaSeleccionada: indexPath)
        }
    
        botonEditar.image = UIImage(named: "iconoEditar002")
        botonEditar.backgroundColor = .blue
        let configuration = UISwipeActionsConfiguration(actions: [botonEditar])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
        
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action =  UIContextualAction(style: .normal, title: "Borrar", handler: { (action,view,completionHandler ) in
            
            self.borrarTarea(tareaSeleccionada: indexPath)
            
            completionHandler(true)
        })
        action.image = UIImage(named: "iconoBorrar002")
        action.backgroundColor = .red
        let confrigation = UISwipeActionsConfiguration(actions: [action])
        
        return confrigation
    }

    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath:
        IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:
            "CellCustom", for: indexPath) as! CustomTableViewCell
        
        let task = tasks[indexPath.row]
        
        var fechaAdecuada = Date()
        
        if task.opcFinishCount {
            fechaAdecuada = task.dateFinishCount! as Date
        }
        
        let dias:Int = MetodosEstaticos.calculaDiasEntreDosFechas(start: task.createDate! as Date, end:fechaAdecuada)
        
        cell.labelCell.text = task.name
        cell.labelCell02.text = MetodosEstaticos.creaStringDias(numeroDia: dias)
        
       
        if task.timerActive {
            cell.indicadorVisual.alpha = 1.0
        }
        else {
            cell.indicadorVisual.alpha = 0.0
        }
        
        cell.labelCell.alpha = 1
        
        if task.opcFinishCount { cell.labelCell.alpha = 0.5}
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let task = tasks[indexPath.row]
        
        task.useDate = Date() as NSDate
        
        actualizarDatos()
        
        self.tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
               
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cell =  cell as! CustomTableViewCell
        cell.animacion()
    }
   
   
    //    MARK: - METODOS UTILES PUBLICOS
    
   
    func fechaCorrecta(indice:IndexPath)->Date {
        
        var fechaAdecuada = Date()
        
        if tasks[indice.row].opcFinishCount {
            
            fechaAdecuada = tasks[indice.row].dateFinishCount! as Date
        }
        
        return fechaAdecuada
        
    }
    
    func dias(indice:IndexPath)->Int {
       
        var fechaFinal = Date()
     
        
        if tasks[indice.row].opcFinishCount == true {
            
            fechaFinal = tasks[indice.row].dateFinishCount! as Date
            
        }
        else {
            
            fechaFinal = Date()
            
        }
        
        let dias:Int = MetodosEstaticos.calculaDiasEntreDosFechas(start: tasks[indice.row].createDate! as Date, end: fechaFinal)
        
        return dias
    }
    
    //    MARK: - NSFetchController Delegado
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
        
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        default:
            tableView.reloadData()
        }
        
        self.tasks = controller.fetchedObjects as! [Task]
    }
   
    //    MARK: - MÉTODOS ÚTILES
    
    func conexion()-> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
        
    }

}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

    
    

