//
//  UIView+extensions.swift
//  CrossfadePlayer-DontecoTest
//
//  Created by Mikhail Kostylev on 05.06.2022.
//

import UIKit

extension UIView {
    @discardableResult func prepareForAutoLayout() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}
