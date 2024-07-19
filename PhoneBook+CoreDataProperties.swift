//
//  PhoneBook+CoreDataProperties.swift
//  PhoneBook
//
//  Created by 강유정 on 7/17/24.
//
//

import Foundation
import CoreData

extension PhoneBook {

    // PhoneBook에 대해서 여러가지 데이터 검색을 돕는 클래스
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhoneBook> {
        return NSFetchRequest<PhoneBook>(entityName: "PhoneBook")
    }

    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var image: Data? // 프로필 이미지 URL
    // @NSManaged -> Core Data에 의해서 관리되는 객체임을 의미

}

extension PhoneBook : Identifiable {
    // Identifiable -> 고유하게 식별되어, 하나의 Entity를 고유한 값으로 특정 지을 수 있다는 것을 의미
}
