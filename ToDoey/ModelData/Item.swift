//
//  Model.swift
//  ToDoey
//
//  Created by Kullanici on 25.01.2023.
//

import Foundation
class Item : Encodable {
    var toDo : String = ""
    var done : Bool = false
}
