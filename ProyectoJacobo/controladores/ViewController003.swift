//
//  ViewController003.swift
//  Gestor
//
//  Created by Jacobo Diego Pita Hernandez on 26/4/18.
//  Copyright © 2018 Jacobo Diego Pita Hernandez. All rights reserved.
//

import UIKit
import Vision
import CoreML
import CoreData
import AVFoundation
import Photos

class ViewController003: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {


    @IBOutlet var cameraView: UIView!
    @IBOutlet var cameraButton: UIButton!
    
    //  MARK:- VARIABLES
    
    var captureSession = AVCaptureSession();
    var sessionOutput = AVCapturePhotoOutput();
    var sessionOutputSetting = AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecType.jpeg]);
    var previewLayer = AVCaptureVideoPreviewLayer();
    
   
    var visualEffectView = UIVisualEffectView()
    var idRecibido:String?
    var comentarioTexto:String?
    var diaCurso:String?
    
    var offsetY:CGFloat = 0

    // MARK: - IBOULETS
    
    @IBOutlet var textBox002: UITextField!
    
    @IBOutlet var vistaTrasera: UIView!
    
    // MARK:- IBACTION

    @IBAction func seleccionarFoto(_ sender: Any) {

visualEffectView.isHidden = false

        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {

            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)

        } else {

            print("No se pudo obtener acceso a la libreria de fotos")

        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {

        if ((viewController as? ViewController002) != nil) {

            if self.imageData.image != nil{
              //  (viewController as? ViewController002)?.guardarImagen(unaImagen: self.imageData.image!)
                
                if (textBox002.text == "Añade un comentario") {
                    
                    comentarioTexto = ""
                }
                
                (viewController as? ViewController002)?.guardarImagen(unaImagen: self.imageData.image!, unComentario: self.comentarioTexto!)
                
            }
        }
    }

    // MARK:- IBOULETS
    @IBOutlet weak var vistaReferenciaCamara: UIView!

    @IBOutlet weak var tituloPantalla: UILabel!

    @IBOutlet weak var imageData: UIImageView!

    //    MARK: - FUNCIONES DE INICIO/FIN
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tituloPantalla.text = diaCurso!
        tituloPantalla.isHidden = true

       // self.title = diaCurso!

        ejecutarCamara()
        generaImagenBorrosa()

        navigationController!.delegate = self
        
        
       vistaTrasera.frame = CGRect(x: self.textBox002.frame.origin.x, y: self.textBox002.frame.origin.y, width: self.textBox002.frame.size.width, height: self.textBox002.frame.size.height)
        
            styleCaptureButton()
        

      
    }
    override func viewWillAppear(_ animated: Bool) {
        
        visualEffectView.isHidden = false
       
        if (comentarioTexto == "Añade un comentario"){
            
            textBox002.textColor = UIColor.white.withAlphaComponent(0.25)
        }
       
         self.textBox002.text = comentarioTexto
        
          NotificationCenter.default.addObserver(self, selector: #selector(ViewController003.keyboardFrameChangeNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
      
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
    }
    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.navigationBar.willRemoveSubview(visualEffectView)

        visualEffectView.isHidden = true

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK:- FUNCIONES DE LA VISTA CONTROLADOR

    func ejecutarCamara() {

        /*
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {

            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            
            let screenSize = UIScreen.main.bounds.size
            let aspectRatio:CGFloat = 4/3
            let scale = screenSize.height/screenSize.width * aspectRatio
            imagePicker.cameraViewTransform = CGAffineTransform(scaleX: scale, y: scale);
            
            self.present(imagePicker, animated: true, completion: nil)

        } else {

            print("No se pudo acceder a la camara")

        }
*/
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInDualCamera, AVCaptureDevice.DeviceType.builtInTelephotoCamera,AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        
        for device in (deviceDiscoverySession.devices) {
            if(device.position == AVCaptureDevice.Position.back){
                do{
                    let input = try AVCaptureDeviceInput(device: device)
                    if(captureSession.canAddInput(input)){
                        captureSession.addInput(input);
                        
                        if(captureSession.canAddOutput(sessionOutput)){
                            captureSession.addOutput(sessionOutput);
                            
                           self.captureSession.sessionPreset = .photo
                                                      
                            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
                            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill;
                            previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait;
                            
                            self.cameraView.layer.addSublayer(previewLayer);
                            self.captureSession.startRunning()
                            
                        }
                        
                    }
                }
                catch{
                    print("exception!");
                }
            }
        }

        
     
    }

    func styleCaptureButton() {
        
        cameraButton.layer.borderColor = UIColor.white.cgColor
        cameraButton.layer.borderWidth = 5
        cameraButton.clipsToBounds = true
        cameraButton.layer.cornerRadius = min(cameraButton.frame.width, cameraButton.frame.height) / 2
    }
    
    @objc func detectarImagenes(){

        self.title = "cargando..."

        guard let model = try? VNCoreMLModel(for: Resnet50().model) else {
            print("Ocurrio un error no se pudo crear el modelo")
            return
        }

        let peticion = VNCoreMLRequest(model: model) { (request, error) in


            guard let resultados = request.results as? [VNClassificationObservation],
                let primerResultado = resultados.first else {
                    print("No se encontraron resultados")
                    return
            }

            DispatchQueue.main.async {
                self.title = "\(primerResultado.identifier)"

            }
        }

        guard let ciimageForUse = CIImage(image: self.imageData.image!) else {
            print("No se a podido crear la imagen CIImage a partir de un UIImage")
            return
        }

        // Correr peticion

        let handler = VNImageRequestHandler(ciImage:ciimageForUse)

        DispatchQueue.global().async {
            do {
                try handler.perform([peticion])
            } catch {
                print(error.localizedDescription)
            }
        }


    }

    //  MARK:-  METODOS DELEGADOS

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if (textBox002 == textField && textBox002.text?.isEmpty == false) {
            
            comentarioTexto = textBox002.text!
            
            // guardar o cancelar
            
        }
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
   
        textBox002.textColor = UIColor.white.withAlphaComponent(1.0)
         moveTextField(textField, moveDistance: -200, up: true)
       
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField, moveDistance: -200, up: false)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
      
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func cameraButton_TouchUpInside(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        self.sessionOutput.capturePhoto(with: settings, delegate: self as! AVCapturePhotoCaptureDelegate)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)


        if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {

            self.imageData.contentMode = .scaleAspectFill
            self.imageData.image = pickedImage

        }

        picker.dismiss(animated: true, completion: nil)

    //    detectarImagenes()

    }
    //      MARK: - Métodos útiles
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
      
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        vistaTrasera.frame = CGRect(x: self.textBox002.frame.origin.x, y: self.textBox002.frame.origin.y, width: self.textBox002.frame.size.width, height: self.textBox002.frame.size.height)
        
        UIView.commitAnimations()
    }
    
    @objc func keyboardFrameChangeNotification(notification: Notification) {
      
               
        if let userInfo = notification.userInfo {
           
            let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
            let animationCurveRawValue = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int) ?? Int(UIView.AnimationOptions.curveEaseInOut.rawValue)
            let animationCurve = UIView.AnimationOptions(rawValue: UInt(animationCurveRawValue))
           
            if let _ = endFrame, endFrame!.intersects(self.textBox002.frame) {
                self.offsetY = self.textBox002.frame.maxY - endFrame!.minY
                UIView.animate(withDuration: animationDuration, delay: TimeInterval(0), options: animationCurve, animations: {
                    self.textBox002.frame.origin.y = self.textBox002.frame.origin.y - self.offsetY
                 
                }, completion: nil)
            } else {
                if self.offsetY != 0 {
                    UIView.animate(withDuration: animationDuration, delay: TimeInterval(0), options: animationCurve, animations: {
                        self.textBox002.frame.origin.y = self.textBox002.frame.origin.y + self.offsetY
                        self.offsetY = 0
                    }, completion: nil)
                }
            }
        }
    }
    
    func conexion()-> NSManagedObjectContext {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext

    }
    func generaImagenBorrosa(){

        visualEffectView   = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        visualEffectView.frame =  (self.navigationController?.navigationBar.bounds.insetBy(dx: 0, dy: -50).offsetBy(dx: 0, dy: -50))!
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)

        visualEffectView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        self.navigationController?.navigationBar.insertSubview(visualEffectView, at: 0)

        
        let visualEffectView002 = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        visualEffectView002.frame = (self.textBox002.bounds.insetBy(dx: 0, dy: 0).offsetBy(dx: 0, dy: 0))
        visualEffectView002.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        
        visualEffectView002.clipsToBounds = true
        visualEffectView002.layer.cornerRadius = 5.0
        
     //  self.textBox002.insertSubview(visualEffectView002, at: 1)
       self.vistaTrasera.insertSubview(visualEffectView002, at: 0)
       //     self.textBox002.inputView = visualEffectView002
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
