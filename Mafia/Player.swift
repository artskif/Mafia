//
//  Player.swift
//  Mafia
//
//  Created by Vadim Kamyshnikov on 13.03.17.
//  Copyright © 2017 Vadim Kamyshnikov. All rights reserved.
//

import UIKit
import os.log

// класс описывающий одного игрока приложения мафия
class Player: Account {
    var role:String
    
    init?(name:String){
        self.role = ""

        super.init(name: name)
    }
    
    override init?(name:String, rating: Int){
        self.role = ""
        
        super.init(name: name, rating: rating)
    }
    
    public override func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(rating, forKey: "rating")
        aCoder.encode(role, forKey: "role")
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
}
