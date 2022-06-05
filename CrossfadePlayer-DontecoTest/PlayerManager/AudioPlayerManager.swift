//
//  AudioPlayerManager.swift
//  CrossfadePlayer-DontecoTest
//
//  Created by Mikhail Kostylev on 05.06.2022.
//

import Foundation
import AVFoundation

protocol AudioPlayerManagerDelegate: AnyObject {
    func playerStateChanged(_ value: Bool)
    func errorThrown(_ error: PlayerError)
}

class AudioPlayerManager {
    
    weak var delegate: AudioPlayerManagerDelegate?
    
    private var firstPlayer = AudioPlayer()
    private var secondPlayer = AudioPlayer()
    private var nextTrackTimer: Timer?
    private var globalTimer: Timer?
    private var fadeDuration: Double = .zero
    
    var isPlaying: Bool = false {
        didSet {
            delegate?.playerStateChanged(isPlaying)
        }
    }
    
    func addFirstTrack(from url: URL) {
        firstPlayer.track = url
    }
    
    func addSecondTrack(from url: URL) {
        secondPlayer.track = url
    }
    
    func startPlaying(fadeDuration: Double) {
        
        guard
            let firstUrl = firstPlayer.track,
            let secondUrl = secondPlayer.track
        else {
            delegate?.errorThrown(.selectBothTracks)
            return
        }
        
        self.fadeDuration = fadeDuration
        
        firstPlayer.prepare(with: firstUrl)
        secondPlayer.prepare(with: secondUrl)
        
        if checkDuration() {
            play()
            isPlaying = true
        } else {
            delegate?.errorThrown(.shortTrackDuration)
        }
    }
    
    private func play() {
        
        firstPlayer.playWithFade(for: fadeDuration)
        
        let fadeOutTime = firstPlayer.duration - fadeDuration
        nextTrackTimer = Timer.scheduledTimer(withTimeInterval: fadeOutTime, repeats: false) { [unowned self] _ in
            self.secondPlayer.playWithFade(for: self.fadeDuration)
        }
        
        let globalDuration = firstPlayer.duration + secondPlayer.duration - 2 * fadeDuration
        globalTimer = Timer.scheduledTimer(withTimeInterval: globalDuration, repeats: false, block: { [unowned self] _ in
            if self.isPlaying {
                self.play()
            }
        })
    }
    
    func stop() {
        firstPlayer.stop()
        secondPlayer.stop()
        nextTrackTimer?.invalidate()
        globalTimer?.invalidate()
        isPlaying = false
    }
    
    private func checkDuration() -> Bool {
        (firstPlayer.duration >= 2 * fadeDuration && secondPlayer.duration >= 2 * fadeDuration)
    }
}
