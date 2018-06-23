//
//  SearchViewController.swift
//  GitHubAssignmentUzair
//
//  Created by Uzair on 6/23/18.
//  Copyright © 2018 uzi. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var txtSearch: UITextField!
    
    var loader = ActivityLoaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK: Button Action
    @IBAction func actSearch(_ sender: UIButton) {
        
        if txtSearch.text?.count == 0  {
            
            let alertController = UIAlertController(title: "Alert Notification", message: "Please enter Username", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                print("OK")
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
        
             self.showLoadingView()
            self.sendRequestWithUsername(txtSearch.text!)
        }
   
    }
    
    // MARK: Web Request
    func sendRequestWithUsername(_ username:String) {

        let targetURL = URL(string: "https://api.github.com/users/\(username)")
        
        performGetRequest(targetURL, completion: { (data, HTTPStatusCode, error) -> Void in
            if HTTPStatusCode == 200 && error == nil {
                
                do {
                    // Convert the JSON data to a dictionary.
                    let resultsDict = try JSONSerialization.jsonObject(with: data! as Data, options: []) as! Dictionary<String,Any>
                    
                    DispatchQueue.main.async(execute: {
                        
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController

                        if let username = resultsDict["login"] as? String {
                            vc.userName = username
                        }
                        
                        if let email = resultsDict["email"] as? String {
                            vc.userEmail = email
                        }
                        
                        if let imageName = resultsDict["avatar_url"] as? String {
                            vc.userThumbnails = imageName
                        }
                        
                        if let followers = resultsDict["followers_url"] as? String {
                            vc.userFollowersLink = followers
                        }
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    
                    })
                    
                          self.hideLoadingView()
                    
                } catch {
                      self.hideLoadingView()
                    print(error)
                }
                
            } else {
                
           self.hideLoadingView()
                let alertController = UIAlertController(title: "Alert Notification", message: "User is not found", preferredStyle: UIAlertControllerStyle.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    (result : UIAlertAction) -> Void in
                    print("OK")
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
        
            }
        })
        
    }
    
    func performGetRequest(_ targetURL: URL!, completion: @escaping (_ data: NSData?, _ HTTPStatusCode: Int, _ error: NSError?) -> Void) {
        
        var request = URLRequest(url: targetURL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            DispatchQueue.main.async(execute: {
                completion(data as NSData, ((response as? HTTPURLResponse)?.statusCode)!, error as NSError?)
            })
        }
        task.resume()
    }
    
    func showLoadingView()
    {
        DispatchQueue.main.async(execute: {
            let applicationDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
            self.view.addSubview(applicationDelegate.loadingView!)
            self.view.bringSubview(toFront: (applicationDelegate.loadingView!))
            self.view.isUserInteractionEnabled = false
            applicationDelegate.loadingView!.show()
            
        })
    }
    
    func hideLoadingView()
    {
        DispatchQueue.main.async(execute: {
            let applicationDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
            self.view.addSubview(applicationDelegate.loadingView!)
            self.view.isUserInteractionEnabled = true
            applicationDelegate.loadingView!.hide()
        })
    }
}

