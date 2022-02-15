//
//  FileStorage.swift
//  Messenger
//
//  Created by Олег Федоров on 15.02.2022.
//

import Foundation
import FirebaseStorage

let storage = Storage.storage()

class FileStorage {
    
    class func uploadImage(
        _ image: UIImage, directory: String,
        completion: @escaping (_ documentLink: String?) -> Void
    ) {
        let storageRef = storage.reference(forURL: KEY_FILE_REFERENCE).child(directory)
        
        guard
            let imageData = image.jpegData(compressionQuality: 0.6)
        else { return }
        
        var task: StorageUploadTask!
        task = storageRef.putData(imageData, metadata: nil) { metadata, error in
            
            task.removeAllObservers()
            ProgressHUD.dismiss()
            
            if error != nil {
                print("error uploading image \(error?.localizedDescription ?? "")")
                return
            }
            
            storageRef.downloadURL { url, error in
                
                guard let downloadUrl = url else {
                    completion(nil)
                    return
                }
                
                completion(downloadUrl.absoluteString)
            }
        }
        
        task.observe(StorageTaskStatus.progress) { snapshot in
            
            guard
                let completedUnitCount = snapshot.progress?.completedUnitCount,
                let totalUnitCount = snapshot.progress?.totalUnitCount
            else { return }
            
            let progress = completedUnitCount / totalUnitCount
            
            ProgressHUD.showProgress(CGFloat(progress))
        }
    }
}
