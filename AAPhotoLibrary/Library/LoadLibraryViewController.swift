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
    var dataSource = [PHAssetCollection]()
    var currentCollection: PHAssetCollection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        PHPhotoLibrary.fetchCollectionsByType(.smartAlbum, includeHiddenAssets: false, sortByName: true) { (fetchResults, error) in
            if error == nil {
                fetchResults?.enumerateObjects({ (collection, index, stop) in
                    if !stop.pointee.boolValue {
                        self.dataSource.append(collection)
                    }
                    
                    if index == fetchResults!.count - 1 {
                        stop.pointee = true
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! AALibraryItemCell
        let currentItem = dataSource[(indexPath as NSIndexPath).row]
        
        cell.libraryItemTitle.text = currentItem.localizedTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentCollection = dataSource[(indexPath as NSIndexPath).row]
        openLibraryAssets()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let assetPhotoViewController = segue.destination as! AALibraryAssetsViewController
        assetPhotoViewController.collectionId = currentCollection?.localIdentifier
    }
    
    func openLibraryAssets() {
        self.performSegue(withIdentifier: "com.load.assets", sender: nil)
    }
}
