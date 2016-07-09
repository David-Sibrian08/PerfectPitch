//
//  RecordSoundsViewController.swift
//  PerfectPitch
//
//  Created by Sibrian on 6/6/16.
//  Copyright © 2016 Sibrian. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var tapToRecordLabel: UILabel!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopRecordingButton.enabled = false     //disable the record button when the app loads
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
     recordButtonPressed should:
     - Disable the recordButton
     - Enable the stopRecordingButton
     - Display an indicator that recording is in progress
    */
    @IBAction func recordButtonPressed(sender: UIButton) {
        recordButton.enabled = false
        stopRecordingButton.enabled = true
        infoButton.hidden = true
        
        tapToRecordLabel.text = "Recording..."
        
        //Recording functionality
        let directoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        
        let recordingName = "myVoice.wav"
        let pathArray = [directoryPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        if let existingFilePath = filePath {
            print(existingFilePath)
        }
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: AVAudioSessionCategoryOptions.DefaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    /*
     stopRecordingButtonPressed should:
     - Enable the recordButton
     - Disable the stopRecordingButton
     - Chage the indicator back to "Tap to Record"
     */
    @IBAction func stopRecordingButtonPressed(sender: UIButton) {
        recordButton.enabled = true
        stopRecordingButton.enabled = false
        infoButton.hidden = false
        
        tapToRecordLabel.text = "Tap to Record"
        
        audioRecorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    @IBAction func infoButtonPressed(sender: UIButton) {
        let alertController = UIAlertController(title: "How To:", message: "Press the microphone to record. When you're done, press stop and select one of the sound effects on the next screen.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "Got it!", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print("AVRecorder has fininshed saving the recording")
        
        if (flag) {
            self.performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
        } else {
            print("Recording could not be saved")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
            
        }
    }

}

