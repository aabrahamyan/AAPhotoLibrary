//
//  AALibraryAssetsViewController.swift
//  AAPhotoLibrary
//
//  Created by Armen Abrahamyan on 5/8/16.
//  Copyright © 2016 Armen Abrahamyan. All rights reserved.
//

import UIKit
import Photos

class AALibraryAssetsViewController: UIViewController {
    
    let collectionCellIdentifeir = "assetCollectionCell"
    var collectionId: String?
    var dataSource: [PHAsset] = [PHAsset]()
    var selectedPhotoAsset: PHAsset?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PHPhotoLibrary.fetchAllItemsFromCollection(.SmartAlbum, collectionId: collectionId!, sortByDate: true) { (fetchResult, error) in
            
            if error == nil {
                fetchResult!.enumerateObjectsUsingBlock({ (asset, index, stop) in
                    if !stop.memory {
                        self.dataSource.append(asset as! PHAsset)
                    }
                })
            }
        }
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
}


extension AALibraryAssetsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionCellIdentifeir, forIndexPath: indexPath) as! AAAssetCollectionViewCell
        let asset = dataSource[indexPath.row]
        
        if asset.mediaType == .Image {
            PHPhotoLibrary.imageFromAsset(asset, size: CGSize(width: 300, height: 300)) { (image, info) in
                
                if image != nil {
                    cell.imageView.image = image
                }
            }
        } else if asset.mediaType == .Video {
        
            PHPhotoLibrary.videoFromAsset(asset, completion: { (avplayerItem, info) in
                if avplayerItem != nil {
                    let imageGen = AVAssetImageGenerator(asset: avplayerItem!.asset)
                    let time = CMTimeMakeWithSeconds(1.0, 1)
                    var actualTime: CMTime = CMTimeMake(0,0)
                    dispatch_async(dispatch_get_main_queue(), {
                        do {
                            let image = try imageGen.copyCGImageAtTime(time, actualTime: &actualTime)
                            cell.imageView.image = UIImage(CGImage: image)
                        } catch {
                            print("Problem copying image from timeframe. Video file could be corrupted.")
                        }
                    })
                }
                
            })
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedPhotoAsset = dataSource[indexPath.row]
        openPhotoDetailView()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let photoDetailVC = segue.destinationViewController as! AAPhotoDetailViewController
        photoDetailVC.imageAsset = selectedPhotoAsset
    }
    
    func openPhotoDetailView(){
        self.performSegueWithIdentifier("com.load.photo", sender: nil)
    }
    
}








