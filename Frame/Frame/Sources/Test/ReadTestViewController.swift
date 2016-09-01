//
//  ReadTestViewController.swift
//  Frame
//
//  Created by Jinhong Kim on 8/8/16.
//  Copyright © 2016 Frame. All rights reserved.
//

import UIKit

class ReadTestViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    var contents: Array<String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false;
        self.contentScrollView.contentOffset = CGPointZero
        self.contentScrollView.contentInset = UIEdgeInsetsZero
    }

    
    override func viewWillLayoutSubviews() {
        self.topLayoutConstraint.constant = self.topLayoutGuide.length
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print(scrollView.contentOffset)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func handleReadContentsButton(sender: AnyObject) {
        let URL = NSURL(string: "http://127.0.0.1:5000/frame/playground/contents")
        let dataTask = NSURLSession.sharedSession().dataTaskWithURL(URL!) { (data, response, error) in
            if error != nil {
                print(error)
            }
            
            if response != nil {
                print(response)
            }
            
            if let resultData = data where resultData.length > 0 {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(resultData, options: NSJSONReadingOptions.AllowFragments)
                    
                    print(json)
                    
                    guard json is NSDictionary else {
                        return
                    }
                    
                    if let contents = json["contents"] {
                        self.contents = contents as? Array<String>
                        print(self.contents)
                        
                        //self.setupContentScrollView()
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        
        dataTask.resume()
    }
    
    
    @IBAction func handleDownloadContentsButton(sender: AnyObject) {
        guard let contents = self.contents where contents.count > 0 else {
            return
        }
        
        
        for contentID in contents {
            let URL = NSURL(string: "http://127.0.0.1:5000/frame/playground/contents/" + contentID)
            let dataTask = NSURLSession.sharedSession().dataTaskWithURL(URL!) { (data, response, error) in
                if error != nil {
                    print(error)
                }
                
                if response != nil {
                    print(response)
                }
                
                if let contentData = data where contentData.length > 0 {
                    if let image = UIImage(data: contentData) {
                        dispatch_async(dispatch_get_main_queue(), { 
                            self.displayImage(image)
                        })
                    }
                }
            }
            
            dataTask.resume()
        }
    }
    
    
    func setupContentScrollView() {
        guard let contents = self.contents where contents.count > 0 else {
            return
        }
        
        
        dispatch_async(dispatch_get_main_queue()) { 
            let height = self.contentScrollView.bounds.size.height
            self.contentScrollView.contentSize = CGSizeMake(CGFloat(contents.count) * height, height)
        }
    }
    
    
    func displayImage(image: UIImage) {
        var contentSize = self.contentScrollView.contentSize
        let height = self.contentScrollView.bounds.size.height
        
        
        // add new image
        let imageView = UIImageView(image: image)
        
        imageView.frame = CGRectMake(contentSize.width, 0, height , height)
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        
        self.contentScrollView.addSubview(imageView)
        
        
        // update scrollview
        contentSize.width += height
        contentSize.height = height
        
        self.contentScrollView.contentSize = contentSize
    }
}
