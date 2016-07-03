//
//  ViewController.swift
//  图片涂鸦 录音的播放
//
//  Created by hznucai on 16/2/22.
//  Copyright © 2016年 hznucai. All rights reserved.
//

import UIKit
import AVFoundation
typealias sendHomeWork = (image:UIImage) -> Void
class ViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    var player:AVAudioPlayer?
    @IBOutlet weak var resultImaegeView:UIImageView?
    @IBOutlet weak var cropper:ImageCropperView?
    @IBOutlet weak var saveCrop:UIButton?
    var resultImage = UIImage()
    var correctImage = UIImage()
    var sendPhoto:sendHomeWork!
    var locationX = NSMutableArray()
    var locationY = NSMutableArray()
    override func viewDidLoad() {
        self.cropper?.hidden = true
        super.viewDidLoad()
        self.resultImage = UIImage(named: "1")!
        self.resultImaegeView?.image = self.resultImage
        saveCrop?.hidden = true
        //self.correctImage = UIImage()
        cropper?.reset()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func selectPhoto(sender:UIButton){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.Camera){
            imagePicker.sourceType = .Camera
        }else{
            imagePicker.sourceType = .PhotoLibrary
        }
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    //选取图片
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.resultImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        self.resultImaegeView?.image = self.resultImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    //旋转图片
    @IBAction func rotate(sender:UIButton) {
            var tempImage:UIImage?
            let scale:CGFloat = 1.0
            let currentImage = self.resultImage
            switch(currentImage.imageOrientation){
        case .Up:
            tempImage = UIImage(CGImage: (currentImage.CGImage)!, scale:
                scale, orientation: UIImageOrientation.Right)
        case .Down:
            tempImage = UIImage(CGImage: currentImage.CGImage!, scale: scale, orientation:  UIImageOrientation.Left)
        case .Left:
            tempImage = UIImage(CGImage: currentImage.CGImage!, scale: scale, orientation:  UIImageOrientation.Up)
        case .Right:
            tempImage = UIImage(CGImage: currentImage.CGImage!, scale: scale, orientation:  UIImageOrientation.Down)
        case .UpMirrored:
            tempImage = UIImage(CGImage: currentImage.CGImage!, scale: scale, orientation:  UIImageOrientation.RightMirrored)
        case .DownMirrored:
            tempImage = UIImage(CGImage: currentImage.CGImage!, scale: scale, orientation:UIImageOrientation.LeftMirrored)
        case .LeftMirrored:
            tempImage = UIImage(CGImage: currentImage.CGImage!, scale: scale, orientation:  UIImageOrientation.UpMirrored)
        case .RightMirrored:
            tempImage = UIImage(CGImage: currentImage.CGImage!, scale: scale, orientation:  UIImageOrientation.DownMirrored)
        }
        self.resultImage = tempImage!
        resultImaegeView!.image  = tempImage
    }
    @IBAction func crop(sender:UIButton) {
        resultImaegeView?.hidden = true
        self.cropper?.hidden = false
        self.cropper?.setup()
        self.cropper?.image = self.resultImage
        self.cropper?.layer.borderColor = UIColor.blackColor().CGColor
        self.cropper?.layer.borderWidth = 1.0
        self.saveCrop?.hidden = false
        self.saveCrop?.addTarget(self, action: #selector(ViewController.savedCrop(_:)), forControlEvents: .TouchUpInside)
    }
    func savedCrop(sender:UIButton) {
        if (sender.currentTitle == "保存裁剪"){
            cropper?.finishCropping()
            self.resultImage = (cropper?.croppedImage)!
            self.resultImaegeView?.image = self.resultImage
            cropper?.hidden = true
            self.resultImaegeView?.hidden = false
        sender.setTitle("保存成功", forState: .Normal)
        }else{
            cropper?.hidden = false
            cropper!.reset()
}
    }
    @IBAction func savedHomeWork(sender:UIButton){
        let tea = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("teacher") as! teacherViewController
        tea.resultImage = self.resultImage
        //self.sendPhoto(image:self.resultImage)
            self.presentViewController(tea, animated: true, completion: nil)
    }
    @IBAction func showCorrect(sender:UIButton){
        let hasCorrectImageView = UIImageView(frame: self.resultImaegeView!.frame)
        hasCorrectImageView.image = self.correctImage
        self.resultImaegeView?.addSubview(hasCorrectImageView)
     var i = Int()
        for(i = 0; i < locationX.count;i += 1){
            let locx = locationX.objectAtIndex(i) as! CGFloat
            let locy = locationY.objectAtIndex(i) as! CGFloat
            let playButton = UIButton(frame: CGRectMake(locx,locy,20,20))
            playButton.backgroundColor = UIColor.blueColor()
            playButton.tintColor = UIColor.whiteColor()
            playButton.setTitle("play", forState: .Normal)
            playButton.tag = i
            playButton.addTarget(self, action: #selector(ViewController.play(_:)), forControlEvents: .TouchUpInside)
            hasCorrectImageView.addSubview(playButton)
            resultImaegeView?.multipleTouchEnabled = true
            resultImaegeView?.userInteractionEnabled = true
            hasCorrectImageView.userInteractionEnabled = true
            hasCorrectImageView.multipleTouchEnabled = true
        }
        
    }
    func play(sender:UIButton){
        print(2)
        let docPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last
        let currentI = "\(sender.tag)"
        let mp3Path = docPath! + "/s" + currentI + ".mp3"
       do {  player = try AVAudioPlayer(contentsOfURL: NSURL(string:mp3Path)!)
        player?.play()
     
        }catch{
            
            print("error6")
        }
    }
}

