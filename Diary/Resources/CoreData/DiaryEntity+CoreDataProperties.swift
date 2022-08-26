//
//  DiaryEntity+CoreDataProperties.swift
//  Diary
//
//  Created by minsson on 2022/08/26.
//
//

import Foundation
import CoreData


extension DiaryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryEntity> {
        return NSFetchRequest<DiaryEntity>(entityName: "DiaryEntity")
    }

    @NSManaged public var body: String?
    @NSManaged public var createdDate: Date?
    @NSManaged public var title: String?
    @NSManaged public var uuid: UUID?

}

extension DiaryEntity : Identifiable {

}
