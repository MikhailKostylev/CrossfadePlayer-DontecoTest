//
//  AudioPlayer.swift
//  CrossfadePlayer-DontecoTest
//
//  Created by Mikhail Kostylev on 05.06.2022.
//

import Foundation
import AVFAudio

class AudioPlayer {
    
    private var player = AVAudioPlayer()
    private var fadeOutTimer: Timer?
    var track: URL?
    var duration: Double {
        player.duration
    }
    
    func prepare(with url: URL) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("Player preparation failed: \(error)")
        }
    }
    
    func playWithFade(for fadeDuration: Double) {
        player.volume = .zero
        player.play()
        player.setVolume(1.0, fadeDuration: fadeDuration)
        fadeOutTimer = Timer.scheduledTimer(withTimeInterval: player.duration - fadeDuration, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.player.setVolume(.zero, fadeDuration: fadeDuration)
        }
    }
    
    func stop() {
        player.stop()
        fadeOutTimer?.invalidate()
    }
}
