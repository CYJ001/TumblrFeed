//
//  PhotosViewController.swift
//  TumblrFeed
//
//  Created by Jessica Yeh on 6/21/17.
//  Copyright © 2017 Jessica Yeh. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    
    
    
    @IBOutlet weak var loadingMoreIndict: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var isMoreDataLoading = false
    
    
    var posts: [[String: Any]] = []
    var offsetNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
         let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        let urlString = "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"+"&offset="+String(offsetNum)
        offsetNum = offsetNum + 20
        let url = URL(string: urlString)!
        let session = URLSession(configuration: .default,    delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print(dataDictionary)
                
                // TODO: Get the posts and store in posts property
                // Get the dictionary from the response key
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                // Store the returned array of dictionaries in our posts property
                self.posts = responseDictionary["posts"] as! [[String: Any]]
                
                // TODO: Reload the table view
                self.tableView.reloadData()
            }
        }
        tableView.delegate = self
        tableView.dataSource = self
        
        task.resume()
        // Do any additional setup after loading the view.
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Handle scroll behavior here
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                loadingMoreIndict.startAnimating()
                
            loadMoreData()
            // ... Code to load more results ...
            
        }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
let vc = segue.destination as! PhotoDetailViewController
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
         let post = posts[indexPath.row]
        if let photos = post["photos"] as? [[String:Any]]
        {
            let photo = photos[0]
            let originalSize = photo["original_size"] as! [String:Any]
            
            let urlString = originalSize["url"] as! String
            let url = URL(string: urlString)
            vc.photoURL = url!
        }

    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func loadMoreData() {
            
            // ... Create the NSURLRequest (myRequest) ...
            
            // Configure session so that completion handler is executed on main UI thread
        let urlString = "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"+"&offset="+String(offsetNum)
        offsetNum = offsetNum + 20
        let url = URL(string: urlString)!
    let session = URLSession(configuration: .default,    delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print(dataDictionary)
                self.isMoreDataLoading = false
                self.loadingMoreIndict.stopAnimating()
                // TODO: Get the posts and store in posts property
                // Get the dictionary from the response key
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                // Store the returned array of dictionaries in our posts property
                self.posts = self.posts + (responseDictionary["posts"] as! [[String: Any]])
                
                self.isMoreDataLoading = false
                // TODO: Reload the table view
                self.tableView.reloadData()
            }
        }
        task.resume()
        }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
       
    }
    /*func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }*/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoTableViewCell", for: indexPath) as! PhotoTableViewCell
        let post = posts[indexPath.row]
        if let photos = post["photos"] as? [[String:Any]]
        {
            let photo = photos[0]
            let originalSize = photo["original_size"] as! [String:Any]
            
            let urlString = originalSize["url"] as! String
            let url = URL(string: urlString)
            cell.PhotoTableViewCell.af_setImage(withURL:url!)
        }
        
        
        return cell
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        let urlString = "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"+"&offset="+String(offsetNum)
        offsetNum = offsetNum + 20
        let url = URL(string: urlString)!
        // ... Create the URLRequest `myRequest` ...
        
        // Configure session so that completion handler is executed on main UI thread
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
         let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print(dataDictionary)
                
                // TODO: Get the posts and store in posts property
                // Get the dictionary from the response key
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                // Store the returned array of dictionaries in our posts property
                self.posts = responseDictionary["posts"] as! [[String: Any]]
                
                // TODO: Reload the table view
                self.tableView.reloadData()
            }
        
            // ... Use the new data to update the data source ...
            
            // Reload the tableView now that there is new data
            self.tableView.reloadData()
            
            // Tell the refreshControl to stop spinning
            refreshControl.endRefreshing()
        }
        task.resume()




    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
}
