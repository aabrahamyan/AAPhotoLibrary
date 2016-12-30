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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveImage(_ sender: AnyObject) {
        
        if currentCell == nil {
            currentCell = collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? NewAssetImageCell
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

extension AddToLibraryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newAssetCell", for: indexPath) as! NewAssetImageCell
        cell.imageView.image = UIImage(named: "\((indexPath as NSIndexPath).row)")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = collectionView.frame.size.width
        currentPage = Int(collectionView.contentOffset.x / pageWidth)
        currentCell = collectionView.cellForItem(at: IndexPath(row: currentPage, section: 0)) as? NewAssetImageCell
    }
}
