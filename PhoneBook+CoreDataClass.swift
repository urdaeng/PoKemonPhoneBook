//
//  PhoneBook+CoreDataClass.swift
//  PhoneBook
//
//  Created by 강유정 on 7/17/24.
//
//

import Foundation
import CoreData

@objc(PhoneBook)
public class PhoneBook: NSManagedObject {
    // NSManagedObject -> Core Data 프레임워크에서 관리되는 객체를 나타내는 기본 클래스
    // 이 클래스는 Core Data 엔티티와의 상호작용을 관리하며, 속성 값의 저장 및 검색을 처리

    public static let className = "PhoneBook"
    public enum Key {
        static let name = "name"
        static let phoneNumber = "phoneNumber"
        static let profileImg = "image"
    }
}
