//
//  ProfileViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/22.
//

import UIKit

enum FeatureType {
    
    case mandate
    
    case rank
    
    case note
    
    case release
    
    case license
    
    var title: String {
        
        switch self {
            
        case .mandate: return "成長任務"
            
        case .rank: return "學習排行榜"
            
        case .note: return "學習筆記"
            
        case .release: return "發布紀錄"
            
        case .license: return "個人認證"
            
        }
        
    }
    
}

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileView: ProfileView!
    
    @IBOutlet weak var featureCollectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, FeatureType>?
    
    let featureList: [FeatureType] = [.mandate, .rank, .note, .release, .license]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureDataSource()
        
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
        
        print("TEST \(indexPath.item)")
        
        switch indexPath.item {

        case 0:
            
            let viewController = MandateViewController()
            
            navigationController?.pushViewController(viewController, animated: true)
            
        case 1: break

        case 2: break

        case 3: break

        case 4: break

        default: break
            
        }
        
    }
    
}