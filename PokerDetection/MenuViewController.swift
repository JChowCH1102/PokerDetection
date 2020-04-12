//
//  MenuViewController.swift
//  PokerDetection
//
//  Created by HoiChun Yip on 11/4/2020.
//  Copyright © 2020 HoiChun Yip. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    var imagPickUp : UIImagePickerController!
    var imageV : UIImageView!
    
    func imageAndVideos()-> UIImagePickerController{
        if(imagPickUp == nil){
            imagPickUp = UIImagePickerController()
            imagPickUp.delegate = self
            imagPickUp.allowsEditing = false
        }
        return imagPickUp
    }
    

    @IBAction func buttonClicked(_ sender: Any) {
        let ActionSheet = UIAlertController(title: nil, message: "Select Photo", preferredStyle: .actionSheet)

        let cameraPhoto = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){

                self.imagPickUp.mediaTypes = ["public.image"]
                self.imagPickUp.sourceType = UIImagePickerController.SourceType.camera;
                self.present(self.imagPickUp, animated: true, completion: nil)
            }
            else{
                UIAlertController(title: "iOSDevCenter", message: "No Camera available.", preferredStyle: .alert).show(self, sender: nil);
            }

        })

        let PhotoLibrary = UIAlertAction(title: "Photo Library", style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
                self.imagPickUp.mediaTypes = ["public.image"]
                self.imagPickUp.sourceType = UIImagePickerController.SourceType.photoLibrary;
                self.present(self.imagPickUp, animated: true, completion: nil)
            }

        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction) -> Void in

        })

        ActionSheet.addAction(cameraPhoto)
        ActionSheet.addAction(PhotoLibrary)
        ActionSheet.addAction(cancelAction)


        if UIDevice.current.userInterfaceIdiom == .pad{
            let presentC : UIPopoverPresentationController  = ActionSheet.popoverPresentationController!
            presentC.sourceView = self.view
            presentC.sourceRect = self.view.bounds
            self.present(ActionSheet, animated: true, completion: nil)
        }
        else{
            self.present(ActionSheet, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageV.image = image
        imagPickUp.dismiss(animated: true, completion: { () -> Void in
            // Dismiss
        })

    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagPickUp.dismiss(animated: true, completion: { () -> Void in
            // Dismiss
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        imagPickUp = self.imageAndVideos()


        imageV = UIImageView(frame: CGRect(x: 72, y: 86, width: 270, height: 270))
        imageV.layer.cornerRadius = 10
        imageV.clipsToBounds = true
        imageV.layer.borderWidth = 2.0
        imageV.layer.borderColor = UIColor.gray.cgColor
        view.addSubview(imageV)
    }
    

    
//    @IBAction func displayActionSheet(_ sender: Any) {
//        // 1
//        let optionMenu = UIAlertController(title: nil, message: "Choose a photo method", preferredStyle: .actionSheet)
//
//        // 2
//        let cameraAction = UIAlertAction(title: "Camera", style: .default)
//        let choosePhotoAction = UIAlertAction(title: "Choose photo", style: .default)
//
//        // 3
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//
//        // 4
//        optionMenu.addAction(cameraAction)
//        optionMenu.addAction(choosePhotoAction)
//        optionMenu.addAction(cancelAction)
//
//        // 5
//        self.present(optionMenu, animated: true, completion: nil)
//
//
//    }
    
}
