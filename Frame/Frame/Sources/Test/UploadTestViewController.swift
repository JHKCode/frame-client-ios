//
//  UploadTestViewController.swift
//  Frame
//
//  Created by Jinhong Kim on 8/4/16.
//  Copyright © 2016 Frame. All rights reserved.
//

import UIKit
import Photos


class UploadTestViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topLayoutGuideConstraint: NSLayoutConstraint!
    
    var selectedImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func viewWillLayoutSubviews() {
        topLayoutGuideConstraint.constant = self.topLayoutGuide.length
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func handleSelectButton(sender: AnyObject) {
        openImagePikcer()
    }
    
    
    @IBAction func handleUploadButton(sender: AnyObject) {
        uploadImage()
    }
    
    
    // MARK: - UIImagePickerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print(info)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        
        if let referenceURL = info[UIImagePickerControllerReferenceURL] as? NSURL {
            fetchAsset(referenceURL)
        }
        
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func openImagePikcer() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) == false {
            return
        }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        
        self.navigationController?.presentViewController(picker, animated: true, completion: nil)
    }
    
    
    func fetchAsset(assetURL: NSURL) {
        if let asset = PHAsset.fetchAssetsWithALAssetURLs([assetURL], options: nil).firstObject as? PHAsset {
            print(asset)
            
            let imageResolution = CGSizeMake(1280, 720)
            let options = PHImageRequestOptions()
            
            options.deliveryMode = PHImageRequestOptionsDeliveryMode.HighQualityFormat
            options.networkAccessAllowed = true
            options.resizeMode = PHImageRequestOptionsResizeMode.Exact
            

            PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: imageResolution, contentMode: PHImageContentMode.AspectFit, options: options) { (image, imageInfo) in
                print(imageInfo)
                print(image)
                
                self.selectedImage = image
            }
        }
    }
    
    
    func uploadImage() {
        guard let image = self.selectedImage else {
            return
        }
        
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.7) else {
            return
        }
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://127.0.0.1:5000/frame/playground/contents")!)
        request.HTTPMethod = "POST"
        request.addValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        
        let uploadTask = NSURLSession.sharedSession().uploadTaskWithRequest(request, fromData: imageData) { (data, response, error) in
            if error != nil {
                print(error)
            }
            
            if response != nil {
                print(response)
            }
        }
        
        uploadTask.resume()
    }
}
