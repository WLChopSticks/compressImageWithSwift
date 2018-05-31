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
        
        let statusImage = UIImage(contentsOfFile: "/Users/wanglei/Desktop/status")
        
        
        let paths = getAllFilePath(dirPath: "/Users/wanglei/Desktop/img")
        for path in paths
        {
            imagePath = path
            if var savedImage = UIImage(contentsOfFile: path)
            {
                //目前模拟器截出的手机宽为1242
                if savedImage.size.width != 1242
                {
                    savedImage = captureImageWithoutStatusBar(currentImage: savedImage, statusBarImage: statusImage!, statusBarHeight: 25)
                    compressImage(currentImage: savedImage, newSize: CGSize(width: 2048, height: 2732), imageName: "")

                }else
                {
                    savedImage = captureImageWithoutStatusBar(currentImage: savedImage, statusBarImage: statusImage!, statusBarHeight: 50)
                    compressImage(currentImage: savedImage, newSize: CGSize(width: 1242, height: 2208), imageName: "")
                }
            }
        }
        print("done")
        
        
    }
    
    private func getAllFilePath(dirPath: String) -> [String]
    {
        var filePaths = [String]()
        var isDir:ObjCBool = true
        
        do {
            let array = try FileManager.default.contentsOfDirectory(atPath: dirPath)
            for fileName in array
            {
                let fullPath = "\(dirPath)/\(fileName)"
                if FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDir)
                {
                    if isDir.boolValue
                    {
                        let tempPath: [String] = getAllFilePath(dirPath: fullPath)
                        for path in tempPath
                        {
                            filePaths.append(path)
                        }
                        
                    }else
                    {
                        filePaths.append(fullPath)
                    }
                }
//                if FileManager.default.fileExists(atPath: fullPath )
//                {
//                    filePaths.append(fullPath)
//                }
                
                
            }
    
        } catch let error as NSError {
            print("get file path error: \(error)")
        }
        return filePaths
    }
    
    private func captureImageWithoutStatusBar(currentImage: UIImage, statusBarImage: UIImage, statusBarHeight: Int) -> UIImage
    {
        UIGraphicsBeginImageContext(CGSize(width: currentImage.size.width, height: currentImage.size.height))
        currentImage.draw(at: CGPoint(x: 0, y: 0))
        statusBarImage.draw(in: CGRect(x: 0, y: 0, width: Int(currentImage.size.width), height: statusBarHeight))
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage!
        
        
//        let screenScale = UIScreen.main.scale
//        let sourceImageRef: CGImage = currentImage.cgImage!
//        let index = newView!.superview!.subviews.index(of: newView!)!
//        let subImageFrame = CGRect.init(x: 0, y: 25, width: sourceImageRef.width, height: sourceImageRef.height)
//
//        ///核心代码就一句
//        let subImage = UIImage.init(cgImage:sourceImageRef.cropping(to: subImageFrame)!)
//
//
//        return subImage

        
        
//        let sourceImageRef: CGImage = currentImage.cgImage!
//        let newImage: CGImage = sourceImageRef.cropping(to: CGRect(x: 0, y: 0, width: sourceImageRef.width, height: sourceImageRef.height))!
//        return UIImage.init(cgImage: newImage)
        
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

