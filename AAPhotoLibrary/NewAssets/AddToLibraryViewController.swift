//
//  AddToLibraryViewController.swift
//  AAPhotoLibrary
//
//  Created by Armen Abrahamyan on 5/8/16.
//  Copyright © 2016 Armen Abrahamyan. All rights reserved.
//

import UIKit
import Photos

class AddToLibraryViewController: UIViewController {
    
    var currentCell: NewAssetImageCell?
    var currentPage:Int = 0
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveImage(sender: AnyObject) {
        
        if currentCell == nil {
            currentCell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? NewAssetImageCell
        }
        
        if let cell = currentCell {
            PHPhotoLibrary.addNewImage("AAPhotoLibrary", image: cell.imageView.image!, completion: { (success, error) in
                if error != nil {
                    print("Success = \(success)")
                }
            })
        }
    }
}

extension AddToLibraryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("newAssetCell", forIndexPath: indexPath) as! NewAssetImageCell
        cell.imageView.image = UIImage(named: "\(indexPath.row)")
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let pageWidth = collectionView.frame.size.width
        currentPage = Int(collectionView.contentOffset.x / pageWidth)
        currentCell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: currentPage, inSection: 0)) as? NewAssetImageCell
    }
}
