//
//  ViewController.swift
//  AAPhotoLibrary
//
//  Created by Armen Abrahamyan on 5/7/16.
//  Copyright © 2016 Armen Abrahamyan. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var addNewItemsButton: UIButton!
    @IBOutlet weak var loadLibraryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //com.addnew.items
    //com.load.lib
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(segue.identifier)
    }
    
    @IBAction func removeItems(sender: AnyObject) {
        
        /*PHPhotoLibrary.deleteFolderByName("AAPhotoLibrary") { (success, error) in
            
            print(success)
            print(error)
        }*/
        
        /*let arr = ["540F47BA-E968-4A65-B5A9-BB3B79CC3583/L0/001",
        "D7E0CACD-59BB-43AB-B27C-3F6F4B3617A5/L0/001",
        "1A8408F9-3E08-4EED-9375-2C100343A9FB/L0/001",
        "B7F58967-38BF-4C38-818C-BA9EFB3D71DC/L0/001",
        "49A8022C-3CDA-4C9E-98F9-550C180F1801/L0/001",
        "95CF8ADF-B407-4C5F-AC21-87129EA80F5D/L0/001"]
        
        for elem in arr {
            PHPhotoLibrary.deleteItemFromFolder(elem, completion: { (success, error) in
                print(success)
            })
        }*/
        
        /*PHPhotoLibrary.deleteFolderById("83ADA10B-136A-4BC5-9B20-8CBB36B21B24/L0/040") { (success, error) in
            print(success)
        }*/
    }
}






