//
//  PublishForumArticleViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/13.
//

import UIKit
import JXPhotoBrowser

class PublishForumArticleViewController: UIViewController {

    @IBOutlet weak var publishArticleTableView: UITableView! {
        
        didSet {
            
            publishArticleTableView.delegate = self
            
            publishArticleTableView.dataSource = self
            
        }
        
    }
    
    var selectCategoryItem: CategoryItem? {
        
        didSet {
        
            publishArticleTableView.reloadData()
            
        }
        
    }
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        publishArticleTableView.register(
            UINib(nibName: String(describing: PublishArticleTypeTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: PublishArticleTypeTableViewCell.self)
        )
        
        publishArticleTableView.register(
            UINib(nibName: String(describing: PublishArticleContentTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: String(describing: PublishArticleContentTableViewCell.self)
        )

    }

}

extension PublishForumArticleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: PublishArticleTypeTableViewCell.self),
                for: indexPath
            )

            guard let cell = cell as? PublishArticleTypeTableViewCell else { return cell }
            
            cell.selectCategoryButton.addTarget(
                self, action: #selector(selectCategoryTagButton), for: .touchUpInside)
            
            cell.categoryTextField.text = selectCategoryItem?.title
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: PublishArticleContentTableViewCell.self),
                for: indexPath
            )

            guard let cell = cell as? PublishArticleContentTableViewCell else { return cell }
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapOnImage(_:)))

            cell.contentTextView.addGestureRecognizer(tap)

            cell.addImageButton.addTarget(self, action: #selector(insertImage), for: .touchUpInside)
            
            guard let image = image else { return cell }
            
            cell.insertPictureToTextView(image: image)
            
            return cell
            
        }
        
    }
    
    @objc func insertImage(sender: UIButton) {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        
        present(picker, animated: true)
        
    }
    
    @objc func selectCategoryTagButton(sender: UIButton) {
        
        let categoryViewController = SelectCategoryViewController()
        
        categoryViewController.getSelectCategoryItem = { [weak self] item in
            
            self?.selectCategoryItem = item
            
        }
        
        let navController = UINavigationController(rootViewController: categoryViewController)
        
        if let sheetPresentationController = navController.sheetPresentationController {
            
            sheetPresentationController.detents = [.medium()]
            
        }
        
        self.present(navController, animated: true, completion: nil)
        
    }

}

extension PublishForumArticleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        image = info[.originalImage] as? UIImage

        publishArticleTableView.reloadData()

        dismiss(animated: true)

    }
    
}

extension PublishForumArticleViewController {

    // MARK: - 點擊 Image
    @objc func tapOnImage(_ sender: UITapGestureRecognizer) {

        guard let textView = sender.view as? UITextView else { return }

        let layoutManager = textView.layoutManager

        var location = sender.location(in: textView)

        location.x -= textView.textContainerInset.left

        location.y -= textView.textContainerInset.top

        // 推估點擊處的字元下標
        let characterIndex = layoutManager.characterIndex(
            for: location,
            in: textView.textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil)

        if characterIndex < textView.textStorage.length {

            // 識別字元下標 characterIndex 處的 TextView 內容
            let attachment = textView.attributedText.attribute(
                NSAttributedString.Key.attachment,
                at: characterIndex,
                effectiveRange: nil) as? NSTextAttachment

            // 1.字元下標 characterIndex 處插入圖片附檔並顯示
            if let attachment = attachment {

                textView.resignFirstResponder()

                // 取得 image
                guard let attachImage = attachment.image(
                    forBounds: textView.bounds,
                    textContainer: textView.textContainer,
                    characterIndex: characterIndex
                ) else {

                    print("無法取得 Image")

                    return

                }

                // 展示 image (pop-up Image 單獨顯示的視窗)
                let browser = JXPhotoBrowser()

                browser.numberOfItems = { 1 }

                browser.reloadCellAtIndex = { context in

                    let browserCell = context.cell as? JXPhotoBrowserImageCell

                    browserCell?.imageView.image = attachImage

                }

                browser.show()

                // 2.字元下標 characterIndex 處為字元，則將游標移到點擊處字元下標

            } else {

                textView.becomeFirstResponder()

                textView.selectedRange = NSMakeRange(characterIndex + 1, 0)
                
            }

        }

    }

}
