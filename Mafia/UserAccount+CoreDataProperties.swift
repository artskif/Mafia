//
//  UserAccount+CoreDataProperties.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 15.06.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import Foundation
import CoreData


extension UserAccount {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserAccount> {
        return NSFetchRequest<UserAccount>(entityName: "UserAccount")
    }

    @NSManaged public var name: String?
    @NSManaged public var rating: Int32
    @NSManaged public var id: Int32

}
