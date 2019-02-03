//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by David Yip on 1/31/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweetArray = [NSDictionary]()
    var numOfTweets: Int!
    
    func loadTweets(){
        
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": 10]
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            
        }, failure: { (Error) in
            print("could not retrieve tweet")
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadTweets()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }

    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        
        let twitterUser = tweetArray[indexPath.row]["user"] as! NSDictionary
        let imageUrl = URL(string: (twitterUser["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        cell.userLabel.text = twitterUser["name"] as? String
        cell.tweetLabel.text = tweetArray[indexPath.row]["text"] as! String
        
        if let imageData = data {
            cell.profileImage.image = UIImage(data: imageData)
        }
        
        return cell
    }
    
    

}
