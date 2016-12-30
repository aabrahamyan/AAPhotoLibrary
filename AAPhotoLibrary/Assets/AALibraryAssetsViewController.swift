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
        
        PHPhotoLibrary.fetchAllItemsFromCollection(.smartAlbum, collectionId: collectionId!, sortByDate: true) { (fetchResult, error) in
            
            if error == nil {
                fetchResult!.enumerateObjects({ (asset, index, stop) in
                    if !stop.pointee.boolValue {
                        self.dataSource.append(asset)
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifeir, for: indexPath) as! AAAssetCollectionViewCell
        let asset = dataSource[(indexPath as NSIndexPath).row]
        
        if asset.mediaType == .image {
            PHPhotoLibrary.imageFromAsset(asset, size: CGSize(width: 300, height: 300)) { (image, info) in
                
                if image != nil {
                    cell.imageView.image = image
                }
            }
        } else if asset.mediaType == .video {
        
            PHPhotoLibrary.videoFromAsset(asset, completion: { (avplayerItem, info) in
                if avplayerItem != nil {
                    let imageGen = AVAssetImageGenerator(asset: avplayerItem!.asset)
                    let time = CMTimeMakeWithSeconds(1.0, 1)
                    var actualTime: CMTime = CMTimeMake(0,0)
                    DispatchQueue.main.async(execute: {
                        do {
                            let image = try imageGen.copyCGImage(at: time, actualTime: &actualTime)
                            cell.imageView.image = UIImage(cgImage: image)
                        } catch {
                            print("Problem copying image from timeframe. Video file could be corrupted.")
                        }
                    })
                }
                
            })
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedPhotoAsset = dataSource[(indexPath as NSIndexPath).row]
        openPhotoDetailView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let photoDetailVC = segue.destination as! AAPhotoDetailViewController
        photoDetailVC.imageAsset = selectedPhotoAsset
    }
    
    func openPhotoDetailView(){
        self.performSegue(withIdentifier: "com.load.photo", sender: nil)
    }
    
}








