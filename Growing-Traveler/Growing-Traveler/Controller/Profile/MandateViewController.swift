//
//  MandateViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/22.
//

import UIKit

enum MandateType {
    
    case login
    
    case friends
    
    case completion
    
    var title: String {
        
        switch self {
            
        case .login: return "login"
            
        case .friends: return "friends"
            
        case .completion: return "completion"
            
        }
        
    }
    
}

class MandateViewController: UIViewController {
    
    var mandateTableView = UITableView()
    
    var mandateManager = MandateManager()
    
    var mandates: [Mandate] = [] {
        
        didSet {
            
            fetchOwnerData()
            
        }
        
    }
    
    var ownMandates: [Mandate] = [] {
        
        didSet {
            
            mandateTableView.reloadData()
            
        }
        
    }
    
    var userManager = UserManager()
    
    var user: User?
    
    var friendManager = FriendManager()
    
    var friend: Friend?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()

        title = "成長任務"
        
        view.backgroundColor = UIColor.white
        
        fetchData()
        
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            
            return navigationController?.topViewController == self
            
        } set {
            
            super.hidesBottomBarWhenPushed = newValue
            
        }
        
    }
    
    func fetchUserData() {
        
        userManager.fetchData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let user):
                
                strongSelf.user = user
                
                strongSelf.handleMandateData()
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
    }
    
    func fetchFriendData() {
        
        friendManager.fetchFriendListData(
        fetchUserID: userID) { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let friend):
                
                strongSelf.friend = friend
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
    }
    
    func handleMandateData() {
        
        guard let user = user else { return }
        
        guard let friend = friend else { return }
        
        for mandatesIndex in 0..<ownMandates.count {
            
            if ownMandates[mandatesIndex].mandateTitle == MandateType.login.title {
                
                for index in 0..<ownMandates[mandatesIndex].mandate.count {
                    
                    ownMandates[mandatesIndex].mandate[index].pogress = user.achievement.loginDates.count
                    
                }
                
            } else if ownMandates[mandatesIndex].mandateTitle == MandateType.friends.title {
                
                for index in 0..<ownMandates[mandatesIndex].mandate.count {
                    
                    ownMandates[mandatesIndex].mandate[index].pogress = friend.friendList.count
                    
                }
                
            } else if ownMandates[mandatesIndex].mandateTitle == MandateType.completion.title {
                
                for index in 0..<ownMandates[mandatesIndex].mandate.count {
                    
                    ownMandates[mandatesIndex].mandate[index].pogress = user.achievement.completionGoals.count
                    
                }
                
            }
            
        }
        
        mandateManager.addData(mandates: ownMandates)
        
    }
    
    func fetchOwnerData() {
        
        mandateManager.fetchOwnerData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
            
            case .success(let mandates):
                
                if mandates.count == 0 {
                 
                    strongSelf.mandateManager.addData(mandates: strongSelf.mandates)
                    
                    strongSelf.ownMandates = strongSelf.mandates
                    
                } else {
                    
                    strongSelf.ownMandates = mandates

                }
                
                strongSelf.fetchFriendData()
                
                strongSelf.fetchUserData()

            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
    }
    
    func fetchData() {
        
        mandateManager.fetchMandateData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
            
            case .success(let mandates):
                
                strongSelf.mandates = mandates

            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
    }
    
    func setTableView() {
        
        mandateTableView.backgroundColor = UIColor.clear
        
        mandateTableView.separatorStyle = .none
        
        view.addSubview(mandateTableView)
        
        mandateTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mandateTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            mandateTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mandateTableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            mandateTableView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -160.0)
        ])
        
        mandateTableView.register(
            UINib(nibName: String(describing: MandateTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: MandateTableViewCell.self)
        )

        mandateTableView.delegate = self
        
        mandateTableView.dataSource = self
        
    }
    
}

extension MandateViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return ownMandates.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ownMandates[section].mandate.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: MandateTableViewCell.self),
            for: indexPath)
        
        guard let cell = cell as? MandateTableViewCell else { return cell }
        
        let mandateItem = ownMandates[indexPath.section].mandate[indexPath.row]
        
        cell.showMandateItem(mandateItem: mandateItem)
        
        return cell
        
    }
    
}
