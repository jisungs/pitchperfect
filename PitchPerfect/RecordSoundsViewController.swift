//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by 김해겸 on 2017. 6. 23..
//  Copyright © 2017년 jisung. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @objc var audioRecorder : AVAudioRecorder!

    @IBOutlet weak var RecordingLable: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stoprecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stoprecordingButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear called")
    }
    
    func switchLabelAndButtons(isRecording: Bool){
        RecordingLable.text = isRecording ? "Recording in progress" : "Tap to record"
        recordButton.isEnabled = !isRecording
        stoprecordingButton.isEnabled = isRecording
    }

    @IBAction func RecordAudio(_ sender: AnyObject) {
        switchLabelAndButtons(isRecording: true)
        
       /* RecordingLable.text = "Recording pressed"
        stoprecordingButton.isEnabled = true
        recordButton.isEnabled = false*/
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
            
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func StopRecording(_ sender: AnyObject) {
        switchLabelAndButtons(isRecording: false)
        
        /*recordButton.isEnabled = true
        stoprecordingButton.isEnabled = false
        RecordingLable.text = "Tap to Record"*/
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else{
        print("recording was not sucessful")
        }
       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
    }
  }
}
