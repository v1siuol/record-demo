//
//  ViewController.swift
//  testing
//
//  Created by Louis Lv on 22/03/2018.
//  Copyright © 2018 Louis Lv. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    var isRecording = false
    var audioRecorder: AVAudioRecorder?
    var player : AVAudioPlayer?
    
    // MARK: Properties
    @IBOutlet weak var btRecordOn: UIButton!
    @IBOutlet weak var btPlayRecord: UIButton!
    @IBOutlet weak var btInfo: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("Hello, world!")
        
        // Asking user permission for accessing Microphone
        AVAudioSession.sharedInstance().requestRecordPermission() {
            [unowned self] allowed in
            if allowed {
                // Microphone allowed, do what you like!
                print("Will ask only first implementation")
            } else {
                // User denied microphone. Tell them off!
                print("Mic not allowed")
            }
        }
    }
    
    func startRecording() {
        //1. create the session
        let session = AVAudioSession.sharedInstance()
        
        do {
            // 2. configure the session for recording and playback
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try session.setActive(true)
            // 3. set up a high-quality recording session
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            // 4. create the audio recording, and assign ourselves as the delegate
            audioRecorder = try AVAudioRecorder(url: getAudioFileUrl(), settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            
            //5. Changing record icon to stop icon
            isRecording = true
            print("Start recording")
            btPlayRecord.isEnabled = false
            btRecordOn.setTitle("STOP", for: .normal)
        }
        catch let error {
            // failed to record!
            print("failed to record!")
        }
    }
    
    // Stop recording
    func finishRecording() {
        audioRecorder?.stop()
        isRecording = false
        print("Stop recording")
        btPlayRecord.isEnabled = true
        btRecordOn.setTitle("Record", for: .normal)
    }

    func playSound(){
        let url = getAudioFileUrl()
        
        do {
            // AVAudioPlayer setting up with the saved file URL
            let sound = try AVAudioPlayer(contentsOf: url)
            self.player = sound
            
            // Here conforming to AVAudioPlayerDelegate
            sound.delegate = self
            sound.prepareToPlay()
            sound.play()
        } catch {
            print("error loading file")
            // couldn't load file :(
        }
    }

    // Path for saving/retreiving the audio file
    func getAudioFileUrl() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        // will only store one
        let audioUrl = docsDirect.appendingPathComponent("recording.m4a")
        return audioUrl
    }
    
    // not sure what it is, not test yet
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
//            finishRecording()
//            print("hi")
        }else {
            // Recording interrupted by other reasons like call coming, reached time limit.
        }
    }
    
    // not sure what it is, not test yet
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            
        }else {
            // Playing interrupted by other reasons like call coming, the sound has not finished playing.
        }
        
    }
    

    // MARK: Actions
    @IBAction func act_record(_ sender: Any) {
        if isRecording {
            finishRecording()
        }else {
            startRecording()
        }
    }
    
    @IBAction func show_info(_ sender: Any) {
        print("show info...")

        let info_message = "1. Read the text and record.\n2. STOP after finishing it.\n3.Play it!\n\n See how how fast and correct you got!"
        let alert = UIAlertController(title: "How To Use", message: info_message, preferredStyle: .alert)
        let al_act_ok = UIAlertAction(title: "HAVE FUN", style: .cancel, handler: nil)

        alert.addAction(al_act_ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func act_play_record(_ sender: Any) {
        playSound()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
