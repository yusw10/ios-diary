//
//  DiaryCoreDataManager.swift
//  Diary
//
//  Created by 민쏜, 보리사랑 on 2022/08/24.
//

import Foundation
import CoreData
import UIKit

class DiaryCoreDataManager {
    
    static let shared = DiaryCoreDataManager()
    
    private init() {
        
    }
    
    var context: NSManagedObjectContext {
        return AppDelegate.sharedAppDelegate.persistentContainer.viewContext
    }
    
    func saveDiary(diaryItem: DiaryItem) {
        let diaryEntity = DiaryEntity(context: context)
        diaryEntity.title = diaryItem.title
        diaryEntity.body = diaryItem.body
        diaryEntity.createdDate = Date(timeIntervalSince1970: diaryItem.createdDate)
        diaryEntity.uuid = diaryItem.uuid
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    // 기존 일기 선택
    // 수정 (CRUD 중 UPDATE)
    // 리스트뷰에 가면 수정된 일기가 있다
    
    func fetchAllDiary() -> [DiaryItem]? {
        do {
            let diaryData = try context.fetch(DiaryEntity.fetchRequest())
            
            var diaryItems: [DiaryItem] = []
            
            diaryData.forEach { diaryEntity in
                guard let title = diaryEntity.title,
                      let body = diaryEntity.body,
                      let createdDate = diaryEntity.createdDate else {
                    return
                }
                
                let diaryItem = DiaryItem(
                    title: title,
                    body: body,
                    createdDate: createdDate.timeIntervalSince1970
                )
                
                diaryItems.append(diaryItem)
            }
            return diaryItems
        } catch {
            
        }
        return nil
    }
    
    
    
    func update(diaryItem: DiaryItem) {
        // 기존의 diaryEntity에 diaryItem을 뒤집어씌운다
        // uuid로 일치하는 걸 찾는다
        
        let diaryEntityUUID = diaryItem.uuid

        let request = NSFetchRequest<DiaryEntity>(entityName: "DiaryEntity")
        request.predicate = NSPredicate(format: "uuid = %@", diaryEntityUUID.uuidString)
        
        
        
        do {
            print("ㅁㅁ")
            let diaryEntity = try context.fetch(request)
            
            print(diaryEntity)
            
            let diaryEntity2 = diaryEntity[0]
            print(diaryEntity2)
            
            diaryEntity2.setValue(diaryItem.title, forKey: "title")
            diaryEntity2.setValue(diaryItem.body, forKey: "body")
            
//            let diaryEntity = DiaryEntity(context: context)
        } catch {
            
        }
        
        

        do {
            try context.save()
            print("saved")
            print(context)
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        
        
    }
    
//    func updateItem(item: ToDoListItem, newName: String) {
//        item.name = newName
//
//        do {
//            try context.save()
//        } catch {
//            print(error)
//        }
//    }
    
    
}

