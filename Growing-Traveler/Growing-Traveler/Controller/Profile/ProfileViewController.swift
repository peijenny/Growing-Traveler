//
//  ProfileViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/22.
//

import UIKit
import PKHUD

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileView: ProfileView!
    
    @IBOutlet weak var featureCollectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, FeatureType>?
    
    var userManager = UserManager()
    
    var userInfo: UserInfo?
    
    let featureList: [FeatureType] = [.mandate, .analysis, .release, .license]
    
    let featureImage: [ImageAsset] = [.undrawTask, .undrawChart, .undrawFAQ, .undrawExperience]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureDataSource()
        
        setNavigationItems()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchUserInfoData()
        
        if userID == "" {
            
            tabBarController?.selectedIndex = 0
            
        }
        
    }
    
    func setNavigationItems() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage.asset(.edit), style: .plain, target: self, action: #selector(setProfileButton))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage.asset(.block), style: .plain, target: self, action: #selector(blockadeFriendButton))
        
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
                
                HUD.flash(.labeledError(title: "資料獲取失敗！", subtitle: "請稍後再試"), delay: 0.5)
                
            }
            
        }
        
    }
    
    func setProfileView() {
        
        guard let userInfo = userInfo else { return }
        
        profileView.userNameLabel.text = userInfo.userName
        
        if userInfo.userPhoto != "" {
            
            profileView.userPhotoImageView.loadImage(userInfo.userPhoto)
            
        } else {
            
            profileView.userPhotoImageView.image = UIImage.asset(.userIcon)
            
        }
        
        profileView.experienceValueLabel.text = "Ex. \(userInfo.achievement.experienceValue)"
        
    }
    
    func configureDataSource() {
        
        featureCollectionView.register(
            UINib(nibName: String(describing: FeatureCollectionViewCell.self), bundle: nil),
            forCellWithReuseIdentifier: String(describing: FeatureCollectionViewCell.self))
        
        dataSource = UICollectionViewDiffableDataSource.init(
        collectionView: featureCollectionView) { collectionView, indexPath, item in
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: FeatureCollectionViewCell.self), for: indexPath)
            
            guard let cell = cell as? FeatureCollectionViewCell else { return cell }
                
            cell.featureItemLabel.text = self.featureList[indexPath.item].title
            
            cell.featureImageView.image = UIImage.asset(self.featureImage[indexPath.item])
            
            return cell
            
        }
        
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
        
    }

}

extension ProfileViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.item {

        case 0:
            
            let viewController = MandateViewController()
            
            navigationController?.pushViewController(viewController, animated: true)
            
        case 1:
            
            let viewController = UIStoryboard.profile.instantiateViewController(
                withIdentifier: String(describing: AnalysisViewController.self))
            
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
