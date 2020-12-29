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
    
    var buttonNumber = 0
    
    // seletion dispositions
    
    @IBAction func setModel1(_ sender: UIButton) {
        gridView.selected(style: .model1)
    }
    @IBAction func setModel2(_ sender: UIButton) {
        gridView.selected(style: .model2)
    }
    @IBAction func setModel3(_ sender: UIButton) {
        gridView.selected(style: .model3)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*    let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
         let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
         
         upSwipe.direction = .up
         leftSwipe.direction = .left
         
         view.addGestureRecognizer(upSwipe)
         view.addGestureRecognizer(leftSwipe)
         
         }
         
         @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
         if (sender.direction == .up) {
         let labelPosition = CGPoint(x: swipeLabel.frame.origin.x, y: swipeLabel.frame.origin.y - 50.0)
         swipeLabel.frame = CGRect(x: labelPosition.x, y: labelPosition.y, width: swipeLabel.frame.size.width, height: swipeLabel.frame.size.height)
         }
         
         if (sender.direction == .left) {
         let labelPosition = CGPoint(x: swipeLabel.frame.origin.x - 50.0, y: swipeLabel.frame.origin.y)
         swipeLabel.frame = CGRect(x: labelPosition.x, y: labelPosition.y, width: swipeLabel.frame.size.width, height: swipeLabel.frame.size.height)
         }*/
    }
    
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
        self.buttonNumber = 1
    }
    
    @IBAction func didTapButtonTopRight() {
        buttonPhotoLibrary()
        self.buttonNumber = 2
    }
    
    @IBAction func didTapButtonBottomLeft() {
        buttonPhotoLibrary()
        self.buttonNumber = 3
    }
    
    @IBAction func didTapButtonBottomRight() {
        buttonPhotoLibrary()
        self.buttonNumber = 4
    }
    
    // Alert incomplete GrideView
    func alerteIncompleteGrid() {
        let alert = UIAlertController(title: "erreur", message: "Merci d'ajouter toutes les photos.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
        })
        alert.addAction(action)
        present(alert, animated: true, completion: {
        })
    }
    
    
    func sharePicture(isLeft: Bool) {
        
        if gridView.checkCompleteGrid() == false {
            alerteIncompleteGrid()
        } else {
            if isLeft {
                UIView.animate(withDuration: 0.3, animations: {
                    self.gridView.frame.origin.x = -self.gridView.frame.width
                })
                
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.gridView.frame.origin.y = -self.gridView.frame.height
                })
            }
            // Open the sharing menu
            if let image = convertView(view: gridView)  {
                let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                activityController.completionWithItemsHandler = { activity, success, items, error in
                    UIView.animate(withDuration: 0.3, animations: {
                        self.gridView.center.y = self.view.center.y
                        self.gridView.center.x = self.view.center.x
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
    
    
    @IBAction func SwipUp(_ sender: UISwipeGestureRecognizer) {
        self.sharePicture(isLeft: false)
    }
    
}

