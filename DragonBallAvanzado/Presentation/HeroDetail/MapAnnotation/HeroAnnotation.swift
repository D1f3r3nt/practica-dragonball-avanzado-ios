//
//  HeroAnnotation.swift
//  DragonBallAvanzado
//
//  Created by Marc Santisteban Ruiz on 19/10/23.
//

import UIKit
import MapKit

// MARK: - Class -
class HeroAnnotation: NSObject, MKAnnotation {
    var title: String?
    var info: String?
    var coordinate: CLLocationCoordinate2D
    
    init(
        title: String?,
        info: String?,
        coordinate: CLLocationCoordinate2D
    ) {
        self.title = title
        self.info = info
        self.coordinate = coordinate
    }
}
