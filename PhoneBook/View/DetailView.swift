//
//  DetailView.swift
//  PhoneBook
//
//  Created by 강유정 on 7/18/24.
//

import UIKit
import SnapKit

class DetailView: UIView {
    
    private var dataSource = [Pokemon]()
    
    // 이미지뷰 생성
    let profileImg: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .white
        image.layer.cornerRadius = 80
        image.layer.borderWidth = 2.5 // 테두리 두께
        image.layer.borderColor = UIColor.lightGray.cgColor // 테두리 색상
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = true // 이미지 뷰 밖으로 나간 이미지를 자르기
        return image
    }()
    
    // UILabel 생성
    private let randomButton: UIButton = {
        let button = UIButton()
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        return button
    }()
    
    // UITextField 추가
    let nameTextField: UITextView = {
        let text = UITextView()
        text.font = .systemFont(ofSize: 18)
        text.layer.cornerRadius = 10
        text.layer.borderWidth = 2.0 // 테두리 두께
        text.layer.borderColor = UIColor.systemGray5.cgColor // 테두리 색상
        return text
    }()
    
    let numTextField: UITextView = {
        let text = UITextView()
        text.font = .systemFont(ofSize: 18)
        text.layer.cornerRadius = 10
        text.layer.borderWidth = 2 // 테두리 두께
        text.layer.borderColor = UIColor.systemGray5.cgColor // 테두리 색상
        return text
    }()
    
    // 이니셜라이저 지정
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func buttonTapped() {
        DispatchQueue.global().async {
            self.fetchPokemonData()
        }
    }
    
    // 오토 레이아웃
    func configureUI() {
        // 리스트 열어서 위에 모든 클래스들 넣기
        [
            profileImg,
            randomButton,
            nameTextField,
            numTextField,
        ].forEach { self.addSubview($0) }
        
        profileImg.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(120)
            $0.width.height.equalTo(160)
        }
        
        randomButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileImg.snp.bottom).offset(15)
        }
        
        nameTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(randomButton.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        numTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nameTextField.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
    }
    
    // 서버 데이터를 불러오는 메서드
    private func fetchPokemonData() {
        // URL 선언
        let urlComponents = URLComponents(string: "https://pokeapi.co/api/v2/pokemon/\(Int.random(in: 1...1000))")
        
        guard let url = urlComponents?.url else {
            print("잘못된 URL")
            return
        }
        
        // imageURL 가져오기
        guard let imageUrl = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(Int.random(in: 1...1000)).png") else {
            // 이 안에만 서버에서 가지고온 데이터로 교체
            return
        }
        
        // image를 로드하는 작업은 백그라운드 쓰레드 작업
        if let data = try? Data(contentsOf: imageUrl) {
            // 이 URL에 해당하는 이미지 데이터가 로드
            if let image = UIImage(data: data) {
                // 해당 URL로부터 이미지를 띄울 수 있게 된다.
                DispatchQueue.main.async {
                    self.profileImg.image = image
                    // imageView.image에다가 서버로부터 가져온 이미지를 교체
                }
            }
        }
    }
    
}
