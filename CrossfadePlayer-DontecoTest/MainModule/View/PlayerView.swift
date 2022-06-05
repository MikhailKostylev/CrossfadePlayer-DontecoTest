//
//  PlayerView.swift
//  CrossfadePlayer-DontecoTest
//
//  Created by Mikhail Kostylev on 05.06.2022.
//

import UIKit

protocol PlayerViewDelegate: AnyObject {
    func trackButtonPressed(sender: PlayerButton)
    func playButtonPressed()
    func errorThrown(_ error: PlayerError)
}

class PlayerView: UIView {
    
    weak var delegate: PlayerViewDelegate?

    var fadeSliderValue: Double {
        Double(fadeSlider.value)
    }
    
    private let verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.prepareForAutoLayout()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = Constants.padding
        return stack
    }()
    
    let firstAudioButton: PlayerButton = {
        let button = PlayerButton()
        button.setTitle("Add first track", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        return button
    }()
    
    let secondAudioButton: PlayerButton = {
        let button = PlayerButton()
        button.setTitle("Add second track", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        return button
    }()
    
    private let fadeSlider: UISlider = {
        let slider = UISlider()
        slider.prepareForAutoLayout()
        slider.minimumTrackTintColor = .myata
        slider.minimumValue = 2.0
        slider.maximumValue = 10.0
        slider.value = 4.0
        return slider
    }()
    
    private let fadeValueLabel: UILabel = {
        let label = UILabel()
        label.prepareForAutoLayout()
        label.textColor = .darkGray
        return label
    }()
    
    private let playButton: PlayerButton = {
        let button = PlayerButton()
        button.currentState = .stopped
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        return button
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.prepareForAutoLayout()
        view.image = UIImage(named: "image")
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = Constants.padding
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPlayerView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPlayerView()
    }

    private func setupPlayerView() {
        backgroundColor = .lightMyata
        addSubview(verticalStack)
        fadeValueLabel.text = String(format: "Crossfade: %.f seconds", fadeSlider.value)
        setupStackView()
        setupConstraints()
        setupActions()
    }
    
    private func setupStackView() {
        verticalStack.addArrangedSubview(imageView)
        verticalStack.addArrangedSubview(firstAudioButton)
        verticalStack.addArrangedSubview(secondAudioButton)
        verticalStack.addArrangedSubview(fadeValueLabel)
        verticalStack.addArrangedSubview(fadeSlider)
        verticalStack.addArrangedSubview(playButton)
        verticalStack.setCustomSpacing(Constants.padding, after: fadeValueLabel)
    }
    
    private func setupConstraints() {
        let constraints = [
            verticalStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.padding),
            verticalStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.padding),
            verticalStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.padding),
            verticalStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Constants.padding),
            
            imageView.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor),
            imageView.widthAnchor.constraint(equalTo: verticalStack.widthAnchor),
            imageView.topAnchor.constraint(equalTo: verticalStack.topAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            firstAudioButton.leadingAnchor.constraint(equalTo: verticalStack.leadingAnchor),
            firstAudioButton.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor),
            firstAudioButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.1),

            secondAudioButton.leadingAnchor.constraint(equalTo: firstAudioButton.leadingAnchor),
            secondAudioButton.trailingAnchor.constraint(equalTo: firstAudioButton.trailingAnchor),
            secondAudioButton.heightAnchor.constraint(equalTo: firstAudioButton.heightAnchor),

            fadeSlider.leadingAnchor.constraint(equalTo: secondAudioButton.leadingAnchor),
            fadeSlider.trailingAnchor.constraint(equalTo: secondAudioButton.trailingAnchor),

            playButton.heightAnchor.constraint(equalTo: firstAudioButton.heightAnchor),
            playButton.widthAnchor.constraint(equalTo: playButton.heightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupActions() {
        firstAudioButton.addAction(UIAction(handler: { [unowned self] _ in
            if playButton.currentState == .playing {
                self.delegate?.errorThrown(.stopBeforeChange)
            } else {
                self.delegate?.trackButtonPressed(sender: self.firstAudioButton)
            }
        }), for: .touchUpInside)
        
        secondAudioButton.addAction(UIAction(handler: { [unowned self] _ in
            if playButton.currentState == .playing {
                self.delegate?.errorThrown(.stopBeforeChange)
            } else {
                self.delegate?.trackButtonPressed(sender: self.secondAudioButton)
            }
        }), for: .touchUpInside)
        
        fadeSlider.addAction(UIAction(handler: { [unowned self] _ in
            self.fadeSlider.setValue(roundf(self.fadeSlider.value), animated: true)
        }), for: .touchUpInside)
        
        fadeSlider.addAction(UIAction(handler: { [unowned self] _ in
            self.fadeValueLabel.text = String(format: "Crossfade: %.f seconds", self.fadeSlider.value)
        }), for: .valueChanged)
        
        playButton.addAction(UIAction(handler: { [unowned self] _ in
            self.delegate?.playButtonPressed()
        }), for: .touchUpInside)
    }
    
    func toggleButtonsState(_ value: Bool) {
        if value {
            playButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
            playButton.currentState = .playing
        } else {
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            playButton.currentState = .stopped
        }
        fadeSlider.isEnabled = !value
    }
    
    func updatePlayButton(_ button: PlayerButton, with name: String) {
        button.currentState = .filled
        button.setTitle(name, for: .normal)
    }
}
