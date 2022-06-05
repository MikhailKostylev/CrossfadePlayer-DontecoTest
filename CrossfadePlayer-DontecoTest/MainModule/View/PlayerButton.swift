//
//  PlayerButton.swift
//  CrossfadePlayer-DontecoTest
//
//  Created by Mikhail Kostylev on 05.06.2022.
//

import UIKit

enum ButtonState {
    case playing
    case stopped
    case empty
    case filled
}

class PlayerButton: UIButton {

    var currentState: ButtonState = .empty {
        didSet {
            switch currentState {
            case .playing, .empty:
                isSelected = false
            case .stopped, .filled:
                isSelected = true
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func setupView() {
        prepareForAutoLayout()
        configuration = .filled()
        configuration?.cornerStyle = .large
        configuration?.baseBackgroundColor = .lightText
        configuration?.baseForegroundColor = .darkGray
    }
}
