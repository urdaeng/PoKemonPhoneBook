//
//  DetailVC.swift
//  PhoneBook
//
//  Created by 강유정 on 7/18/24.
//

import UIKit
import SnapKit
import CoreData

class DetailVC: UIViewController {
    
    var container: NSPersistentContainer!
    
    private let datailView = DetailView()
    
    var selectedData: PhoneBook? // 선택된 데이터를 받을 변수
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // 코어 데이터를 사용하기 위한.
        // AppDelegate에 접근하기 위해서 변수 생성
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
        // persistentContainer : Core Data 스택을 관리하는 객체
        
        view.addSubview(datailView)
        datailView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        navigationSet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        detailUpdateSet()
    }
    
    // 네비게이션 설정
    private func navigationSet() {
        self.title = "연락처 추가"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "적용", style: .plain, target: self, action: #selector(addbtnTapped))
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
    
    private func detailUpdateSet() {
        
        // 셀 데이터 가져오기
        if let data = selectedData {    // selectedData가 nil이 아닌 경우에만 실행
            title = data.name   // 네비게이션 타이틀 변경
            datailView.nameTextField.text = data.name
            datailView.numTextField.text = data.phoneNumber
            if let imageData = data.image {
                datailView.profileImg.image = UIImage(data: imageData)
            }
            
            // 네비게이션 버튼 변경
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(editbtnTapped))
        }
    }
    
    // 데이터 생성
    func createData(name: String, number: String, profileImage: UIImage) {
        guard let entity = NSEntityDescription.entity(forEntityName: "PhoneBook", in: self.container.viewContext) else {
            print("Failed to retrieve entity description")
            return
        }
        
        let newPhoneBook = NSManagedObject(entity: entity, insertInto: self.container.viewContext)
        newPhoneBook.setValue(name, forKey: "name")
        newPhoneBook.setValue(number, forKey: "phoneNumber")
        
        // 이미지를 Core Data에 저장
        if let imageData = profileImage.pngData() {
            newPhoneBook.setValue(imageData, forKey: "image")
        }
        
        do {
            try self.container.viewContext.save()
            print("문맥 저장 성공")
        } catch {
            print("문맥 저장 실패")
        }
    }
    
    // 데이터 업데이트
    // 새로 들어오는 데이터로 업데이트
    func updateData(object: PhoneBook, newName: String, newNumber: String, newImage: UIImage) {
        // 객체의 속성들을 업데이트하여 새로운 값으로 설정
        object.name = newName
        object.phoneNumber = newNumber
        
        if let imageData = newImage.pngData() {
            object.image = imageData
        }
        // pngData(): PNG 포맷의 데이터로 변환하는 역할, 이미지 데이터를 Data 형식으로 반환하는 메서드
        
        do {
            try self.container.viewContext.save()
            print("데이터 수정 성공")
        } catch {
            print("데이터 수정 실패")
        }
    }
    
    @objc func addbtnTapped() {
        // 다시 첫 화면으로 돌아가기
        navigationController?.popViewController(animated: true)
        
        guard let name = datailView.nameTextField.text, !name.isEmpty,
              let phoneNumber = datailView.numTextField.text, !phoneNumber.isEmpty,
              let profileImg = datailView.profileImg.image else {
            return
        }
        // 모든 데이터가 들어왔다면, 데이터 저장
        createData(name: name, number: phoneNumber, profileImage: profileImg)
    }
    
    @objc func editbtnTapped() {
        navigationController?.popViewController(animated: true)
        
        guard let name = datailView.nameTextField.text, !name.isEmpty,
              let phoneNumber = datailView.numTextField.text, !phoneNumber.isEmpty,
              let profileImg = datailView.profileImg.image,
              let selectedData = selectedData else {
            return
        }
        // 모든 데이터가 있다면, 데이터 저장
        updateData(object: selectedData, newName: name, newNumber: phoneNumber, newImage: profileImg)
        
    }
}
