//
//  AAPhotoDetailViewController.swift
//  AAPhotoLibrary
//
//  Created by Armen Abrahamyan on 5/8/16.
//  Copyright © 2016 Armen Abrahamyan. All rights reserved.
//

import UIKit
import Photos

class AAPhotoDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var imageAsset: PHAsset?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            print(error)
        }
        activityIndicator.startAnimating()
        
        if imageAsset?.mediaType == .Image {
        
            PHPhotoLibrary.imageFromAsset(imageAsset!, size: PHImageManagerMaximumSize) { (image, info) in
                if image != nil {
                    self.imageView.image = image
                }
                
                self.activityIndicator.stopAnimating()
            }
        } else if imageAsset?.mediaType == .Video {
            imageView.hidden = true
            PHPhotoLibrary.videoFromAsset(imageAsset!, completion: { (avplayerItem, info) in
                
                dispatch_async(dispatch_get_main_queue(), { 
                    let avPlayer = AVPlayer(playerItem: avplayerItem!)
                    let avPlayerLayer = AVPlayerLayer(player: avPlayer)
                    avPlayerLayer.frame = self.view.frame
                    print(self.view.bounds)
                    self.view.layer.addSublayer(avPlayerLayer)
                    avPlayer.seekToTime(kCMTimeZero)
                    self.activityIndicator.stopAnimating()
                    avPlayer.play()
                })
            })
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
