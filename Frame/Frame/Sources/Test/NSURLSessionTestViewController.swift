//
//  NSURLSessionTestViewController.swift
//  Frame
//
//  Created by Jinhong Kim on 8/9/16.
//  Copyright © 2016 Frame. All rights reserved.
//

import UIKit

class FetchContentsOperation: NSOperation {

    var task: NSURLSessionDataTask?
    //let semaphore: dispatch_semaphore_t
    let fetchURL: NSURL
    //let opQueue: NSOperationQueue
    
    init(URL: NSURL, queue: NSOperationQueue) {
        //semaphore = dispatch_semaphore_create(0)
        fetchURL = URL
        //opQueue = queue
        
        super.init()
    }
    
    
    deinit {
        print("FetchContentsOperation deinit called")
    }
    
    
    override func main() {
//        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: self.opQueue)
        let session = NSURLSession.sharedSession()
        self.task = session.dataTaskWithURL(self.fetchURL) { (data, response, error) in
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
                } catch let error as NSError {
                    print(error)
                }
            }
            
            //dispatch_semaphore_signal(self.semaphore)
        }
        
        self.task!.resume()

        //dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER)
        
        CFRunLoopRun()
    }
}


class NSURLSessionTestViewController: UIViewController {

    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    
    let operationQueue: NSOperationQueue
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.operationQueue = NSOperationQueue.init()

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func viewDidLayoutSubviews() {
        self.topLayoutConstraint.constant = self.topLayoutGuide.length
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

    
    @IBAction func handleAddOperationButton(sender: AnyObject) {
        let URL = NSURL(string: "http://127.0.0.1:5000/frame/playground/contents")
        let op  = FetchContentsOperation(URL: URL!, queue: self.operationQueue)
        
        self.operationQueue.addOperation(op)
    }
}
