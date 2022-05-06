//
//  ProfileViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/22.
//

import UIKit

enum FeatureType {
    
    case mandate
    
    case analysis
    
    case release
    
    case license
    
    var title: String {
        
        switch self {
            
        case .mandate: return "學習成就"
            
        case .analysis: return "學習分析"
            
        case .release: return "發布紀錄"
            
        case .license: return "個人認證"
            
        }
        
    }
    
}

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileView: ProfileView!
    
    @IBOutlet weak var featureCollectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, FeatureType>?
    
    let featureList: [FeatureType] = [.mandate, .analysis, .release, .license]
    
    let featureImage: [ImageAsset] = [.specialDeals, .vision, .blogging, .meditation]
    
    var userManager = UserManager()
    
    var userInfo: UserInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureDataSource()
        
        setNavigationBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        tabBarController?.tabBar.isHidden = true
        
        fetchUserInfoData()
        
        if userID == "" {
            
            tabBarController?.selectedIndex = 0
            
            print("TEST 1")
            
        }
        
    }
    
    func setNavigationBar() {
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage.asset(.edit), style: .plain, target: self, action: #selector(setProfileButton))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage.asset(.block), style: .plain, target: self, action: #selector(blockadeFriendButton))
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor.black
        
    }
    
    @objc func blockadeFriendButton(sender: UIButton) {
        
        let viewController = BlockadeFriendViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    @objc func setProfileButton(sender: UIButton) {
        
        let viewController = ProfileSettingViewController()
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func fetchUserInfoData() {
        
        userManager.listenData { [weak self] result in
            
            guard let strongSelf = self else { return }
            
            switch result {
                
            case .success(let userInfo):
                
                strongSelf.userInfo = userInfo
                
                strongSelf.setProfileView()
                
            case .failure(let error):
                
                print(error)
                
            }
            
        }
        
    }
    
    func setProfileView() {
        
        guard let userInfo = userInfo else { return }
        
        profileView.userNameLabel.text = userInfo.userName
        
        profileView.userPhotoImageView.loadImage(userInfo.userPhoto)
        
        profileView.experienceValueLabel.text = "Ex. \(userInfo.achievement.experienceValue)"
        
    }
    
    func configureDataSource() {
        
        featureCollectionView.register(
            UINib(nibName: String(describing: FeatureCollectionViewCell.self), bundle: nil),
            forCellWithReuseIdentifier: String(describing: FeatureCollectionViewCell.self))
        
        dataSource = UICollectionViewDiffableDataSource.init(
        collectionView: featureCollectionView, cellProvider: { collectionView, indexPath, item in
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: FeatureCollectionViewCell.self), for: indexPath)
            
            guard let cell = cell as? FeatureCollectionViewCell else { return cell }
                
            cell.featureItemLabel.text = self.featureList[indexPath.item].title
            
            cell.featureImageView.image = UIImage.asset(self.featureImage[indexPath.item])
            
            return cell
            
        })
        
        featureCollectionView.dataSource = dataSource
        
        featureCollectionView.delegate = self
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, FeatureType>()
        
        snapshot.appendSections([0, 1])
        
        snapshot.appendItems(featureList, toSection: 0)
        
        dataSource?.apply(snapshot, animatingDifferences: true)
        
        featureCollectionView.collectionViewLayout = generateLayout()
        
    }
    
    func generateLayout() -> UICollectionViewLayout {

        let padding: Double = 10

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        item.contentInsets = NSDirectionalEdgeInsets(
            top: padding, leading: padding, bottom: padding, trailing: padding)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.7), heightDimension: .fractionalHeight(0.8))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
        return UICollectionViewCompositionalLayout(section: section)
        
//        let configuration = UICollectionViewCompositionalLayoutConfiguration()
//
//        configuration.scrollDirection = .horizontal
//
//        return UICollectionViewCompositionalLayout(section: section, configuration: configuration)

    }

}

extension ProfileViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.item {

        case 0:
            
            let viewController = MandateViewController()
            
            navigationController?.pushViewController(viewController, animated: true)
            
//        case 1:
//            let viewController = UIStoryboard.profile
//                .instantiateViewController(withIdentifier: String(describing: RankViewController.self))
//
//            guard let viewController = viewController as? RankViewController else { return }
//
//            navigationController?.pushViewController(viewController, animated: true)

        case 1:
            
            let viewController = UIStoryboard.profile
                .instantiateViewController(withIdentifier: String(describing: AnalysisViewController.self))
            
            guard let viewController = viewController as? AnalysisViewController else { return }
            
            navigationController?.pushViewController(viewController, animated: true)

        case 2:
            
            let viewController = ReleaseRecordViewController()
            
            navigationController?.pushViewController(viewController, animated: true)

        case 3:
            
            let viewController = CertificationViewController()
            
            navigationController?.pushViewController(viewController, animated: true)
            
        default: break
            
        }
        
    }
    
}
