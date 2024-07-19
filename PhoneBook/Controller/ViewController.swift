//
//  ViewController.swift
//  PhoneBook
//
//  Created by 강유정 on 7/15/24.
//

import UIKit
import SnapKit
import CoreData

class ViewController: UIViewController {
    
    var dataSource = [PhoneBook]()
    
    var container: NSPersistentContainer!
    
    // 테이블 뷰 생성
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.rowHeight = 80 // 셀 높이 지정
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
        
        configureUI()
        navigationSet()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTableView()
    }
    
    private func navigationSet() {
        self.title = "친구 목록"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(btnTapped))
    }
    
    private func configureUI() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(120)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    @objc func btnTapped() {
        self.navigationController?.pushViewController(DetailVC(), animated: true)
    }
    
    // Core Data에서 데이터를 가져와 테이블 뷰 업데이트
    func updateTableView() {
        guard let managedObjectContext = container?.viewContext else {
            print("데이터를 가져올 수 없습니다.")
            return
        }
        
        let fetchRequest: NSFetchRequest<PhoneBook> = PhoneBook.fetchRequest()
        
        // 이름을 기준으로 오름차순 정렬하는 sortDescriptor 추가
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            dataSource = try managedObjectContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("데이터 가져오기 실패: \(error.localizedDescription)")
        }
    }
    
    // Data Delete.
    func deleteData(name: String) {
        // name으로 데이터를 찾아가서 그 데이터를 삭제하는 방식
        
        // 데이터 Delete하려면 먼저 찾아야 된다.
        let fetchRequest = PhoneBook.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let result = try self.container.viewContext.fetch(fetchRequest)
            // name에 해당하는 데이터들을 result 안에 담을 수 있게 된다.
            
            // for문으로 순회
            for data in result as [NSManagedObject] {
                self.container.viewContext.delete(data)
                // 여기서 삭제
            }
            
            // 데이터 변조가 일어났으니까 Context에서 save()
            try self.container.viewContext.save()
            
            print("데이터 삭제 완료")
        } catch {
            print("데이터 삭제 실패")
        }
    }
}

// UITableViewDataSource, UITableViewDelegate 구현
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    // 테이블 뷰에 표시할 총 행 수 설정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    // 각 테이블 뷰 셀을 생성하고, 셀에 데이터를 채워 넣는 역할
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
        let phoneBook = dataSource[indexPath.row]
        cell.configureCell(user: phoneBook)
        return cell
    }
    
    // 셀을 선택했을 때의 동작 설정
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedData = dataSource[indexPath.row] // 선택된 셀의 데이터 가져오기
        
        let detailVC = DetailVC()
        detailVC.selectedData = selectedData // 데이터 전달
        
        navigationController?.pushViewController(detailVC, animated: true)  // 다음 화면으로 넘어가기
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let phoneBookToDelete = dataSource[indexPath.row]
            
            // 코어 데이터에서 데이터 삭제
            // 옵셔널 바인딩을 사용하여 안전하게 추출
            if let name = phoneBookToDelete.name {
                // 코어 데이터에서 데이터 삭제
                deleteData(name: name)
            } else {
                print("데이터 삭제")
                return
            }
            
            // 데이터 소스에서 해당 항목 제거
            dataSource.remove(at: indexPath.row)
            
            // 테이블 뷰에서 셀 삭제
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}
