//
//  Location+CoreDataProperties.swift
//  MyLocations
//
//  Created by Permi on 2018/4/17.
//  Copyright © 2018 Razeware. All rights reserved.
//
//

import Foundation
import CoreData
import CoreLocation

extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var date: Date
    @NSManaged public var category: String
    @NSManaged public var locationDescription: String
    @NSManaged public var placemark: CLPlacemark?

}
