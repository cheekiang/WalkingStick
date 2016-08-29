//
//  SecondViewController.swift
//  WalkingStickSG
//
//  Created by Chee Kiang Tan on 21/8/16.
//  Copyright © 2016 Govtech. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var SWalkingStickID: UITextField!
    @IBOutlet weak var SCGMobile: UITextField!
    @IBOutlet weak var SUserMobile: UITextField!
    @IBOutlet weak var SAVE: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //let newVC: ViewController = segue.destinationViewController as! ViewController
        //let passedUserMobile = SUserMobile.text
        //newVC.UserMobile = passedUserMobile!
        //print(passedUserMobile)
    }

    @IBAction func SAVE(sender: UIButton) {
        let httppoststring: String = "stickID=" + SWalkingStickID.text! + "&careGiverPhone=" + SCGMobile.text! + "&elderPhone=" + SUserMobile.text!
        
        let url:NSURL = NSURL(string: "http://188.166.241.24/SaveHandphoneNo.php")!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        
        let data = httppoststring.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let task = session.uploadTaskWithRequest(request, fromData: data, completionHandler:
            {(data,response,error) in
                
                guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                    print("error")
                    return
                }
                
                let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print(dataString)
            }
        );
        
        let alertControllerSave = UIAlertController(title: "Settings", message:
            "Configurations Saved", preferredStyle: UIAlertControllerStyle.Alert)
        alertControllerSave.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertControllerSave, animated: true, completion: nil)
        task.resume()
        //let passedUserMobile = SUserMobile.text
        //print(passedUserMobile)
    }
}
