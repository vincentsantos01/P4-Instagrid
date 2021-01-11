//
//  ViewController.swift
//  Instagrid
//
//  Created by vincent santos on 07/12/2020.
//

import UIKit
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    
    
    // Outlets package
    
    @IBOutlet weak var gridView: GridView!
    @IBOutlet weak var gridStackView: UIStackView!
    // Images uiImages
    @IBOutlet var alternateImagesViews: [UIImageView]!
    // Images uiView
    @IBOutlet var realViews: [UIView]!
    // 7 buttons of app
    @IBOutlet var buttons: [UIButton]!
    // SwipeUp views
    @IBOutlet weak var swipeLabel: UILabel!
    @IBOutlet weak var swipeUpIcon: UIImageView!
    
    
    
    var buttonNumber = 0
    
    // seletion dispositions
    
    @IBAction func setModel1(_ sender: UIButton) {
        gridView.selected(style: .Leftmodel)
    }
    @IBAction func setModel2(_ sender: UIButton) {
        gridView.selected(style: .Midlemodel)
    }
    @IBAction func setModel3(_ sender: UIButton) {
        gridView.selected(style: .Rightmodel)
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Device rotation

        let didRotate: (Notification) -> Void = { [self] notification in
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                self.swipeLabel.text = "Swipe left to share"
                self.swipeUpIcon.image = #imageLiteral(resourceName: "Arrow Left")
            case .portrait:
                self.swipeLabel.text = "Swipe up to share"
                self.swipeUpIcon.image = #imageLiteral(resourceName: "Arrow Up")
            default:
                break
            }
        }
        NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main, using: didRotate)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    // Ajout image selon case demmandée
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage]as? UIImage {
            if self.buttonNumber == 1 {
                alternateImagesViews[0].image = image
            } else if buttonNumber == 2 {
                alternateImagesViews[1].image = image
            } else if buttonNumber == 3 {
                alternateImagesViews[2].image = image
            } else if buttonNumber == 4 {
                alternateImagesViews[3].image = image
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    // Fonction générale de demande d'autorisation
    
    private func buttonPhotoLibrary() {
        PHPhotoLibrary.requestAuthorization({status in
            if status == .authorized {
                DispatchQueue.main.async {
                    let ButtonTapTopLeft = UIImagePickerController()
                    ButtonTapTopLeft.sourceType = .photoLibrary
                    ButtonTapTopLeft.delegate = self
                    ButtonTapTopLeft.allowsEditing = true
                    self.present(ButtonTapTopLeft, animated: true)
                }
            }
        }
        )
        
    }
    
    // Action of GriView Button
    
    @IBAction func didTapButtonTopLeft() {
        buttonPhotoLibrary()
        self.buttonNumber = 4
    }
    
    @IBAction func didTapButtonTopRight() {
        buttonPhotoLibrary()
        self.buttonNumber = 3
    }
    
    @IBAction func didTapButtonBottomLeft() {
        buttonPhotoLibrary()
        self.buttonNumber = 2
    }
    
    @IBAction func didTapButtonBottomRight() {
        buttonPhotoLibrary()
        self.buttonNumber = 1
    }
    
    // Alert incomplete GrideView
    func alerteIncompleteGrid() {
        let alert = UIAlertController(title: "Erreur", message: "Merci d'ajouter toutes les photos.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
        })
        alert.addAction(action)
        present(alert, animated: true, completion: {
        })
    }
    
    // Translation pour partage
    
    func sharePicture(isLeft: Bool) {
        
        if gridView.checkCompleteGrid() == false {
            alerteIncompleteGrid()
        } else {
            if isLeft {
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.gridView.transform = CGAffineTransform(translationX: -self.view.bounds.width, y: 0)
                })
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.gridView.transform = CGAffineTransform(translationX: 0, y: -self.view.bounds.height)
                })
            }
            // Open the sharing menu
            if let image = convertView(view: gridView)  {
                let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                activityController.completionWithItemsHandler = { activity, success, items, error in
                    UIView.animate(withDuration: 0.3, animations: {
                        self.gridView.transform = .identity
                    })
                }
                present(activityController, animated: true, completion: nil)
            }
        }
    }
    
    
    func convertView(view: GridView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let imgConverted = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imgConverted
    }
    
    // Swipe up and left gestures
    
    @IBAction func swipeUp(_ sender: UISwipeGestureRecognizer) {
        self.sharePicture(isLeft: false)
    }
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        self.sharePicture(isLeft: true)
    }
    
}

