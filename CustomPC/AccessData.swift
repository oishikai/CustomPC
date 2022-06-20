//
//  AccessData.swift
//  CustomPC
//
//  Created by Kai on 2022/06/19.
//

import UIKit
import CoreData

class AccessData {
    private static let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static func getCustoms() ->[Custom]? {
        var companies:[Custom] = []
        let dataCondition = NSFetchRequest<NSFetchRequestResult>(entityName: "Custom")
        do{
            companies = try managedObjectContext.fetch(dataCondition) as! [Custom]
            return companies
        }catch{
            print("getCustoms エラー")
        }
        
        return nil
    }
    
    private static func storeParts(custom:Custom, parts:PcParts) {
        let storeParts = Parts(context: self.managedObjectContext)
        
        storeParts.category = parts.category.rawValue
        storeParts.maker = parts.maker
        storeParts.title = parts.title
        storeParts.price = parts.price
        storeParts.img = parts.image
        storeParts.detail = parts.detailUrl
        
        custom.addToParts(storeParts)
    }
    
    static func storeCustom(title:String, price:String, message:String, parts:[PcParts]) {
        guard let _ = getCustoms() else { return }
        
        var customs = getCustoms()
        
        let newCustom = Custom(context: self.managedObjectContext)
        newCustom.title = title
        newCustom.price = price
        newCustom.message = message
        
        for p in parts {
            storeParts(custom: newCustom, parts: p)
        }
        
        customs?.append(newCustom)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
}
