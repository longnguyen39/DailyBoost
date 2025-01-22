//
//  ImageManager.swift
//  Daily Boost
//
//  Created by Long Nguyen on 1/6/25.
//

import UIKit
import Firebase
import FirebaseStorage

let imageCache = NSCache<AnyObject, UIImage>() //no duplicate img downloaded

class ThemeManager: @unchecked Sendable { //to silent warning
        
    static let shared = ThemeManager()
    
//MARK: - Public func
    
    func uploadThemeImage(theme: Theme, image: UIImage, completion: @escaping (_ success: Bool) -> ()) {
        
        //put uploadImage to background thread
        DispatchQueue.global(qos: .userInteractive).async {
            
            self.uploadImage(themeTitle: theme.title, image: image) { successImg, fileName in
                
                if !successImg {
                    completion(false)
                    return
                }
                
                var themeF = theme
                themeF.fileName = fileName
                self.uploadThemeImgData(theme: themeF) { success in
                    DispatchQueue.main.async {
                        //put completion back in main thread (relate to UI update)
                        completion(success)
                    }
                }
            }
        }
    }
    
    func fetchAThemeImage(themeTitle: String, fileName: String, completion: @escaping (_ image: UIImage?) -> ()) {
        let path = Storage.storage().reference(withPath: "/theme_images/\(themeTitle)/\(fileName)")
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.downloadImage(path: path) { fetchImg in
                DispatchQueue.main.async {
                    completion(fetchImg)
                }
            }
        }
        
    }
    
    
//MARK: - Private func
    
    //darkText is string, but has value "true" and "false"
    private func uploadThemeImgData(theme: Theme, completion:  @escaping (_ success: Bool) -> ()) {
        
        let ref1 = Firestore.firestore().collection(DB_Theme.coll).document(theme.title)
        let data1: [String: Any] = [
            DB_Theme.title: theme.title
        ]
        
        //all data2 must be same as model Theme
        let ref2 = ref1.collection(DB_Theme.img).document(theme.fileName)
        let data2: [String: Any] = [
            DB_Theme.fileName: theme.fileName,
            DB_Theme.darkText: theme.isDarkText,
            DB_Theme.title: theme.title
        ]
        
        ref1.setData(data1) { err in
            if let e = err?.localizedDescription {
                print("DEBUG_22: data1 err: \(e)")
                completion(false)
                return
            }
            
            ref2.setData(data2) { err in
                if let e = err?.localizedDescription {
                    print("DEBUG_22: data2 err: \(e)")
                    completion(false)
                    return
                }
                print("DEBUG_22: success upload themeImgData to Firestore")
                completion(true)
            }
        }
    }
    
    private func uploadImage(themeTitle: String, image: UIImage, completion: @escaping (_ success: Bool, _ fileName: String) -> ()) {
        
        var compression: CGFloat = 1.0
        let maxFileSize: Int = 4 * 1024 * 1024 //max size that we want to save
        let maxCompression: CGFloat = 0.5 //max compression
                
        guard var originalData = image.jpegData(compressionQuality: compression) else {
            print("DEBUG_22: error getting og data from img")
            completion(false, "")
            return
        }
        
        //check max file size (originalData.count is fileSize)
        while (originalData.count > maxFileSize) && (compression > maxCompression) {
            compression -= 0.05 //reduce 5% of the OG img
            if let compressData = image.jpegData(compressionQuality: compression) {
                originalData = compressData
            } //only compress if OG img > max size, and no compress smaller than 0.5. If an img is compressed from 1 -> 0.5 and still bigger than maxFileSize, we take it
            print("DEBUG_22: compression \(compression)")
        }
        
        //from 0 to 1, with 1 being the highest quality
        guard let finalData = image.jpegData(compressionQuality: compression) else {
            print("DEBUG_22: error getting final data from img")
            completion(false, "")
            return
        }
        
        //upload path and action
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/theme_images/\(themeTitle)/\(filename)")
        
        ref.putData(finalData, metadata: metadata) { _, error in
            if let e = error?.localizedDescription {
                print("DEBUG_22: error img \(e)")
                completion(false, "")
                return
            } else {
                print("DEBUG_22: success upload img to storage")
                completion(true, filename)
                return
            }
            
        }
    }
    
    private func downloadImage(path: StorageReference, handler: @escaping (_ image: UIImage?) -> ()) {
        
        if let cacheImage = imageCache.object(forKey: path) {
            print("DEBUG_22: img found in cache")
            handler(cacheImage) //no need download again
            return
        } else { //new img, so locally download it into cache
            let fileSize: Int64 = 27 * 1024 * 1024 //biggest size
            path.getData(maxSize: fileSize) { fetchImgData, error in
                if let data = fetchImgData, let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: path) //save to cache
                    handler(image)
                    return
                } else {
                    print("DEBUG_22: error getting data of img")
                    handler(nil)
                    return
                }
            }
        }
        
    }
    
    
}
