//
//  LoadLibraryViewController.swift
//  AAPhotoLibrary
//
//  Created by Armen Abrahamyan on 5/8/16.
//  Copyright © 2016 Armen Abrahamyan. All rights reserved.
//

import UIKit
import Photos

class LoadLibraryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifier = "libraryItemCell"
    var dataSource:[PHAssetCollection] = [PHAssetCollection]()
    var currentCollection: PHAssetCollection?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        PHPhotoLibrary.fetchCollectionsByType(.Album, includeHiddenAssets: false, sortByName: true) { (fetchResults, error) in
            if error == nil {
                fetchResults?.enumerateObjectsUsingBlock({ (collection, index, stop) in
                
                    if !stop.memory {
                        self.dataSource.append(collection as! PHAssetCollection)                                               
                    }
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoadLibraryViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! AALibraryItemCell
        let currentItem = dataSource[indexPath.row]
        
        cell.libraryItemTitle.text = currentItem.localizedTitle
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentCollection = dataSource[indexPath.row]
        openLibraryAssets()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let assetPhotoViewController = segue.destinationViewController as! AALibraryAssetsViewController        
        assetPhotoViewController.collectionId = currentCollection?.localIdentifier
    }
    
    func openLibraryAssets() {
        self.performSegueWithIdentifier("com.load.assets", sender: nil)
    }
}















