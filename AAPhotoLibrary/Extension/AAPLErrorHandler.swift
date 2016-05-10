//
//  AAPLErrorHandler.swift
//  AAPhotoLibrary
//
//  Created by Armen Abrahamyan on 5/7/16.
//  Copyright © 2016 Armen Abrahamyan. All rights reserved.
//

import Foundation


enum AAPLErrorHandler: RawRepresentable {
    
    case AARestricted
    case AADenied
    case AADataNotConvertible
    case AAForceAccessDenied
    case AAUnableDeleteCollection
    case AAUnableDeleteAsset
    case AAGeneralError
    
    typealias RawValue = NSError
    var rawValue: RawValue {
        switch self {
            case .AARestricted:
            return NSError(domain: "com.aaphotolibrary", code: -771, userInfo: ["error": "Impossible to access the Photo Library, please make sure that you don't expilicitly deneid access or there is no specific parenthal control enabled !"])
            case .AADenied:
               return NSError(domain: "com.aaphotolibrary", code: -772, userInfo: ["error": "Access is manually restricted by User."])
            case .AAForceAccessDenied:
                return NSError(domain: "com.aaphotolibrary", code: -773, userInfo: ["error": "Failed to force authorize an access to photo library. Check parenthal controls."])
            case .AADataNotConvertible:
                return NSError(domain: "com.aaphotolibrary", code: -774, userInfo: ["error": "Problem converting NSData into UIImage, please make sure that data is not corrupted."])
            case .AAUnableDeleteCollection:
                return NSError(domain: "com.aaphotolibrary", code: -775, userInfo: ["error": "Unable to delete collection. Found collection is nil"])
            case .AAUnableDeleteAsset:
                return NSError(domain: "com.aaphotolibrary", code: -776, userInfo: ["error": "Unable to delete an asset. No assets found"])
            case .AAGeneralError:
                return NSError(domain: "com.aaphotolibrary", code: -777, userInfo: ["error": "Unknown problem occures"])
            
        }
    }
    
    init?(rawValue: RawValue) {
        switch rawValue {
            case -771: self = .AARestricted
            case -772: self = .AADenied
            case -773: self = .AAForceAccessDenied
            case -774: self = .AADataNotConvertible
            case -775: self = .AAUnableDeleteCollection
            case -776: self = .AAUnableDeleteAsset
            
            default: self = .AAGeneralError
        }
    }
    
}