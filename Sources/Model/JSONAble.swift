//
//  JSONAble.swift
//  Ello
//
//  Created by Sean Dougherty on 11/21/14.
//  Copyright (c) 2014 Ello. All rights reserved.
//

import UIKit

class JSONAble: NSObject {
    class func fromJSON(data:[String: AnyObject]) -> JSONAble {
        return JSONAble()
    }
    
    class func linkItems(data: [String: AnyObject]) -> [String: AnyObject] {
        var linkedData = data
        let links = data["links"] as? [String:AnyObject]
       
        if links == nil {
            return data
        }

        // loop over objects in links
        for (key, value) in links! {
            // grab the type in links
            if let link:String = value["type"] as? String {
                linkedData[key] = Store.store[link]?[value["id"] as String]?
            }
            else if let links = value as? [String] {
                var linkIds = [String:AnyObject]()
                for link:String in links {
                    if let linked: AnyObject = Store.store[key]?[link] {
                        linkIds[link] = linked
                    }
                }
                linkedData[key] = linkIds
            }
        }
        return linkedData
    }
}
