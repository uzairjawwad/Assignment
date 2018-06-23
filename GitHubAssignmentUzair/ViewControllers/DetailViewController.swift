//
//  DetailViewController.swift
//  GitHubAssignmentUzair
//
//  Created by Uzair on 6/23/18.
//  Copyright © 2018 uzi. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var upperView: UIView!
    var userName = ""
    var userEmail = ""
    var userThumbnails = ""
    var userFollowersLink = ""
    
    var followerListArray: [User] = []
    
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        upperView.layer.borderWidth = 1
        upperView.layer.borderColor = UIColor.black.cgColor
        lblUserName.text = userName 
        lblUserEmail.text = userEmail 
        
        let url = URL(string:userThumbnails)
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async() {    // execute on main thread
                self.userImage.image = UIImage(data: data)
            }
        }
        
        task.resume()
        
        self.getFollowersList()

    }
    
    // MARK: Web Request
    func getFollowersList() {
        
        let targetURL = URL(string: userFollowersLink)
        
        performGetRequest(targetURL, completion: { (data, HTTPStatusCode, error) -> Void in
            if HTTPStatusCode == 200 && error == nil {
                
                do {
                    // Convert the JSON data to a dictionary.
                    let resultsDict = try JSONSerialization.jsonObject(with: data! as Data, options: []) as! [[String:Any]]
                
                    for i in 0 ..< resultsDict.count {
                        
                        print(resultsDict[i])
                        let user = User()
                        user.userName = resultsDict[i]["login"] as? String
                        user.thumbnails = resultsDict[i]["avatar_url"] as? String
    
                        self.followerListArray.append(user)
                    }
                    
                    if self.followerListArray.count == 0 {
                        
                        self.tblView.isHidden = true
                    }
                    self.tblView.reloadData()
                    
                } catch {
                    print(error)
                }
                
            } else {
                
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


    // MARK: UITableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return followerListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = self.tblView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        let lbl : UILabel? = cell.contentView.viewWithTag(11) as? UILabel
        lbl?.text = followerListArray[indexPath.row].userName
        
        let img : UIImageView = (cell.contentView.viewWithTag(10) as? UIImageView)!
        
        let url = URL(string:followerListArray[indexPath.row].thumbnails!)
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async() {    // execute on main thread
                img.image = UIImage(data: data)
            }
        }
        
        task.resume()
        
        return cell
    }
    // MARK: Button Action
    @IBAction func actBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
