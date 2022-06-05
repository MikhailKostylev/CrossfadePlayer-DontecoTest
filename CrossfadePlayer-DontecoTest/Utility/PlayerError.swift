//
//  Errors.swift
//  CrossfadePlayer-DontecoTest
//
//  Created by Mikhail Kostylev on 05.06.2022.
//

import Foundation

enum PlayerError: String {
    case selectBothTracks = "Select at least two tracks before hitting Play."
    case shortTrackDuration = "One of the tracks is shorter than the fade out effect. Reduce the fade effect or select another track."
    case stopBeforeChange = "Stop playback before changing tracks."
}
