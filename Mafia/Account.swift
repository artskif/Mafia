//
//  Account.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 21.03.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit
import os.log

// класс описывающий аккаунт пользователя приложения Мафия
class Account: NSObject, NSCoding{
    var name:String
    var rating:Int
    
    init?(name:String, rating:Int = 0) {
        if name.isEmpty {
            return nil
        }
        
        self.rating = rating
        self.name = name
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(rating, forKey: "rating")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: "name") as? String else {
            os_log("Unable to decode the name for a Account object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let rating = aDecoder.decodeInteger(forKey: "rating")
        
        self.init(name: name, rating: rating)
    }
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("accounts")
}
