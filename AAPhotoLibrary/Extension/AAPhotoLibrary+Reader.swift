//
//  AAPhotoLibrary+Reader.swift
//  AAPhotoLibrary
//
//  Created by Armen Abrahamyan on 5/7/16.
//  Copyright © 2016 Armen Abrahamyan. All rights reserved.
//

import Foundation
import Photos

/**
** This extension is responsible for reading photo library content
**/
extension PHPhotoLibrary {
    
    // MARK: Public methods    
    /**
    * Fetch All Collections
    */
    @objc
    public final class func fetchCollectionsByType(let type:PHAssetCollectionType, let includeHiddenAssets: Bool, let sortByName: Bool, completion: (fetchResults: PHFetchResult?, error: NSError?) -> Void) {
    
        checkAuthorizationStatus { (authorizationStatus, error) in
            
            guard authorizationStatus == .Authorized else {
                completion(fetchResults: nil, error: error)
                print("Impossible to access the Photo Library, please make sure that you don't expilicitly deneid access or there is no specific parenthal control enabled !")
                return
            }
            
            let options = PHFetchOptions()
            options.includeHiddenAssets = includeHiddenAssets
            
            if sortByName {
                options.sortDescriptors = [NSSortDescriptor(key: "localizedTitle", ascending: true)]
            }
            
            let collection = PHAssetCollection.fetchAssetCollectionsWithType(type, subtype: .Any, options: options)
            completion(fetchResults: collection, error: nil)
        }
        
    }
    
    /**
    * Fetches all images from collection
    */
    @objc
    public final class func fetchAllItemsFromCollection(let collectionType: PHAssetCollectionType, let collectionId: String, sortByDate: Bool, completion: (fetchResult: PHFetchResult?, error: NSError?) -> Void) {
        
        checkAuthorizationStatus { (authorizationStatus, error) in
            let collection = findCollectionById(collectionId, collectionType: collectionType)
            if collection != nil {
                let options = PHFetchOptions()
                
                if sortByDate {
                    options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
                }
                
                let fetchResult = PHAsset.fetchAssetsInAssetCollection(collection!, options: options)
                completion(fetchResult: fetchResult, error: error)
            }
        }
    }
    
    /**
    * Get an image from asset identifier
    //PHImageManagerMaximumSize
    */
    @objc
    public class func imageFromAssetIdentifier(let asstItemIdentifeir: String, let size: CGSize, completion: (image: UIImage?, info:[NSObject: AnyObject]?) -> Void) {
        checkAuthorizationStatus { (authorizationStatus, error) in
            let options = PHFetchOptions()
            options.predicate = NSPredicate(format: "localIdentifier=%@", asstItemIdentifeir)
            let fetchResult = PHAsset.fetchAssetsWithOptions(options)
            
            if let asset = fetchResult.firstObject as? PHAsset {
                imageFromAsset(asset, size: size, completion: completion)
            }
        }
    }
    
    // TODO: MOVE REQUEST OPTIONS AS ARGUMENTS
    /**
     * Retrieves an original image from an asset object
     */
    @objc
    public class func imageFromAsset(let asset: PHAsset, let size: CGSize, completion: (image: UIImage?, info: [NSObject: AnyObject]?) -> Void) {
       checkAuthorizationStatus { (authorizationStatus, error) in
        if asset.mediaType == .Image {
            let requestOptions = PHImageRequestOptions()
            requestOptions.resizeMode = .Exact
            requestOptions.deliveryMode = .HighQualityFormat
            requestOptions.synchronous = false
            
            PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: size, contentMode: .Default, options: requestOptions, resultHandler: { (image, info) in
                completion(image: image, info: info)
            })
        } else {
            completion(image: nil, info: ["error": "Asset is not of an image type."])
        }
       }
    }
    
    /**
    * Retrieves a video from an Asset object
    */
    @objc
    public class func videoFromAsset(let asset: PHAsset, completion: (avplayerItem: AVPlayerItem?, info: [NSObject: AnyObject]?) -> Void) {
        checkAuthorizationStatus { (authorizationStatus, error) in
            if asset.mediaType == .Video {
                let requestOptions = PHVideoRequestOptions()
                requestOptions.deliveryMode = .HighQualityFormat
                
                PHImageManager.defaultManager().requestPlayerItemForVideo(asset, options: requestOptions, resultHandler: { (avplayerItem, info) in
                    completion(avplayerItem: avplayerItem, info: info)
                })
            } else {
                completion(avplayerItem: nil, info: ["error": "Asset is not of an image type."])
            }
        }
    }
    
    /**
     * Check Authorization status
     */
    @objc
    public final class func checkAuthorizationStatus(completion: (authorizationStatus: PHAuthorizationStatus, error: NSError?) -> Void) {
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch (status) {
        case .NotDetermined:
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) in
                completion(authorizationStatus: status, error: AAPLErrorHandler.AAForceAccessDenied.rawValue)
            })
            break
            
        case .Authorized:
            completion(authorizationStatus: status, error: nil)
            break
            
        case .Restricted:
            print("Access is restricted: Maybe parental controls are turned on ?")
            completion(authorizationStatus: status, error: AAPLErrorHandler.AARestricted.rawValue)
            break
            
        case .Denied:
            print("User denied an access to library")
            completion(authorizationStatus: status, error: AAPLErrorHandler.AADenied.rawValue)
            break
            
        }
    }
    
    // MARK: Private Helpers
    /**
     * Search Collection By Local Stored Identifeir
     */
    @objc
    private final class func findCollectionById (let folderIdentifier: String, let collectionType: PHAssetCollectionType) -> PHAssetCollection? {
        var collection: PHAssetCollection?
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "localIdentifier=%@", folderIdentifier)
        collection = PHAssetCollection.fetchAssetCollectionsWithType(collectionType, subtype: .Any, options: fetchOptions).firstObject as? PHAssetCollection
        
        return collection
    }
}