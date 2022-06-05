//
//  PlayerViewController.swift
//  CrossfadePlayer-DontecoTest
//
//  Created by Mikhail Kostylev on 05.06.2022.
//

import UIKit

class PlayerViewController: UIViewController {
    
    private let playerView = PlayerView()
    private var playerManager = AudioPlayerManager()
    private var playButton: PlayerButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.addSubview(playerView.prepareForAutoLayout())
        playerView.delegate = self
        playerManager.delegate = self
        
        let constraints = [
            playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerView.topAnchor.constraint(equalTo: view.topAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func addTrackUrl(_ url: URL) {
        if playButton == playerView.firstAudioButton {
            playerManager.addFirstTrack(from: url)
            let firstTrackName = url.lastPathComponent
            playerView.updatePlayButton(playerView.firstAudioButton, with: firstTrackName)
        } else if playButton == playerView.secondAudioButton {
            playerManager.addSecondTrack(from: url)
            let secondTrackName = url.lastPathComponent
            playerView.updatePlayButton(playerView.secondAudioButton, with: secondTrackName)
        }
    }
    
    private func showAlert(with error: PlayerError) {
        let alert = UIAlertController(title: nil, message: error.rawValue, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension PlayerViewController: PlayerViewDelegate {
    
    func trackButtonPressed(sender: PlayerButton) {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true) {
            self.playButton = sender
        }
    }
    
    func playButtonPressed() {
        if !playerManager.isPlaying {
            playerManager.startPlaying(fadeDuration: playerView.fadeSliderValue)
        } else {
            playerManager.stop()
        }
    }
}

extension PlayerViewController: AudioPlayerManagerDelegate {
    
    func playerStateChanged(_ value: Bool) {
        playerView.toggleButtonsState(value)
    }
    
    func errorThrown(_ error: PlayerError) {
        showAlert(with: error)
    }
}

extension PlayerViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else { return }
        
        addTrackUrl(selectedFileURL)
    }
}

