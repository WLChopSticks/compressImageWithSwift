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
    var logView: UITextView?;
    var log: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.logView = UITextView(frame: self.view.bounds)
//        self.logView?.backgroundColor = UIColor.gray
        self.view.addSubview(self.logView!)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.startProcess()
        
        self.addLogToTheView(imagePath: "done!!!\ndone!!!\ndone!!!")
    
    }
    
    private func startProcess()
    {
        let statusImage_ios = UIImage(named: "status-ios");
        var statusImage_Android = UIImage(named: "status-android");
        let statusImage_nav = UIImage(named: "status-android-nav");
        let paths = getAllFilePath(dirPath: "/Users/wanglei/Desktop/img")
        for path in paths
        {
            imagePath = path
            if var savedImage = UIImage(contentsOfFile: path)
            {
                if path.contains("iOS")
                {
                    //目前模拟器截出的手机宽为1242
//                    if savedImage.size.width != 621 && savedImage.size.width != 1242
                    if path.contains("iPad")
                    {
                        savedImage = captureImageWithoutStatusBar(currentImage: savedImage, statusBarImage: statusImage_ios!, statusBarHeight: 25)
                        compressImage(currentImage: savedImage, newSize: CGSize(width: 2048, height: 2732), imageName: "")
                        
                        self.addLogToTheView(imagePath: path)
                        
                    }else if path.contains("iPhone")
                    {
                        savedImage = captureImageWithoutStatusBar(currentImage: savedImage, statusBarImage: statusImage_ios!, statusBarHeight: 50)
                        compressImage(currentImage: savedImage, newSize: CGSize(width: 1242, height: 2208), imageName: "")
                        self.addLogToTheView(imagePath: path)
                    }
                }
                if path.contains("Android")
                {
                    //如果文件名字带!!!, 则使用更黑的图片涂抹
                    var statusimage = statusImage_Android
                    
                    if path.contains("!")
                    {
                        statusimage = statusImage_nav
                    }
                    
                    //目前模拟器截出的手机宽为1242
                    //if savedImage.size.width == 1440
                    if path.contains("5.5inch")
                    {
                        savedImage = captureImageWithoutStatusBar(currentImage: savedImage, statusBarImage: statusimage!, statusBarHeight: 100)
                        compressImage(currentImage: savedImage, newSize: CGSize(width: 1440, height: 2560), imageName: "")
                        self.addLogToTheView(imagePath: path)
                        
                    }
//                    else if savedImage.size.width == 1200
                    else if path.contains("7inch")
                    {
                        savedImage = captureImageWithoutStatusBar(currentImage: savedImage, statusBarImage: statusimage!, statusBarHeight: 50)
                        compressImage(currentImage: savedImage, newSize: CGSize(width: 1200, height: 1920), imageName: "")
                        self.addLogToTheView(imagePath: path)
                    }
//                    else if savedImage.size.width == 1600
                    else if path.contains("10inch")
                    {
                        savedImage = captureImageWithoutStatusBar(currentImage: savedImage, statusBarImage: statusimage!, statusBarHeight: 50)
                        compressImage(currentImage: savedImage, newSize: CGSize(width: 1600, height: 2560), imageName: "")
                        self.addLogToTheView(imagePath: path)
                    }
                }
                
            }
        }
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
    
    private func addLogToTheView(imagePath: String)
    {
        RunLoop.current.run(until: NSDate.distantPast)
        let log_temp = "\nfinish done with image for path " + imagePath
        self.log.append(log_temp)
        self.logView?.text = self.log

        self.logView?.layoutManager.allowsNonContiguousLayout = false
    self.logView?.scrollRangeToVisible(NSMakeRange((self.logView?.text.lengthOfBytes(using: .utf8))!, 10))
        
        print(log_temp)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

