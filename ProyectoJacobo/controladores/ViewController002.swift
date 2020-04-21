//
//  ViewController002.swift
//  Gestor
//
//  Created by Jacobo Diego Pita Hernandez on 19/4/18.
//  Copyright © 2018 Jacobo Diego Pita Hernandez. All rights reserved.
//


import UIKit
import CoreData
import AudioToolbox


class ViewController002: UIViewController, UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource, NSFetchedResultsControllerDelegate, UITabBarDelegate, UIScrollViewDelegate,  UISearchResultsUpdating, UIGestureRecognizerDelegate
{
   
    //    MARK: - ATRIBUTOS
    

    public static let colorVerde:UIColor = UIColor(red: 46/255, green: 192/255, blue: 31/255, alpha: 0.95)
    public static let colorRojo:UIColor = UIColor(red: 224/255, green: 33/255, blue: 2/255, alpha: 0.95)
    
    public static let generator = UIImpactFeedbackGenerator(style: .heavy)
    
    var editandoComentario:Bool = false
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var intentosFallidos:Int = 0
    
    var indiceSeleccionado = IndexPath()
    
    var fechaFotoSeleccionada:Date?
    
    var imagenSeleccionadaPreview:UIImage? = nil
    
    var cronoEnMarcha:Bool = false
    var crono = 0
    var timer = Timer()
    var timerAnimacion = Timer()
    var hrs = 0
    var min = 0
    var sec = 0
    var milliSecs = 0
    var diffHrs = 0
    var diffMins = 0
    var diffSecs = 0
    var diffMilliSecs = 0
    var totalTimer:String = "00:00:00"
    
    var comentarioConFoto:String?
    
    var pruebaRelacion:[Task] = []
    var idTask:String?
    var currentDays:[Day] = []
    var currentDaysFiltrado = [Day]()
    var currentTask:Task?
    var nombreDiaRecibido:String?
    var titulo:String?
    var fetchResultController:NSFetchedResultsController<Day>!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    //   MARK: - IBOULETS
    
   
    @IBOutlet var gestoSwipeDerecha: UISwipeGestureRecognizer!
    @IBOutlet var cronoLabel: UILabel!
    @IBOutlet var buttonStartStop: UIButton!
    @IBOutlet var buttonPause: UIButton!
    @IBOutlet var botonCheck: UIButton!
    
    @IBOutlet var dashView001: UIView!
    @IBOutlet var dashView002: UIView!
    @IBOutlet var dashView003: UIView!
    
    @IBOutlet var pageControl001: UIPageControl!
    @IBOutlet var scrollView001: UIScrollView!
    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var diaEnCurso: UILabel!
  //  @IBOutlet strong var textBox: UITextField!
    @IBOutlet var cajaTextoComentario: UITextField!
    @IBOutlet var cajaTextoCheck: UITextField!
    
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet var textTimeTotal: UILabel!
    
   
    
    //    MARK: - IBACTIONS
    
    @IBAction func incluirCheckEnComentario(_ sender: Any) {
        
        cajaTextoCheck.saltoHorizontalDerecha()
        ViewController002.generator.impactOccurred()
        
        if (currentTask?.checkPoint?.isEmpty==false)
        {
            self.cajaTextoComentario.text = currentTask?.checkPoint
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                self.preparaVistaParaEditarComentario()
                self.cajaTextoComentario.saltoHorizontalIzquierda()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                    self.cajaTextoComentario.superRebotar()
                }
            }
        }
    }
    
    @IBAction func StartStopAction(_ sender: Any) {
        
        buttonStartStop.rebotar()
        ViewController002.generator.impactOccurred()
        
        if (cronoEnMarcha) {
            
            cronoEnMarcha = false
            cambiaColorStartStop(unColor: ViewController002.colorVerde)
            buttonStartStop.setTitle("Inicio", for: .normal)
            currentTask?.timerActive = cronoEnMarcha
            guardaCometario(unComentario: MetodosEstaticos.imprimeTiempo(Horas: hrs, Minutos: min, Segundos: sec, Comentario: cajaTextoComentario.text!), crono: true)
           
//            Restaura tiempo
            parserTotalTime()
            
            timer.invalidate()
            resetearTimer()
            crono = 0
            cronoLabel.text = "00:00"
            }
        
        else {
            
            cronoEnMarcha = true
            
            cambiaColorStartStop(unColor: ViewController002.colorRojo)
            buttonStartStop.setTitle("Finalizar", for: .normal)
            
            currentTask?.timerActive = cronoEnMarcha
       
            puestaEnMarchaCrono()
            }
        
    }
    func puestaEnMarchaCrono(){
        
        if UserDefaults.standard.object(forKey: "savedTime:"+"\(String(describing: idTask))") != nil  {
            
            return
        }
        
        self.resetearTimer()
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController002.updateLabels(t:))), userInfo: nil, repeats: true)
        
        let shared = UserDefaults.standard
        
        shared.set(Date(), forKey: "fechaInicioCrono:"+"\(String(describing: idTask))")
        
        print("Guardado fechaInicioCrono",UserDefaults.standard.object(forKey: "fechaInicioCrono:"+"\(String(describing: idTask))") as! Date)
    }
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl001.currentPage) * scrollView001.frame.size.width
        scrollView001.setContentOffset(CGPoint(x:x, y:0), animated: true)
        
    }

    @IBAction func addText(_ sender: Any) {
        
        if cajaTextoComentario.text?.isEmpty == false  {
         //   guardaCometario()
        }
    }
    
    @IBAction func addCheck(_ sender: Any) {
        
        botonCheck.rebotar()
        
        if (currentTask?.checkPoint?.isEmpty == false) {
            
                  guardaCometario(unComentario: cajaTextoCheck.text!, crono: false)
        }
        
        else {
            
            // ANIMACIÓN
            cajaTextoCheck.shake()
            
            intentosFallidos += 1
            
            if intentosFallidos > 3 { AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            }
        }
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "pantallaTresSegue" {

            let vc003: ViewController003b = segue.destination as! ViewController003b
          
            vc003.getCurrentDay = diaEnCurso.text!
            vc003.getComment = comentarioConFoto
            vc003.currentTask = self.currentTask
            
            var imagenes = currentDays
            var soloFotos: [Day] = []
            
            for recorrido in 0..<imagenes.count {
                
                if imagenes[recorrido].photoAdd != nil {
                    soloFotos.append(imagenes[recorrido])
                }
            }
            
            if currentTask?.opcShowPhotoInDays == true && soloFotos.count>0 {
          
                if imagenSeleccionadaPreview != nil {
                
                  vc003.getLastPhoto = imagenSeleccionadaPreview
                }
                else {
                    vc003.getLastPhoto = fotoReciente()
                }
            }
                
            else {
                if soloFotos.count>0 {
                    vc003.getLastPhoto = fotoReciente() }
            }
        }
        
        if segue.identifier == "segueCollectionView" {
          
            let objCollectionVC:CollectionViewController001 = segue.destination as! CollectionViewController001
//                objCollectionVC.imagenes = self.currentDays
                objCollectionVC.diaCreacion = self.currentTask!.createDate! as Date
            
            for recorrido in 0..<currentDays.count {
                
                if currentDays[recorrido].photoAdd != nil {
                    objCollectionVC.soloFotos.append(self.currentDays[recorrido])
                }
            }
            
        }
        
        if segue.identifier == "view002TovView004" {
            
            let objViewController:ViewController004 = segue.destination as! ViewController004
            objViewController.diaCreacion = self.currentTask!.createDate! as Date
            objViewController.fechaFotoSeleccionadaRecibida = fechaFotoSeleccionada
            
            for recorrido in 0..<currentDays.count {
                
                if currentDays[recorrido].photoAdd != nil {
                    objViewController.soloFotos.append(self.currentDays[recorrido])
                }
            }
        }
        
        if segue.identifier == "view002ToView007" {
            let objViewController:ViewController007 = segue.destination as! ViewController007
            
            objViewController.tareaActual = currentTask
            objViewController.currentDay = currentDays
            
        }
    }
    
    @objc func accionCamara(){
       
        if !currentTask!.opcFinishCount {
        
        DispatchQueue.main.async {
              self.performSegue(withIdentifier: "pantallaTresSegue",sender: self)
            
        }
        }
    }

    func configurePreviewLastPhoto (){
        
    }
    
    //    MARK: - FUNCIONES DE INICIO/FIN
   
    override func viewDidLoad() {
        super.viewDidLoad()

        gestoSwipeDerecha.delegate = self
       cajaTextoCheck.addGestureRecognizer(gestoSwipeDerecha)
        
        tabla.delegate = self
        tabla.dataSource = self
        
        tabla.rowHeight = UITableView.automaticDimension
        tabla.estimatedRowHeight = UITableView.automaticDimension
        
         tabla.register(UITableViewCell.self, forCellReuseIdentifier: "CustomTableViewCell002")
        cajaTextoComentario.delegate = self
        cajaTextoCheck.delegate = self
        
       
        self.title = titulo!

        let rightButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(accionCamara))
        self.navigationItem.rightBarButtonItem = rightButton
        
        scrollView001.delegate = self
        scrollView001.contentSize = CGSize(width: self.view.frame.width*3, height: self.scrollView001.frame.height)
        pageControl001.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)
        
        dashboardPlace()
        dashboard003Order()
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewWillDisappear(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(pauseWhenBackground), name: UIApplication.willTerminateNotification, object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(viewWillDisappear(_:)), name: .UIApplicationWillResignActive, object: nil)
      
//        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: .UIApplicationDidBecomeActive, object: nil)

     
        textTimeTotal.text = ""
        textTimeTotal.textColor = UIColor.white
        
        cajaTextoComentario.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
       
        
        let hideKeyboard = UITapGestureRecognizer(target: self, action: #selector(navigationBarTap))
        hideKeyboard.numberOfTapsRequired = 1
        navigationController?.navigationBar.addGestureRecognizer(hideKeyboard)

        configuracionInicialSearchBarController()
    
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    func configuracionInicialSearchBarController(){
     
        searchController.searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchController.searchBar.barTintColor = UIColor.darkGray
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.backgroundColor = UIColor.darkGray
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
         UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = convertToNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: UIColor.white])
     
        self.definesPresentationContext = true
        self.tabla.tableHeaderView = searchController.searchBar
        self.tabla.contentOffset = CGPoint(x: 0, y: searchController.searchBar.frame.height)
    tabla.keyboardDismissMode = .onDrag
    }
    @objc func navigationBarTap(_ recognizer: UIGestureRecognizer) {
        view.endEditing(true)
        // OR  USE  yourSearchBarName.endEditing(true)
        
    }
    @objc func pauseWhenBackground() {
     
        if cronoEnMarcha {
            self.timer.invalidate()
            let shared = UserDefaults.standard
            shared.set(Date(), forKey: "savedTime:"+"\(String(describing: idTask))")
            
            cronoEnMarcha = false
            self.milliSecs = 0
            self.sec = 0
            self.min = 0
            self.hrs = 0
            
        }
    }
    @objc func willEnterForeground() {
       
        if (UserDefaults.standard.object(forKey: "savedTime:"+"\(String(describing: idTask))") as? Date) != nil {
          
            guard let fechaInicioCrono = UserDefaults.standard.object(forKey: "fechaInicioCrono:"+"\(String(describing: idTask))") as? Date else {
                
                resetearTimer()
                
                return
            }
           
            (diffHrs, diffMins, diffSecs) = MetodosEstaticos.getTimeDifference(startDate: fechaInicioCrono)
            
            self.refresh(hours: diffHrs, mins: diffMins, secs: diffSecs)
           
        
            if (!cronoEnMarcha) {
                StartStopAction(AnyClass.self)
                showActivityIndicatory(uiView: cronoLabel)
                cronoLabel.textColor = UIColor.clear
                buttonStartStop.isEnabled = false
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        if (cronoEnMarcha) {
            pauseWhenBackground()
        } 
        guardadoGlobal()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
      recuperaDias(unIdTask: idTask!)
        
        self.tabBarController?.tabBar.isHidden = false
  recuperaCheckCustom()
        
        willEnterForeground()
        
        recuperaPosicionDashboard()
        
        parserTotalTime()
        
        if imagenSeleccionadaPreview != nil {
            imagenSeleccionadaPreview = nil
        }
        
        deshabilitaEntradaDatos(unBooleano: !currentTask!.opcFinishCount)
        
        var fechaAdecuada = Date()
        
        if currentTask!.opcFinishCount {
            
            fechaAdecuada = currentTask?.dateFinishCount as! Date
        }
        let dias = MetodosEstaticos.calculaDiasEntreDosFechas(start: currentTask?.createDate as! Date, end: fechaAdecuada)
        let mensaje = MetodosEstaticos.creaStringDias(numeroDia: dias)
        self.diaEnCurso.text = mensaje
        
        animacionMostrarCrono()
        
    }
    
    func desapareceTeclado(unTextfield: UITextField) {
        unTextfield.resignFirstResponder()
    }
    func recuperaPosicionDashboard() {
        
        let pageSaved:Int16 = (currentTask?.stateDashboard)!
        
        mueveDashBoard(posicion: Int(pageSaved))
    }
    func mueveDashBoard(posicion:Int){
        
        let paginaGuardada = CGFloat(posicion)
        
        let scrollPoint = CGPoint(x: view.frame.size.width*paginaGuardada, y: 0)
        scrollView001.setContentOffset(scrollPoint, animated: true)
        pageControl001.currentPage = Int(posicion)
         
    }
    func seconds2Timestamp(intSeconds:Int)->String {
        
        let mins:Int = intSeconds/60
        let hours:Int = mins/60
        let secs:Int = intSeconds%60
        
        let strTimestamp:String
        
        totalTimer =  String(format: "%04d:%02d:%02d", self.hrs, self.min, self.sec)
        
        if hours < 1 {
            
            strTimestamp =  ((mins<10) ? "0" : "") + String(mins) + ":" + ((secs<10) ? "0" : "") + String(secs)
            
        }
        else {
            
            strTimestamp = ((hours<10) ? "0" : "") + String(hours) + ":" + ((mins<10) ? "0" : "") + String(mins)
            
        }
        
        return strTimestamp
    }
    // MARK: - TIMER
    
    func resetearTimer() {
        
        self.removeSavedDate()
        timer.invalidate()
        self.cronoLabel.text = "00:00"
        self.milliSecs = 0
        self.sec = 0
        self.min = 0
        self.hrs = 0
    }
    
    @objc func updateLabels(t: Timer) {
        
        if (self.sec >= 59) {
           
            self.min += 1
            self.sec = 0
            
            if (self.min >= 59) {
                self.hrs += 1
                self.min = 0
            }
            
        } else {
            self.sec += 1
        }
        
        updateLabelCrono()
    }
    func updateLabelCrono () {
        
        totalTimer =  String(format: "%04d:%02d:%02d", self.hrs, self.min, self.sec)
        
        if (activityIndicator.isAnimating) {
            
            activityIndicator.stopAnimating()
            cronoLabel.textColor = UIColor.orange
            buttonStartStop.isEnabled = true
            
        }
        
        self.cronoLabel.text = MetodosEstaticos.convierteTiempoTextoExacto(horas: self.hrs, minutos: self.min, segundos: self.sec)
    }
    
    
    func refresh (hours: Int, mins: Int, secs: Int) {
        
        self.hrs += hours
        self.min += mins
        self.sec += secs
        
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController002.updateLabels(t:))), userInfo: nil, repeats: true)
        
      
    }
    
    func removeSavedDate() {
        if (UserDefaults.standard.object(forKey: "savedTime:"+"\(String(describing: idTask))") as? Date) != nil {
            UserDefaults.standard.removeObject(forKey: "savedTime:"+"\(String(describing: idTask))")
            UserDefaults.standard.removeObject(forKey: "fechaInicioCrono:"+"\(String(describing: idTask))")
        }
    }
    
    func cambiaColorStartStop(unColor:UIColor) {
        if (self.cronoEnMarcha) {
            self.buttonStartStop.backgroundColor = UIColor.red
            self.cronoLabel.textColor = UIColor.orange
        }
        else {
            self.buttonStartStop.backgroundColor = UIColor.green
            self.cronoLabel.textColor = UIColor.white
        }
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut], animations: {
            self.buttonStartStop.backgroundColor = unColor
        }, completion: nil)
    }
    
    // MARK : - METODOS DELEGADO TABBAR
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
       
        if item.tag == 1 {
            let coloredSquare = UIView()
            coloredSquare.backgroundColor = UIColor.blue
            coloredSquare.frame = CGRect(x: 0, y: 0, width:UIScreen.main.bounds.width , height: UIScreen.main.bounds.height)
            self.view.addSubview(coloredSquare)
            UIView.animate(withDuration: 2.0, delay: 0, options: [.repeat, .autoreverse], animations: {
                coloredSquare.frame = CGRect(x: 120, y: 220, width: 100, height: 100)}, completion: nil)
            
            DispatchQueue.main.async {
                
                self.performSegue(withIdentifier: "segueCollectionView",sender: self)
                coloredSquare.layer.removeAllAnimations()
                coloredSquare.removeFromSuperview()
            }
        }
        if item.tag == 2 {
            
            DispatchQueue.main.async {
              self.performSegue(withIdentifier: "view002ToView007",sender: self)
            }
        }
    }
    func parserTotalTime (){
        
        textTimeTotal.alpha = 1.0
        
        var hora:Int = 0
        var minuto:Int = 0
        var segundo:Int = 0
        
        if (currentDays.count>=0) {
            for numero in currentDays.enumerated() {
                if numero.element.totalTimer != nil {
                    let eachTime = numero.element.totalTimer
                    let numbers:[String] =  (eachTime!.components(separatedBy: ":"))
                    hora += Int(numbers[0])!
                    minuto += Int(numbers[1])!
                    segundo += Int(numbers[2])!
                }
            }
            let minutosString:Int = minuto*60
            let horasString:Int = (hora * 60) * 60
            let segundosString:Int = segundo
            
            if (segundo == 0 && minuto == 0 && hora == 0) {
                textTimeTotal.alpha = 0.0
                return
            }
            let totalSecond:Int64 = Int64(minutosString + horasString + segundosString)
            let hours = totalSecond / 3600
            let minutes = (totalSecond / 60) % 60
            let seconds = totalSecond % 60
            
            textTimeTotal.text = String(format:"%0.2d:%0.2d:%0.2d \nTiempo total",hours,minutes,seconds)
        }
    }
    @objc func animacionMostrarCrono(){
        if currentTask!.timerActive {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.00) {
                
                self.mueveDashBoard(posicion: 2)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.cronoLabel.superRebotar()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.00) {
                    
                    if !self.timerAnimacion.isValid {
                        
                        self.recuperaPosicionDashboard()
 
                        self.timerAnimacion = Timer.scheduledTimer(timeInterval: 5, target: self, selector: (#selector(ViewController002.animacionMostrarCrono)), userInfo: nil, repeats: true)
                    }
                }
            }
        }
    }
    // MARK: - UISearchResultsUpdating method
  
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchController.isActive = false;
        searchController.resignFirstResponder()
        
    }
    func filterContent(for searchText: String) {
        currentDaysFiltrado = currentDays.filter({ (current) -> Bool in
            let match = current.coments?.range(of: searchText, options: .caseInsensitive)
           return match != nil
        })
    }
    func updateSearchResults(for searchController: UISearchController) {
        // If the search bar contains text, filter our data with the string
        if !searchController.isActive {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.4, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                    
                    self.tabla.contentOffset = CGPoint(x: 0, y: searchController.searchBar.frame.height)
                    
                }, completion: nil)
            }
        }
        guard !searchController.searchBar.text!.isEmpty else {
            
            self.title = titulo!
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            DispatchQueue.main.async {
                self.tabla.reloadData()
            }
            return
        }
        
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            // Reload the table view with the search result data.
            DispatchQueue.main.async {
                 self.tabla.reloadData()
            }
        }
    }
    // MARK: - METODOS DELEGADOS UISEARCHBAR
    
   
    //    MARK: - METODOS DELEGADOS TEXTFIELD
     func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if timerAnimacion.isValid { timerAnimacion.invalidate()}

        self.view.endEditing(true)
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (cajaTextoComentario == textField) {
           
        }
        if (cajaTextoCheck == textField) {
            
        }
        
        return true
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if (cajaTextoComentario == textField) {
            
            comentarioConFoto = cajaTextoComentario.text!
         
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    
        if timerAnimacion.isValid { timerAnimacion.invalidate()}
        
        textField.textColor = UIColor.white.withAlphaComponent(1.0)
        
        if (cajaTextoComentario == textField) {
          
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (cajaTextoComentario == textField){
            
            comentarioConFoto = cajaTextoComentario.text!
            
        } else if (cajaTextoCheck == textField) {
            
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if editandoComentario == false {
        
            if (cajaTextoComentario == textField && cajaTextoComentario.text?.isEmpty == false) {
                
                guardaCometario(unComentario: cajaTextoComentario.text!, crono: false)
                
            }
            if (cajaTextoCheck == textField && cajaTextoCheck.text?.isEmpty == false) {
                
                guardaCheck(unCheck: cajaTextoCheck.text!)
            }
        }
        else {
            
            if (currentDays[indiceSeleccionado.row].totalTimer == nil) { currentDays[indiceSeleccionado.row].coments = cajaTextoComentario.text
            }
            else {
                var tiempo = [Int]()
                tiempo = MetodosEstaticos.parseaTiempo(unTiempoEnString: currentDays[indiceSeleccionado.row].totalTimer!)
                currentDays[indiceSeleccionado.row].coments = MetodosEstaticos.imprimeTiempo(Horas: tiempo[0], Minutos: tiempo[1], Segundos: tiempo[2], Comentario: cajaTextoComentario.text!)
            }
            actualizarDatos()            
            editandoComentario = false
            tabla.reloadData()
        }
        cajaTextoComentario.text = nil
        textField.resignFirstResponder()
        return true
    }
    // MARK:- METODOS DELEGADOS SCROLLVIEW Y PAGECONTROL EVE
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer is UISwipeGestureRecognizer || gestureRecognizer is UIRotationGestureRecognizer) {
            return true
        } else {
            return false
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if (scrollView == scrollView001) {
        
         if timerAnimacion.isValid { timerAnimacion.invalidate()}
        
        escondeTeclado()
        
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView001.frame.size.width)
        pageControl001.currentPage = Int(pageNumber)
        
        currentTask?.stateDashboard = Int16(Int(pageNumber))
        }
    }
    //    MARK:- VISTA CONTROLADOR
    func recuperaCheckCustom() {
        if (currentTask?.checkPoint?.isEmpty == false) {
            
            cajaTextoCheck.text = currentTask?.checkPoint
            cajaTextoCheck.textColor = UIColor.white.withAlphaComponent(1.0)
        }
    }
    func recuperaDias(unIdTask:String){
   
        let taskFetch: NSFetchRequest<Task> = Task.fetchRequest()
        taskFetch.predicate = NSPredicate (format: "%K == %@", #keyPath(Task.idTask),unIdTask)
        do {
            let results = try ViewController002.conexion().fetch(taskFetch)
            currentTask = results.first
            currentDays = (currentTask?.days?.sortedArray(using: [NSSortDescriptor(key: "dateRecord", ascending: false)]) as! [Day])
        // aquí debería ir la operación que separa los días por secciones y tablas   pruebaTabla()
        } catch let error as NSError {
            print("Ha habido un error en el fetch",error.localizedDescription)
        }
        
       
        tabla.reloadData()
    }
    func guardarImagen(unaImagen:UIImage, unComentario:String?){
        let nota = Day(context: ViewController002.conexion())
        nota.dateRecord = NSDate()
        nota.coments = unComentario!
        let imageData = unaImagen.jpegData(compressionQuality: 0.25) as Data?
        nota.photoAdd = imageData! as NSData
        if let task = self.currentTask,
            let notas = task.days?.mutableCopy() as? NSMutableOrderedSet {
            notas.add(nota)
            task.days = notas
            self.currentDays.append(nota)
        }
        do {
            try ViewController002.conexion().save()
            
        } catch let error as NSError {
            print("Ha ocurrido un error",error.localizedDescription)
        }
        cajaTextoComentario.text = ""
        self.view.endEditing(true)
        self.tabla.layoutIfNeeded()
        recuperaDias(unIdTask: idTask!)
       
    }
    func guardadoGlobal () {
        
        do {
            try ViewController002.conexion().save()
            intentosFallidos = 0
            
            print ("Check personalizado guardado")
            
        } catch let error as NSError {
            print ("Error en guardar check personalizado",error.localizedDescription )
        }
        
    }
    func guardaCheck (unCheck:String) {
        
        
        currentTask?.checkPoint = unCheck
        
       actualizarDatos()
        
    }
    
    func guardaCometario (unComentario:String, crono:Bool){
        
        ViewController002.generator.impactOccurred()
        
        let nota = Day(context: ViewController002.conexion())
        
        nota.coments = unComentario
        nota.dateRecord = NSDate()
        
        if crono {
           
            nota.totalTimer = totalTimer
          
        }
        
        // insertar nueva nota/dia dentro de la tarea
        
        if let task = currentTask,
            let notas = task.days?.mutableCopy() as? NSMutableOrderedSet {
            notas.add(nota)
            task.days = notas
            //     currentDays.append(nota)
            //    anArray.insert("This String", at: 0)
            currentDays.insert(nota, at: 0)
            
        }
        
        do {
            try ViewController002.conexion().save()
            print("guardado")
            
        } catch let error as NSError {
            
            print("Ha ocurrido un error",error.localizedDescription)
        }
        
        cajaTextoComentario.text = ""
      
        
        self.tabla.reloadData()
        
    }
    func escondeTeclado() {
        view.endEditing(true)
    }
    //    MARK: - Funciones de tabla PERSISTENICA
    
    func borraComentario(unComentario:IndexPath){
        ViewController002.conexion().delete(currentDays[unComentario.row])
        currentDays.remove(at: unComentario.row)
        do {
            try ViewController002.conexion().save()
            
            tabla.deleteRows(at: [unComentario], with: .fade)
            parserTotalTime()
        } catch let error as NSError {
            print("Error al borrar comentario : \(error.localizedDescription)")
        }
    }
    func modificarComentario(comentarioSeleccionado:IndexPath){
        editandoComentario = true
        indiceSeleccionado = comentarioSeleccionado
        if currentDays[comentarioSeleccionado.row].totalTimer == nil {
            cajaTextoComentario.text =   currentDays[comentarioSeleccionado.row].coments
        }
        else
        {
            cajaTextoComentario.text = MetodosEstaticos.separaComentarioConCrono(unComentario: currentDays[comentarioSeleccionado.row].coments!)
        }
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if ((currentDays[indexPath.row].photoAdd != nil) && currentTask?.opcShowPhotoInDays == true) {
            
            return 400 + UITableView.automaticDimension
        }
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier:
//            "cellViewController002", for: indexPath) as! CustomTableViewCell002
//     
//       cell.imagen.isHidden = true
//
//        if currentDays[indexPath.row].photoAdd != nil && currentTask?.opcShowPhotoInDays == true {
//
//            cell.imagen.isHidden = false
//
//        }
//
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
         if currentTask!.opcFinishCount  {
            return nil
        }
        
        let botonEditar = UIContextualAction(style: .normal, title: "Editar") { (action, view, handler) in
           
         
            self.cajaTextoComentario.becomeFirstResponder()
            self.preparaVistaParaEditarComentario()
            self.cajaTextoComentario.superRebotar()
            self.modificarComentario(comentarioSeleccionado: indexPath)
            
        }
        
            botonEditar.image = UIImage(named: "iconoEditar002")
            botonEditar.backgroundColor = .blue
        
        let configuration = UISwipeActionsConfiguration(actions: [botonEditar])
            configuration.performsFirstActionWithFullSwipe = false
        
        
        
            return configuration
        
    }


    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if currentTask!.opcFinishCount  {
            return nil
        }
        
        let action =  UIContextualAction(style: .normal, title: "Borrar", handler: { (action,view,completionHandler ) in
            
            self.borraComentario(unComentario: indexPath)
            
            completionHandler(true)
        })
        action.image = UIImage(named: "iconoBorrar002")
        action.backgroundColor = .red
        let confrigation = UISwipeActionsConfiguration(actions: [action])
        
        return confrigation
    }
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let currentDay = currentTask?.days else {
            return 1
        }
         return searchController.isActive ? currentDaysFiltrado.count : currentDay.count
//        return currentDay.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath:
        IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:
            "cellViewController002", for: indexPath) as! CustomTableViewCell002
        
        let currentDay = searchController.isActive ?
            currentDaysFiltrado[indexPath.row] : currentDays[indexPath.row]
        
        let dias:Int = MetodosEstaticos.calculaDiasEntreDosFechas(start: self.currentTask!.createDate! as Date, end: currentDay.dateRecord! as Date)
        
        let mensaje:String = dateFormatter.string(from:currentDay.dateRecord! as Date)
        
        let stringValue = String(format: "%@\n%@", MetodosEstaticos.creaStringDias(numeroDia: dias),mensaje)
        
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
        attributedString.setColorForText(textForAttribute: "\(MetodosEstaticos.creaStringDias(numeroDia: dias))", withColor: UIColor.white)
        attributedString.setColorForText(textForAttribute: "\n\(mensaje)", withColor: UIColor.lightGray)
        
        if currentDay.coments != nil {
            cell.label001.attributedText = attributedString
            
            cell.label002.text = "\(String(describing: currentDay.coments!))"
        }
        
        let delimiter = "*!"
        let newstr = cell.label002.text!
        var token = newstr.components(separatedBy: delimiter)
        
        if token.count>1 {
            print(token[1])
            
            cell.label002.attributedText = MetodosEstaticos.detectaComentarioTiempo(Comentario: token[0], Comentario002: token[1])
            
        }
        
        cell.imagen.isHidden = true
        cell.label002.isHidden = false
      
        let iconoCeldaConImagen = UIButton(type: .custom) as UIButton
        iconoCeldaConImagen.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        iconoCeldaConImagen.setImage(UIImage(named: "photoIcon"), for: .normal)
        
        cell.backgroundColor = UIColor.clear
        cell.accessoryType = .none
        cell.accessoryView = nil
        
        if currentDay.photoAdd != nil {
            cell.accessoryView = iconoCeldaConImagen as UIView
        }
        
        if currentTask!.opcShowPhotoInDays {
            
            if currentDay.photoAdd != nil {
                cell.imagen.isHidden = false
                cell.label002.isHidden = true
                let imageCelda:UIImage = UIImage (data: currentDay.photoAdd! as Data)!
                cell.imagen.image = imageCelda
            }
            
                    }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedDay = currentDays[indexPath.row]
        
        if selectedDay.photoAdd != nil {
            
            if currentTask?.opcShowPhotoInDays == false {
          
                let coloredSquare = UIView()
                
                coloredSquare.backgroundColor = UIColor.blue
                
                coloredSquare.frame = CGRect(x: 0, y: 0, width:UIScreen.main.bounds.width , height: UIScreen.main.bounds.height)
                
                self.view.addSubview(coloredSquare)
                
                UIView.animate(withDuration: 2.0, delay: 0, options: [.repeat, .autoreverse], animations: {
                    
                    coloredSquare.frame = CGRect(x: 120, y: 220, width: 100, height: 100)
                    
                }, completion: nil)
                
                DispatchQueue.main.async {
                    
                    self.fechaFotoSeleccionada = selectedDay.dateRecord! as Date
                    
                    self.performSegue(withIdentifier: "view002TovView004",sender: self)
                    
                    coloredSquare.layer.removeAllAnimations()
                    coloredSquare.removeFromSuperview()
                }
                
            
        }
        else
        {
            let img:UIImage = UIImage (data: selectedDay.photoAdd! as Data)!
                imagenSeleccionadaPreview = img
            
            
        }
        }
    }
    

    // MARK: - METODOS UTILES VISTA
    func deshabilitaEntradaDatos(unBooleano:Bool){
        
        cajaTextoCheck.isEnabled = unBooleano
        cajaTextoComentario.isEnabled = unBooleano
        botonCheck.isEnabled = unBooleano
        buttonStartStop.isEnabled = unBooleano
        
        
    }
    func preparaVistaParaEditarComentario(){
 
        
        mueveDashBoard(posicion: 1)
        
        currentTask?.stateDashboard = Int16(Int(1))
        
    }
    
    //    MARK: - NSFetchController Delegado
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tabla.beginUpdates()
        
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tabla.endUpdates()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            tabla.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tabla.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tabla.reloadRows(at: [indexPath!], with: .fade)
        default:
            tabla.reloadData()
        }
        
        self.currentDays = controller.fetchedObjects as! [Day]
    }
    //    MARK : METODOS UTILES CLASE
    func fotoReciente()->UIImage {
        
        var resultado:UIImage? = nil
        
        var soloFotos: [Day] = []
        
        for recorrido in 0..<currentDays.count {
            
            if currentDays[recorrido].photoAdd != nil {
                soloFotos.append(currentDays[recorrido])
            }
        }
        
        if soloFotos.count>0 {
            let img = soloFotos[0]
            if img.photoAdd != nil {
                let imagen:UIImage = UIImage (data:img.photoAdd! as Data)!
               resultado = imagen
            }
        }
        
        return resultado!
        
      
    }
    
    //      MARK: - METODOS UTILES MODELOS
    func actualizarDatos() {
        do {
            try ViewController002.conexion().save()
            
        } catch let error as NSError {
            print("No ha sido posible guardar \(error), \(error.userInfo)")
        }
        
    }
    public static func conexion()-> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
        
    }
    lazy var dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    func conviertDataToImage(aData:NSData)-> UIImage  {
        
        let aImage  = UIImage(data: aData as Data)
        return aImage!
        
    }
    // MARK: - Maquetación
    func showActivityIndicatory(uiView: UIView) {
      
        
        activityIndicator.center = uiView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style =
            UIActivityIndicatorView.Style.white
        uiView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
    }
    
    func dashboardPlace (){
        
        dashView002.frame.origin.x = 0
        dashView001.frame.origin.x = self.view.frame.size.width
        dashView003.frame.origin.x = self.view.frame.size.width*2
        
       
    }
    func dashboard003Order() {
        
        cronoLabel.frame = CGRect(x: 0, y: 0, width: view.frame.size.width-(view.frame.size.width/1.618034), height: scrollView001.frame.size.height)
       
        buttonStartStop.backgroundColor = ViewController002.colorVerde
        buttonStartStop.setTitle("Inicio", for: .normal)
       
        buttonStartStop.frame = CGRect(x: view.frame.size.width-(view.frame.size.width/1.618034), y: (dashView003.frame.size.height)/2-20, width: (view.frame.size.width/1.618034)-20, height: 40)
        
    }
    
    }




// MARK: - ANIMACIONES Y GAMIFICABLES
public extension NSMutableAttributedString {
    
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
    
}

public extension UIView {
    
    func shake(count : Float = 4,for duration : TimeInterval = 0.25,withTranslation translation : Float = 6) {
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: CGFloat(-translation), y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: CGFloat(translation), y: self.center.y))
        layer.add(animation, forKey: "shake")
    }

    //    Cerrado temporalmente :(
    /*
     
     func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
     tabla.beginUpdates()
     
     }
     func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
     tabla.endUpdates()
     }
     func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
     
     switch type {
     case .insert:
     tabla.insertRows(at: [newIndexPath!], with: .fade)
     case .delete:
     tabla.deleteRows(at: [indexPath!], with: .fade)
     case .update:
     tabla.reloadRows(at: [indexPath!], with: .fade)
     default:
     tabla.reloadData()
     }
     
     self.currentDays = controller.fetchedObjects as! [Day]
     //        self.currentTask?.days? = controller.fetchedObjects as! [Day]

     //       self.currentDays = controller.fetchRequest as! [Day]


     }

     func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

     let botonBorrar = UITableViewRowAction(style: .destructive, title: "\u{21E3}\n borrar") { (action, indexPath) in

     let contexto = self.conexion()
     let borrar = self.fetchResultController.object(at: indexPath)
     contexto.delete(borrar)


     //            (UIButton.appearance(whenContainedInInstancesOf: [UIView.self])).setImage(UIImage(named: "ic_delete"), for: .normal)
     do{
     try contexto.save()
     } catch {
     print("error al borrar")
     }

     }

     return [botonBorrar]


     }
     */
   
   
    /*
    func pruebaTabla() {
        
        for prueba in currentDays {
            
            var diaSection: Int = 0
            var diaSectionRecord : Int = 0
            
            myFirstInt += 1
            print (myFirstInt)
            print (currentDays[myFirstInt-1].dateRecord!)
            
           
            
            if diaSection == diaSectionRecord {
                
           
                
                
                diaSection = MetodosEstaticos.calculaDiasEntreDosFechas(start: self.currentTask!.createDate! as Date, end: currentDays[myFirstInt-1].dateRecord! as Date)
                
                
               
            }
            else {
                
                print(diaSection)
                diaSectionRecord = diaSection
                
            }
        }
    }
 */
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
