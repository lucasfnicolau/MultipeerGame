//
//  SoundManager.swift
//  MultipeerMadness
//
//  Created by Leonardo Oliveira on 24/10/19.
//  Copyright © 2019 {lfn}. All rights reserved.
//

import AVFoundation

enum AudioLoadResponse: Error {
    case success(audio: AVAudioPlayer)
    case error(description: String)
}

public class AudioManager: NSObject {
    
    static func getAudio(name: String, withCompletion completion: (AudioLoadResponse) -> Void) {
        
        guard let path = Bundle.main.path(forResource: name, ofType: "mp3") else {
            completion(AudioLoadResponse.error(description: "error path"))
            return
        }
        
        let fileURL = URL(fileURLWithPath: path)
        
        do {
            let audio = try AVAudioPlayer(contentsOf: fileURL)
            completion(AudioLoadResponse.success(audio: audio))
            
        } catch {
            completion(AudioLoadResponse.error(description: "error audioplayer"))
        }
    }
    
}
