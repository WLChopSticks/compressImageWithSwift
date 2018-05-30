//
//  ViewController.swift
//  CompressImage
//
//  Created by 王磊 on 2018/5/30.
//  Copyright © 2018年 wanglei. All rights reserved.
//

import UIKit



class ViewController: UIViewController {

    var imagePath: String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let paths = getAllFilePath(dirPath: "/Users/wanglei/Desktop/img")
        for path in paths
        {
            imagePath = path
            if var savedImage = UIImage(contentsOfFile: path)
            {
                savedImage = captureImageWithoutStatusBar(currentImage: savedImage)
                compressImage(currentImage: savedImage, newSize: CGSize(width: 1204, height: 2142), imageName: "")
            }
        }
        print("done")
        
        
    }
    
    private func getAllFilePath(dirPath: String) -> [String]
    {
        var filePaths = [String]()
        do {
            let array = try FileManager.default.contentsOfDirectory(atPath: dirPath)
            for fileName in array
            {
                let fullPath = "\(dirPath)/\(fileName)"
                if FileManager.default.fileExists(atPath: fullPath)
                {
                    filePaths.append(fullPath)
                }
                
                
            }
    
        } catch let error as NSError {
            print("get file path error: \(error)")
        }
        return filePaths
    }
    
    private func captureImageWithoutStatusBar(currentImage: UIImage) -> UIImage
    {
        let sourceImageRef: CGImage = currentImage.cgImage!
        let newImage: CGImage = sourceImageRef.cropping(to: CGRect(x: 0, y: 0, width: sourceImageRef.width, height: sourceImageRef.height))!
        return UIImage.init(cgImage: newImage)
        
    }
    
    private func compressImage(currentImage: UIImage, newSize: CGSize, imageName: String)
    {
        UIGraphicsBeginImageContext(newSize)
        currentImage.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height));
        if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
            if let imageData = UIImageJPEGRepresentation(newImage, 0.3) as NSData?
            {
                imageData.write(toFile: imagePath, atomically: true)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

