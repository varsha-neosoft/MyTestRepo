//
//  ObjectModel.swift
//  TestApp
//
//  Created by varsha on 1/17/18.
//  Copyright © 2018 varsha. All rights reserved.
//

import Foundation
import ObjectMapper

class ObjectModel: Mappable {
   
    var rows : [RowsObj]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
      
        rows <- map["rows"]
    }
}
struct RowsObj : Mappable {
    var title : String?
    var description : String?
    var imageHref : String?

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        title <- map["title"]
        description <- map["description"]
        imageHref <- map["imageHref"]
    }
}
