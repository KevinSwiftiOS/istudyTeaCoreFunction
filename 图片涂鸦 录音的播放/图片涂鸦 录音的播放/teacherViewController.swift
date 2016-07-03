//
//  teacherViewController.swift
//  图片涂鸦 录音的播放
//
//  Created by hznucai on 16/2/22.
//  Copyright © 2016年 hznucai. All rights reserved.
//

import UIKit
import AVFoundation
protocol sendArray{
    func send(arr1:NSMutableArray,arr2:NSMutableArray)
}
class teacherViewController: UIViewController {
    @IBOutlet weak var resultImageView:UIImageView?
    @IBOutlet weak var saveDrawButton:UIButton?
    @IBOutlet weak var drawView:PIDrawView?
    @IBOutlet weak var deEditButton:UIButton?
    @IBOutlet weak var drawButton:UIButton?
    @IBOutlet weak var startRecoderButton:UIButton?
    @IBOutlet weak var stopRecoderButton:UIButton?
    var delegate:sendArray?
    //记录数组的 
    var locationX = NSMutableArray()
    var locationY = NSMutableArray()
    //记录第几段录音
    var i = 0
    //记录位置
    var x:CGFloat?
    var y:CGFloat?
    var recoder:AVAudioRecorder?
    var player:AVAudioPlayer?
    var resultImage = UIImage()
    var correctDrawImage = UIImage()
    override func viewDidLoad() {
     super.viewDidLoad()
        self.drawView?.hidden = true
        self.resultImageView?.image = self.resultImage
        self.saveDrawButton?.hidden = true
        self.deEditButton?.hidden = true
        self.drawButton?.addTarget(self, action: #selector(teacherViewController.draw(_:)), forControlEvents: .TouchUpInside)
        self.startRecoderButton?.hidden = true
        self.stopRecoderButton?.hidden = true
        do { try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
        }catch{
            print("error")
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func draw(sender:UIButton){
        self.drawView?.hidden = false
        self.saveDrawButton?.hidden = false
        self.deEditButton?.hidden = false
        self.drawView?.backgroundColor = UIColor.clearColor()
        self.drawView?.setDrawingMode(DrawingMode.Paint)
        sender.hidden = true
        self.saveDrawButton?.addTarget(self, action: #selector(teacherViewController.saveDraw(_:)), forControlEvents: .TouchUpInside)
        self.deEditButton?.addTarget(self, action: #selector(teacherViewController.deEdit(_:)), forControlEvents: .TouchUpInside)
    }

    func saveDraw(sender:UIButton){
        //保存涂鸦的代码
       let size = self.drawView?.frame.size
    UIGraphicsBeginImageContextWithOptions(size!, false, 1.0)
        self.drawView?.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        self.correctDrawImage = UIGraphicsGetImageFromCurrentImageContext()
        //UIGraphicsEndImageContext()
        //drawView?.endEditing(true)
        self.deEditButton?.hidden = true
        self.saveDrawButton?.hidden = true
        self.drawButton?.hidden = false
}
    func deEdit(sender:UIButton) {
        self.drawView?.setDrawingMode(DrawingMode.Erase)
}
    @IBAction func chooseLacation(sender:UIButton){
        //在drawView上进行位置的选择
        self.drawView?.multipleTouchEnabled = true
        self.drawView?.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(teacherViewController.didChooseLocation(_:)))
        self.drawView?.addGestureRecognizer(tap)
        self.drawView?.setDrawingMode(DrawingMode.None)
    }
    func didChooseLocation(sender:UITapGestureRecognizer) {
        x = sender.locationInView(self.drawView).x
        y = sender.locationInView(self.drawView).y
        self.startRecoderButton?.hidden = false
        self.stopRecoderButton?.hidden = false
        self.startRecoderButton?.addTarget(self, action: #selector(teacherViewController.startRecoder(_:)), forControlEvents: .TouchUpInside)
        self.stopRecoderButton?.addTarget(self, action: #selector(teacherViewController.stopRecoder(_:)), forControlEvents: .TouchUpInside)
    }
    func startRecoder(sender:UIButton){
        let recordSettings:[String:AnyObject] = [
            //设置编码的格式 本处为无损压缩格式
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVEncoderBitRateKey : 320000,
            //设置声道的个数
            AVNumberOfChannelsKey: 2,
            //是设置采样的频率
            AVSampleRateKey : 11025
        ]
        let docPath = createPath()
        let currentI = "\(self.i)"
        let cafPath = docPath + "/s" + currentI + ".caf"
        do { self.recoder =  try AVAudioRecorder(URL: NSURL(string:cafPath)!, settings: recordSettings)
            self.recoder?.record()
        }catch{
            print("error1")
        }
        }
    func stopRecoder(sender:UIButton) {
        self.recoder?.stop()
        let playButton = UIButton(frame: CGRectMake(x!,y!,20,20))
        playButton.setTitle("play", forState: .Normal)
        playButton.tag = self.i
        self.drawView?.addSubview(playButton)
        playButton.backgroundColor = UIColor.blueColor()
        playButton.tintColor = UIColor.whiteColor()
        playButton.addTarget(self, action: #selector(teacherViewController.play(_:)), forControlEvents: .TouchUpInside)
        self.stopRecoderButton?.hidden = true
        self.startRecoderButton?.hidden = true
        self.locationX.insertObject(x!, atIndex: self.i)
        self.locationY.insertObject(y!, atIndex: self.i)
        (self.i) += 1
    }
    func play(sender:UIButton){
        let docPath = createPath()
        let currentI = "\(sender.tag)"
        let cafPath = docPath + "/s" + currentI + ".caf"
        let mp3Path = docPath + "/s" + currentI + ".mp3"
        
        let translateCafToMp3 = translate()
       translateCafToMp3.setWithUrl(cafPath,withMp3Url: mp3Path)
       translateCafToMp3.audio_PCMtoMP3()
        //删除caf文件
//       let fileManger = NSFileManager.defaultManager()
//        do { try fileManger.removeItemAtPath(cafPath)
//        }catch{
//            print("error5")
//        }
        do { self.player = try AVAudioPlayer(contentsOfURL: NSURL(string: cafPath)!)
            self.player?.prepareToPlay()
        self.player?.play()
        }catch{
            print("error2")
        }
    }
    func createPath() -> String {
        let doc = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        print(doc)
         return doc[0]
    }
    @IBAction func savePhoto(sender:UIButton){
        let stuVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("student") as! ViewController
       stuVC.correctImage = self.correctDrawImage
       stuVC.locationX = self.locationX
       stuVC.locationY = self.locationY
       self.presentViewController(stuVC, animated: true, completion: nil)
    }
}