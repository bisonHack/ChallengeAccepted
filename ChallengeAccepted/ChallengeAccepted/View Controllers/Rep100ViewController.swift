//
//  Rep100ViewController.swift
//  ChallengeAccepted
//
//  Created by Subomi Popoola on 4/10/21.
//

import UIKit
import VideoToolbox
import Parse

class Rep100ViewController: UIViewController, ConfigurationViewControllerDelegate, VideoCaptureDelegate, PoseNetDelegate {
    var randomUser: PFUser!
            
    @IBOutlet weak var previewImageView: PoseImageView!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var randPreviewImageView: UIImageView!
    @IBOutlet weak var randCounterLabel: UILabel!

    var squatCounter = 90 // Counter for Squats
    var previous = [Float]()    // Previous data of squats
    var current = [Float]() // Current Squatting data
    var previous_action: String = "r"    // Current State of body

    var working = true
    var heightEstimator = 5.58

    var randSquatCounter = 90
    var category: String!
    
    var userTimer = Timer()
    var randTimer = Timer()

    private let videoCapture = VideoCapture()
    private var poseNet: PoseNet!
    /// The frame the PoseNet model is currently making pose predictions from.
    private var currentFrame: CGImage?
    /// The algorithm the controller uses to extract poses from the current frame.
    private var algorithm: Algorithm = .multiple
    /// The set of parameters passed to the pose builder when detecting poses.
    private var poseBuilderConfiguration = PoseBuilderConfiguration()
    private var popOverPresentationManager: PopOverPresentationManager?

    override func viewDidLoad() {
        super.viewDidLoad()

        let user = PFUser.current()
        user?.setObject(0, forKey: "currentCount")
        user?.saveInBackground()
        
        userTimer = Timer.scheduledTimer(timeInterval: 3,
                    target: self,
                    selector: #selector(updateRandUserSquatCount),
                    userInfo: nil,
                    repeats: true)
                
        randTimer = Timer.scheduledTimer(timeInterval: 3,
                    target: self,
                    selector: #selector(updateUserSquatCount),
                    userInfo: nil,
                    repeats: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

        UIApplication.shared.isIdleTimerDisabled = true

        do {
            poseNet = try PoseNet()
        } catch {
            fatalError("Failed to load model. \(error.localizedDescription)")
        }
        
        poseNet.delegate = self
        setupAndBeginCapturingVideoFrames()
        
      
    }

    @objc func updateUserSquatCount() {
        let user = PFUser.current()
        user?.setObject(self.squatCounter, forKey: "currentCount")
        user?.saveInBackground()
    }

    @objc func updateRandUserSquatCount(){
        self.randomUser.fetchInBackground { (success, error) in
            let count = self.randomUser.object(forKey: "currentCount") as! Int
            self.randSquatCounter = count
            self.randCounterLabel.text = String(format: "%0d", self.randSquatCounter)
        }
    }

    func winnerAlert(){
        let alert = UIAlertController(title: self.category, message: "Nice one!", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)

        let when = DispatchTime.now() + 4
        DispatchQueue.main.asyncAfter(deadline: when){
          // your code with delay
          alert.dismiss(animated: true, completion: nil)
          self.dismiss(animated: true, completion: nil)
        }
    }

    func updateChallenges(){
        let user = PFUser.current()!
        if squatCounter > randSquatCounter{
            self.category = "You won!!"
        } else{
            self.category = "You lost!!"
        }
        user.setObject(0, forKey: "currentCount")
        user.saveInBackground()
        self.winnerAlert()
    }

    private func setupAndBeginCapturingVideoFrames() {
        videoCapture.setUpAVCapture { error in
            if let error = error {
                print("Failed to setup camera with error \(error)")
                return
            }
            self.videoCapture.delegate = self
            self.videoCapture.startCapturing()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
            videoCapture.stopCapturing {
                super.viewWillDisappear(animated)
            }
        }

    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        // Reinitilize the camera to update its output stream with the new orientation.
        setupAndBeginCapturingVideoFrames()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        guard let uiNavigationController = segue.destination as? UINavigationController else {
            return
        }
        guard let configurationViewController = uiNavigationController.viewControllers.first
            as? ConfigurationViewController else {
                    return
        }

        configurationViewController.configuration = poseBuilderConfiguration
        configurationViewController.algorithm = algorithm
        configurationViewController.delegate = self

        popOverPresentationManager = PopOverPresentationManager(presenting: self,
                                                                presented: uiNavigationController)
        segue.destination.modalPresentationStyle = .custom
        segue.destination.transitioningDelegate = popOverPresentationManager
    }

    // MARK: - ConfigurationViewControllerDelegate
    func configurationViewController(_ viewController: ConfigurationViewController, didUpdateConfiguration configuration: PoseBuilderConfiguration) {
        poseBuilderConfiguration = configuration
    }

    func configurationViewController(_ viewController: ConfigurationViewController, didUpdateAlgorithm algorithm: Algorithm) {
        self.algorithm = algorithm
    }

    // MARK: - VideoCaptureDelegate
    func videoCapture(_ videoCapture: VideoCapture, didCaptureFrame capturedImage: CGImage?) {
        guard currentFrame == nil else {
            return
        }
        guard let image = capturedImage else {
            fatalError("Captured image is null")
        }

        currentFrame = image
        poseNet.predict(image)
    }

    // MARK: - PoseNetDelegate
    func poseNet(_ poseNet: PoseNet, didPredict predictions: PoseNetOutput) {
        defer {
            // Release `currentFrame` when exiting this method.
            self.currentFrame = nil
        }

        guard let currentFrame = currentFrame else {
            return
        }
        

        let poseBuilder = PoseBuilder(output: predictions,
                                      configuration: poseBuilderConfiguration,
                                      inputImage: currentFrame)

        let poses = algorithm == .single ? [poseBuilder.pose] : poseBuilder.poses // Returns 2D array with a single element
        
        if !poses.isEmpty && working{
           let pose = poses[0] // Take first array in Poses data
           
           // Get CGPoints of respectivec joints
           let left_hip_y = Float(pose.joints[.leftHip]?.position.y ?? 0) * 12
           let left_knee_y = Float(pose.joints[.leftKnee]?.position.y ?? 0) * 12
           let left_ankle_y = Float(pose.joints[.leftAnkle]?.position.y ?? 0) * 12
           let left_ear_y = Float(pose.joints[.leftEar]?.position.y ?? 0 ) * 12
           let left_eye_y = Float(pose.joints[.leftEye]?.position.y ?? 0) * 12

           let right_hip_y = Float(pose.joints[.rightHip]?.position.y ?? 0) * 12
           let right_knee_y = Float(pose.joints[.rightKnee]?.position.y ?? 0) * 12
           let right_ankle_y = Float(pose.joints[.rightAnkle]?.position.y ?? 0) * 12
           let right_ear_y = Float(pose.joints[.rightEar]?.position.y ?? 0) * 12
           let right_eye_y = Float(pose.joints[.rightEye]?.position.y ?? 0) * 12
           
           let nose_y = Float(pose.joints[.nose]?.position.y ?? 0) * 12
           
           // Array of current squatting data
           self.current = [left_hip_y, left_knee_y, left_ankle_y, left_ear_y, left_eye_y, right_hip_y, right_knee_y, right_ankle_y, right_ear_y, right_eye_y, nose_y]
           // Array of minimum required change in current data and previous data
           let change = [130.0, 10.0, 0.0, 600.0, 650.0, 130.0, 10.0, 0.0, 600.0, 650.0, 550.0]
//                   for y in 0..<change.count{
//                    change[y] *= self.heightEstimator
//                    }
           var check = true
           //Ensure that all points are sin and are non-zero
           for item in self.current{
               if item == Float(0){
                   check = false
               }
           }
           
    
           if check{
               if !self.previous.isEmpty { //If previous points do exist
                   //check if change btw previous data and current data meet minimum required value
                   let hips_check = abs(self.current[0] - self.previous[0]) >= Float(change[0]) && abs(self.current[5] - self.previous[5]) >= Float(change[5])
                   let knees_check = abs(self.current[1] - self.previous[1]) >= Float(change[1]) && abs(self.current[6] - self.previous[6]) >= Float(change[6])
                   //let eyes_check = abs(self.current[4] - self.previous[4]) >= Float(change[4]) && abs(self.current[9] - self.previous[9]) >= Float(change[9])
                   
                   if hips_check && knees_check { // If it does meet minimum required value
                       var fall = 0
                       var rise = 0
                       //Get number of data points that rise and fall
                       for x in 0..<self.current.count{
                           fall = self.current[x] > self.previous[x] ? fall + 1 : fall
                           rise = self.current[x] < self.previous[x] ? rise + 1 : rise
                       }
       
                       let current_action = rise >= fall ? "r" : "f" // Compare rise and fall values to determine if body is really falling or rising
                     
                       if self.previous_action == "r" && current_action == "f" { //When body is rising after a squat, increment counter by 1
                           self.squatCounter += 1
                           self.counterLabel.text = String(self.squatCounter)
                        if (self.squatCounter == 100 || self.randSquatCounter == 100) {
                           self.working = false
                            self.userTimer.invalidate()
                            self.randTimer.invalidate()
                           self.updateChallenges()
                        }
                           
                       }
                       self.previous_action = current_action //Assign current action to previous action
                   }
               }
               self.previous = self.current // Assign current data to previous data
           }
       }

    previewImageView.show(poses: poses, on: currentFrame)
}
    }
