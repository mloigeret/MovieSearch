//
//  UIImageView+Networking.swift
//  MovieSearch
//
//  Created by Manuel Loigeret on 2021-08-17.
//

import UIKit

extension UIImageView {
    
    private class ImageCache {
        private let _cache = NSCache<NSString, UIImage>()
        private var _observer: NSObjectProtocol?

        static let shared = ImageCache()

        private init() {
            _observer = NotificationCenter.default.addObserver(forName: UIApplication.didReceiveMemoryWarningNotification,
                                                               object: nil,
                                                               queue: nil) { [weak self] notification in
                self?._cache.removeAllObjects()
            }
        }

        deinit {
            guard let observer = _observer else {return}
            NotificationCenter.default.removeObserver(observer)
        }

        func image(forKey key: String) -> UIImage? {
            return _cache.object(forKey: key as NSString)
        }

        func save(image: UIImage, forKey key: String) {
            _cache.setObject(image, forKey: key as NSString)
        }
    }

    private static var _taskAssociationKey: UInt8 = 0
    private static var _urlAssociationKey: UInt8 = 0

    private var _currentTask: URLSessionTask? {
        get { return objc_getAssociatedObject(self, &UIImageView._taskAssociationKey) as? URLSessionTask }
        set { objc_setAssociatedObject(self, &UIImageView._taskAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private var _currentURL: URL? {
        get { return objc_getAssociatedObject(self, &UIImageView._urlAssociationKey) as? URL }
        set { objc_setAssociatedObject(self, &UIImageView._urlAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func downloadImage(from urlString: String?, placeholder: UIImage?) {
        guard let urlString = urlString,
            let url = URL(string: urlString) else { return }
        dowmloadImage(from: url, placeholder: placeholder)
    }
    
    func dowmloadImage(from url: URL?, placeholder: UIImage?) {
        guard let url = url else { return }
        _currentTask?.cancel()
        _currentTask = nil
        self.image = placeholder
        
        if let cachedImage = ImageCache.shared.image(forKey: url.absoluteString) {
            self.image = cachedImage
            return
        }
        
        _currentURL = url
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            self?._currentTask = nil
            if let error = error {
                if (error as NSError).domain == NSURLErrorDomain && (error as NSError).code == NSURLErrorCancelled { return }
                print(error)
                return
            }
            
            guard let data = data,
                  let downloadedImage = UIImage(data: data) else {
                print("Couldn't retrieve image")
                return
            }

            ImageCache.shared.save(image: downloadedImage, forKey: url.absoluteString)

            if url == self?._currentURL {
                DispatchQueue.main.async {
                    self?.image = downloadedImage
                }
            }
        }
        _currentTask = task
        task.resume()
    }
}
