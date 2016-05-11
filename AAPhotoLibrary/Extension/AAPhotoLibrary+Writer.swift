//
//  AAPhotoLibrary.swift
//  Depositphotos
//
//  Created by Armen Abrahamyan on 4/26/16.
//  Copyright © 2016 Depositphotos Inc. All rights reserved.
//

import Foundation
import Photos

/**
 ** This extension is responsible for writing items into photo library
 **/
extension PHPhotoLibrary {
    
    // MARK: Public save into album methods
    
    /**
     * Check and decide what to do based on Authorization Status
     */
    @objc
    public final class func addNewImage(let folderName: String, let image: UIImage, completion: (success: Bool, error: NSError?) -> Void) {
        checkAuthorizationStatusAndSaveImage(folderName, image: image, videoFileUrl: nil, completion: completion)
    }
    
    /**
     * Accepts folder name and image data and stores in appropriate folder
     */
    @objc
    public class func addNewImage(let folderName: String, let itemData: NSData, let completion:(success: Bool, error: NSError?) -> Void) {
        
        if let image = convertDataToImage(itemData) {
            addNewImage(folderName, image: image, completion: completion)
        } else {
            completion(success: false, error: AAPLErrorHandler.AADataNotConvertible.rawValue)
        }
    }
    
    /**
    * Add a new video into library
    */
    @objc
    public class func addNewVideo (let folderName: String, let videoFileUrl: NSURL, let completion:(success: Bool, error: NSError?) -> Void) {
        checkAuthorizationStatusAndSaveImage(folderName, image: nil, videoFileUrl: videoFileUrl, completion: completion)
    }
    
    /**
     * Removes Asset from Library
     */
    @objc
    public class func deleteItemFromFolder (let itemAssetId: String, let completion: (success: Bool, error: NSError?) -> Void) {
        checkAuthorizationStatus { (authorizationStatus, error) in
            sharedPhotoLibrary().performChanges({
                let options = PHFetchOptions()
                options.predicate = NSPredicate(format: "localIdentifier=%@", itemAssetId)
                let assetsToDelete = PHAsset.fetchAssetsWithOptions(options)
                
                if assetsToDelete.count > 0 {
                    PHAssetChangeRequest.deleteAssets(assetsToDelete)
                } else {
                    completion(success: false, error: AAPLErrorHandler.AAUnableDeleteAsset.rawValue)
                }
                
            }) { (completed: Bool, error: NSError?) in
                completion(success: completed, error: error)
            }
        }
    }
    
    /**
    * Removes folder by Id
    */
    @objc
    public class func deleteFolderById (let folderId: String, let completion: (success: Bool, error: NSError?) -> Void) {
        sharedPhotoLibrary().performChanges({
            
            let collections = findCollectionById(folderId)
            if collections != nil {
                PHAssetCollectionChangeRequest.deleteAssetCollections(collections!)
            } else {
                completion(success: false, error: AAPLErrorHandler.AAUnableDeleteCollection.rawValue)
            }
            
        }) { (completed: Bool, error: NSError?) in
            completion(success: completed, error: error)
        }
    }
    
    /**
    * Removes folder by Name
    * WARNING: Will remove first found folder of that name. Won't remove any folder from SmartAlbum. It is recommended that you use 'deleteFolderById' instead.
    */
    @objc
    public class func deleteFolderByName (let folderName: String, let completion: (success: Bool, error: NSError?) -> Void) {
        sharedPhotoLibrary().performChanges({
            
            let collections = findCollectionByName(folderName)
            if collections != nil {
                PHAssetCollectionChangeRequest.deleteAssetCollections(collections!)
            } else {
                completion(success: false, error: AAPLErrorHandler.AAUnableDeleteCollection.rawValue)
            }
            
        }) { (completed: Bool, error: NSError?) in
            completion(success: completed, error: error)
        }
    }

    
    // MARK: Private helper methods
    
    /** //TODO: Move method to public as users would want to find one particular collection
     * Finds collection By Id
     */
    @objc
    private final class func findCollectionById (let folderIdentifier: String) -> NSFastEnumeration? {
        return PHAssetCollection.fetchAssetCollectionsWithLocalIdentifiers([folderIdentifier], options: nil)
    }
    
    /**
     * Finds collection By Name
     */
    @objc
    private final class func findCollectionByName (let folderName: String) -> NSFastEnumeration? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title=%@", argumentArray: [folderName])
        
        return PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
    }
    
    /**
     * Decide what to save based on authorization status
     */
    @objc
    private final class func checkAuthorizationStatusAndSaveImage(let folderName: String, let image: UIImage?, let videoFileUrl: NSURL?, completion: (success: Bool, error: NSError?) -> Void) {
        
        
        checkAuthorizationStatus { (authorizationStatus, error) in
            
            switch (authorizationStatus) {
                
                case .Authorized:
                    saveItemIntoFolder(folderName, image: image, videoFileUrl: videoFileUrl, completion: completion)
                    break
                    
                case .Restricted:
                    print("Access is restricted: Maybe parental controls are turned on ?")
                    completion(success: false, error: error)
                    break
                    
                case .Denied:
                    print("User denied an access to library")
                    completion(success: false, error: error)
                    break
                
                default:
                    completion(success: false, error: error)
            }

        }
        
    }
    
    /**
     * Accepts folder name and UIImage and stores in appropriate folder
     */
    @objc
    private class func saveItemIntoFolder (let folderName: String, let image: UIImage?, let videoFileUrl: NSURL?, let completion:(success: Bool, error: NSError?) -> Void) {
        
            var fetchResults: PHFetchResult?
            findCollectionByName(folderName, collectionType: .Album, completed: { (success, collection) in
                
              sharedPhotoLibrary().performChanges({
                
                if success {
                    if collection != nil {
                        var placeHolderObject: PHObjectPlaceholder?
                        
                        if let url = videoFileUrl {
                            placeHolderObject = PHAssetChangeRequest.creationRequestForAssetFromVideoAtFileURL(url)?.placeholderForCreatedAsset
                        } else {
                            placeHolderObject = PHAssetChangeRequest.creationRequestForAssetFromImage(image!).placeholderForCreatedAsset
                        }
                        if let placeholder = placeHolderObject {
                            fetchResults = PHAsset.fetchAssetsInAssetCollection(collection!, options: nil)
                            if let photoAssets = fetchResults {
                                let folderChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: collection!, assets: photoAssets)
                                folderChangeRequest?.addAssets([placeholder])
                            }
                        }
                    }

                }
                
            }) { (completed: Bool, error: NSError?) in
                if error != nil {
                    completion(success: false, error: error)
                } else {
                    completion(success: true, error: error)
                }
            }
            })
            
    }
    
    /**
    * Private method, used for saving item into folder.
    */
    @objc
    private final class func findCollectionByName (let folderName: String, let collectionType: PHAssetCollectionType, completed: (success:Bool, collectionName: PHAssetCollection?) -> Void) {
        var collection: PHAssetCollection?
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title=%@", argumentArray: [folderName])
        collection = PHAssetCollection.fetchAssetCollectionsWithType(collectionType, subtype: .Any, options: fetchOptions).firstObject as? PHAssetCollection
        
        if collection == nil {
            var placeHolder: PHObjectPlaceholder?
            sharedPhotoLibrary().performChanges({
                let albumCreationRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(folderName)
                placeHolder = albumCreationRequest.placeholderForCreatedAssetCollection
            }) { (success: Bool, error: NSError?) in
                if success {
                    let fetchResult = PHAssetCollection.fetchAssetCollectionsWithLocalIdentifiers([placeHolder!.localIdentifier], options: nil)
                    collection = fetchResult.firstObject as? PHAssetCollection
                    completed(success: success, collectionName: collection)
                } else {
                    completed(success: false, collectionName: nil)
                }
            }
        } else {
            completed(success: true, collectionName: collection)
        }
    }
    
    /**
    * Converts image data into UIImage
    */
    @objc
    private final class func convertDataToImage (let imageData: NSData) -> UIImage? {
        return UIImage(data: imageData)
    }
    
    /**
    * Freshen image with new size and JPEG format
    */
    @objc
    private final class func freshenImageToJPEG (let image: UIImage) -> UIImage? {
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        return UIImage(data: imageData!)
    }        
    
}



