//
//  PokerDetectionViewController.swift
//  PokerDetection
//
//  Created by Jason Chow on 10/4/2020.
//  Copyright © 2020 Jason Chow. All rights reserved.
//

import UIKit
import CoreML
import Vision
import ImageIO

class PokerDetectionViewController: UIViewController {
    
    struct detectedPoker {
        var objectIdentifier: String
        var objectConfidence: Float
        var objectBoundingBox: CGRect
    }
    
    var detectedPokers: [detectedPoker] = []
    
    // MARK: - IBOutlets
    
//    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var classificationLabel: UILabel!
    
    // MARK: - Object Detection
    
    lazy var classificationRequest: VNCoreMLRequest? = {
        do {
            let model = try VNCoreMLModel(for: POKER_DETECTION_MODEL)
            let request = VNCoreMLRequest(model: model, completionHandler: {
                [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .scaleFit
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    func updateClassifications(for image: UIImage) {
        classificationLabel.text = "Classifying..."
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        guard let ciImage = CIImage(image: image) else {
            fatalError("Unable to create \(CIImage.self) from \(image).")
        }
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest!])
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                self.classificationLabel.text = "Unable to classify image.\n\(error!.localizedDescription)"
                return
            }
            let classifications = results as! [VNRecognizedObjectObservation]
            if classifications.isEmpty {
                self.classificationLabel.text = "Nothing recognized."
            } else {
                self.detectedPokers = []
                
                //JCHOWCH WARNING： THIS PROCRESS IS FOR LOUIS CreateML TRAINED MODEL
                //do the classification for the detect results
                for classification in classifications {
                    var objectIdentifier = ""
                    var objectConfidence: Float = 0.0
                    var objectBoundingBox: CGRect = CGRect()
                    objectBoundingBox = classification.boundingBox
                    for label in classification.labels {
                        if objectConfidence.isLess(than: Float(label.confidence)) {
                            objectIdentifier = label.identifier
                            objectConfidence = label.confidence
                        }
                    }
                    self.detectedPokers.append(detectedPoker(objectIdentifier: objectIdentifier, objectConfidence: objectConfidence, objectBoundingBox: objectBoundingBox))
                }
                
                //calculate combin of pokers
                let count = self.detectedPokers.count - 1
                for i in 0...count {
                    for j in i...count {
                        if abs(self.detectedPokers[i].objectBoundingBox.minX - self.detectedPokers[j].objectBoundingBox.minX) <= 0.1, abs(self.detectedPokers[i].objectBoundingBox.minY - self.detectedPokers[j].objectBoundingBox.minY) <= 0.1 {
                            
                            //try add to poker array
                            addPoker(a: self.detectedPokers[i].objectIdentifier, b:self.detectedPokers[j].objectIdentifier)
                        }
                    }
                }
                
                //print results
                self.classificationLabel.text = "Classification:\n \(listPokers())"
            }
        }
    }
    
    // MARK: - Photo Actions
    
    @IBAction func takePicture() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            presentPhotoPicker(sourceType: .photoLibrary)
            return
        }
        
        let photoSourcePicker = UIAlertController()
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .camera)
        }
        let choosePhoto = UIAlertAction(title: "Choose Photo", style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .photoLibrary)
        }
        
        photoSourcePicker.addAction(takePhoto)
        photoSourcePicker.addAction(choosePhoto)
        photoSourcePicker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(photoSourcePicker, animated: true)
    }
    
    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
    }
}

extension PokerDetectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Handling Image Picker Selection
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        cameraButton.setBackgroundImage(image, for: .normal)
        updateClassifications(for: image)
    }
    
}
