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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.identifier!)
    }
    
    @IBAction func removeItems(_ sender: AnyObject) {
        
        // NOTE: Delete AAPhotoLibrary folder bby name
        /*PHPhotoLibrary.deleteFolderByName("AAPhotoLibrary") { (success, error) in
            print(success)
        }*/
        
        //NOTE: DELETE ITEMS BY ID
        /*let arr = ["18523CE5-F955-4C64-B043-F8D10409628D/L0/001",
        "805E1708-FE2E-4309-B8CD-8DAAB4AB5605/L0/001",
        "6578FB94-51AC-4E97-85A7-6C8554C4CA90/L0/001",
        "DDC36C75-C14E-4A6F-8E62-26E70C51FFCF/L0/001"]
 
        
        for elem in arr {
            PHPhotoLibrary.deleteItemFromFolder(elem, completion: { (success, error) in
                print(success)
            })
        }*/
        
        // NOTE: Delete folder by id
        /*PHPhotoLibrary.deleteFolderById("83ADA10B-136A-4BC5-9B20-8CBB36B21B24/L0/040") { (success, error) in
            print(success)
        }*/
    }
}






