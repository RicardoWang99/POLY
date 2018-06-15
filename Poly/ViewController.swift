import UIKit
import CoreImage
import GPUImage
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var renderView: RenderView!
    @IBOutlet weak var faceDetectSwitch: UISwitch!
    @IBOutlet weak var miao: UIImageView!
    
    let processor = ImageProcess()
    
    let fbSize = Size(width: 640, height: 480)
    let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyLow])
    var shouldDetectFaces = true
    lazy var lineGenerator: LineGenerator = {
        let gen = LineGenerator(size: self.fbSize)
        gen.lineWidth = 5
        return gen
    }()
    
    let blendFilter = AlphaBlend()
    
    func myProcess(source: CGImage, destionation: CGImage) -> CGImage {
        return source
    }
    
    let myFilter = MotionDetector()
    let edgeDetection = SobelEdgeDetection()
    let saturationFilter = SaturationAdjustment()
    let lowpass = LowPassFilter()
    
    
    
    var new = UIImage()
    var origin = CIImage()
    var camera:Camera!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        do {
           
            
            camera = try Camera(sessionPreset:AVCaptureSession.Preset.vga640x480.rawValue)
            camera.runBenchmark = true
            camera.delegate = self
            
            camera --> lowpass --> edgeDetection --> renderView
            
            shouldDetectFaces = faceDetectSwitch.isOn
            camera.startCapture()
            
        } catch {
            fatalError("Could not initialize rendering pipeline: \(error)")
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func didSwitch(_ sender: UISwitch) {
        shouldDetectFaces = sender.isOn
    }
    
    @IBAction func capture(_ sender: AnyObject) {
        print("Capture")
        do {
            let documentsDir = try FileManager.default.url(for:.documentDirectory, in:.userDomainMask, appropriateFor:nil, create:true)
            saturationFilter.saveNextFrameToURL(URL(string:"TestImage.png", relativeTo:documentsDir)!, format:.png)
        } catch {
            print("Couldn't save image: \(error)")
        }
        /*
        DispatchQueue.main.async{
            
            
            self.processor.firstTime = false
            let result = self.processor.processPic(img: self.origin,img2: self.new)
            self.miao.image = result
            
        }
        */
    }
}

extension ViewController: CameraDelegate {
    
    
    
    func didCaptureBuffer(_ sampleBuffer: CMSampleBuffer) {
        guard shouldDetectFaces else {
            
            DispatchQueue.main.async{
                self.miao.image = nil
                
            }// clear
            return
        }
        if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            
            
            let attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, CMAttachmentMode(kCMAttachmentMode_ShouldPropagate))!
            let originImg = CIImage(cvPixelBuffer: pixelBuffer, options: attachments as? [String: AnyObject])
            
            self.origin = originImg
            
            
             guard let outputPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
             let filteredPath = outputPath + "/filteredImage.png"
             let filteredlURL = URL(fileURLWithPath: filteredPath)
             self.edgeDetection.saveNextFrameToURL(filteredlURL, format: .png)
             self.new = UIImage(contentsOfFile: filteredPath)!
 
            
            DispatchQueue.main.async{
                
                guard let outputPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
                let filteredPath = outputPath + "/filteredImage.png"
                let filteredlURL = URL(fileURLWithPath: filteredPath)
                self.edgeDetection.saveNextFrameToURL(filteredlURL, format: .png)
                self.new = UIImage(contentsOfFile: filteredPath)!
                
                let result = self.processor.processPic(img: originImg,img2: self.new)
                self.miao.image = result
                
            }
 
        }
    }
    
}
