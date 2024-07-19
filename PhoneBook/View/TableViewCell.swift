//
//  TableViewCell.swift
//  PhoneBook
//
//  Created by 강유정 on 7/15/24.
//

import UIKit
import SnapKit

// TableViewCell 정의
final class TableViewCell: UITableViewCell {
    // TableViewCell은 각자의 고유한 아이디를 가지고 있어야만 한다.
    static let id = "TableViewCell"
    
    // 셀 안에다가 이미지뷰 선언
    private let profileImg: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 30
        image.layer.borderWidth = 2.0 // 테두리 두께
        image.layer.borderColor = UIColor.lightGray.cgColor // 테두리 색상
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true // 이미지 뷰 밖으로 나간 이미지를 자르기
        return image
    }()
    
    // 이름 Label 선언
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .darkGray
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    
    // 전화번호 Label 선언
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .darkGray
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    
    // 이니셜라이저 지정
    // TableView의 style과 id를 초기화를 할 때 사용하는 코드.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        contentView.backgroundColor = .white  // 예시로 contentView의 배경색을 흰색으로 설정
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [
            profileImg,
            nameLabel,
            numberLabel
        ].forEach { contentView.addSubview($0) }
        // TableViewCell은 contentView라는 것을 기본적으로 가지고 있다. 이게 베이스가 되는 뷰다.
        
        // 오토 레이아웃 세팅
        profileImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(60)
            $0.leading.equalToSuperview().inset(30)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(profileImg.snp.trailing).offset(20)
        }
        
        numberLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(40)
        }
    }
    
    // 외부에서 사용, 셀을 세팅해 주겠다는 메서드
    func configureCell(user: PhoneBook) {
        nameLabel.text = user.name
        numberLabel.text = user.phoneNumber
        
        if let imageData = user.image {
            profileImg.image = UIImage(data: imageData)
        } else {
            profileImg.image = nil
        }
    }
    
}
