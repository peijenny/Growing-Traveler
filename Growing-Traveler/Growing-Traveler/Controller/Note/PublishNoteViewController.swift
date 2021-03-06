//
//  PublishNoteViewController.swift
//  Growing-Traveler
//
//  Created by Jenny Hung on 2022/4/29.
//

import UIKit

class PublishNoteViewController: BaseViewController {

    // MARK: - IBOutlet / Components
    @IBOutlet weak var noteTitleTextField: UITextField!
    
    @IBOutlet weak var modifyTimeLabel: UILabel!
    
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBOutlet weak var uploadImageButton: UIButton!
    
    // MARK: - Property
    var userManager = UserManager()
    
    var modifyNote: Note?
    
    var imageLink: String?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationItem()
       
        setUIStyle()
        
    }
    
    override var hidesBottomBarWhenPushed: Bool {
        
        get {
            
            return navigationController?.topViewController == self
            
        } set {
            
            super.hidesBottomBarWhenPushed = newValue
            
        }
        
    }
    
    // MARK: - Set UI
    func setUIStyle() {
     
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        
        var createTime = Date()
        
        if modifyNote == nil {
            
            createTime = Date(timeIntervalSince1970: TimeInterval(Int(Date().timeIntervalSince1970)))
            
        } else {
            
            createTime = Date(timeIntervalSince1970: modifyNote?.createTime ?? TimeInterval())
            
            setModifyData()
            
        }
        
        modifyTimeLabel.text = formatter.string(from: createTime)

        
        noteTextView.layer.borderColor = UIColor.hexStringToUIColor(hex: "9C8F96").cgColor
        
        noteTextView.layer.borderWidth = 1
        
        noteTextView.layer.cornerRadius = 5
        
        if noteTextView.text == "請描述內容......" {
            
            noteTextView.textColor = UIColor.lightGray
            
        } else {
            
            noteTextView.textColor = UIColor.black
            
        }

        noteTextView.delegate = self
        
        view.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText)
        
        uploadImageButton.backgroundColor = UIColor.hexStringToUIColor(hex: ColorChat.lightBlue.hexText)
        
        uploadImageButton.cornerRadius = 5
        
    }
    
    func setNavigationItem() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done, target: self, action: #selector(checkNote))
        
    }

    // MARK: - Method
    func checkFullIn() {
        
        guard let inputTitle = noteTitleTextField.text, !inputTitle.isEmpty else {
            
            HandleInputResult.titleEmpty.messageHUD
            
            return
        }
        
        var noteContents: [ArticleContent] = []
        
        let inputContentArray = checkInputContent()
        
        var noteType = String()
        
        for index in 0..<inputContentArray.count {
            
            if inputContentArray[index].range(of: "https://i.imgur.com") != nil {
                
                noteType = SendType.image.title
                
            } else {
                
                noteType = SendType.string.title
                
            }
            
            let noteContent = ArticleContent(
                orderID: index, contentType: noteType, contentText: inputContentArray[index])
            
            noteContents.append(noteContent)
            
        }
        
        if modifyNote == nil {
            
            let noteID = userManager.database.document().documentID
            
            let createTime = TimeInterval(Int(Date().timeIntervalSince1970))
            
            let note = Note(
                userID: KeyToken().userID, noteID: noteID, createTime: createTime,
                noteTitle: inputTitle, content: noteContents)
            
            HandleResult.addDataFailed.messageHUD
            
            userManager.updateUserNote(note: note)
            
            navigationController?.popViewController(animated: true)
            
        } else {
            
            guard var modifyNote = modifyNote else { return }
            
            modifyNote.noteTitle = inputTitle
            
            modifyNote.createTime = TimeInterval(Int(Date().timeIntervalSince1970))
            
            modifyNote.content = noteContents
            
            HandleResult.updateDataFailed.messageHUD
            
            userManager.updateUserNote(note: modifyNote)
            
            navigationController?.popToViewController(
                navigationController?.viewControllers[1] ?? UIViewController(), animated: true)
            
        }
        
    }
    
    func setModifyData() {
        
        noteTitleTextField.text = modifyNote?.noteTitle
        
        var contentText = ""
        
        guard let modifyNote = modifyNote else { return }

        for index in 0..<modifyNote.content.count {
            
            if modifyNote.content[index].contentType == SendType.image.title {
                
                contentText += "\0\(modifyNote.content[index].contentText)\0"
                 
            } else if modifyNote.content[index].contentType == SendType.string.title {
                
                contentText += modifyNote.content[index].contentText
                
            }
            
        }
        
        noteTextView.text = contentText
        
    }
    
    func insertPictureToTextView(imageLink: String) {

        guard let imageURL = URL(string: imageLink) else { return }
        
        let data = try? Data(contentsOf: imageURL)
        
        // create image
        let attachment = NSTextAttachment()
        
        guard let image = UIImage(data: data ?? Data()) else { return }
        
        attachment.image = image

        // setting image size
        let imageAspectRatio = CGFloat(image.size.height / image.size.width)

        let imageWidth = noteTextView.frame.width - 2 * CGFloat(0)

        let imageHeight = imageWidth * imageAspectRatio

        attachment.bounds = CGRect(x: 0, y: 0, width: imageWidth * 0.6, height: imageHeight * 0.6)
        
        // get all taxtView content, and change to can be edit
        let mutableStr = NSMutableAttributedString(attributedString: noteTextView.attributedText)
        
        // get now location of the cursor
        let selectedRange = noteTextView.selectedRange
        
        mutableStr.insert(NSAttributedString(string: "\n\0\(imageLink)\0\n\n"), at: selectedRange.location)

        let attribute = [ NSAttributedString.Key.font: UIFont(name: "PingFang TC", size: 15.0)! ]
        
        noteTextView.attributedText = NSAttributedString(string: mutableStr.string, attributes: attribute)
        
    }
    
    func checkInputContent() -> [String] {
        
        var contentArray: [String] = []
        
        if noteTextView.text.range(of: "https://i.imgur.com") == nil {
            
            if !noteTextView.text.isEmpty {
                
                contentArray = [noteTextView.text]
                
            } else {
                
                HandleInputResult.contentEmpty.messageHUD
                
            }
            
        } else {
            
            contentArray = noteTextView.attributedText.string.split(separator: "\0").map({ String($0) })
            
        }
        
        return contentArray
        
    }
    
    // MARK: - Target / IBAction
    @objc func checkNote(sender: UIButton) {
        
        checkFullIn()
        
    }
     
    @IBAction func uploadImageButton(_ sender: UIButton) {
     
        let picker = UIImagePickerController()
        
        picker.delegate = self
        
        present(picker, animated: true)
        
    }
    
}

// MARK: - ImagePickerController delegate
extension PublishNoteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let image = info[.originalImage] as? UIImage {

            let uploadImageManager = UploadImageManager()

            uploadImageManager.uploadImage(uiImage: image, completion: { [weak self] result in

                guard let self = self else { return }

                switch result {

                case.success(let imageLink):

                    self.imageLink = imageLink
                    
                    self.insertPictureToTextView(imageLink: imageLink)

                case .failure:
                    
                    HandleResult.readDataFailed.messageHUD

                }

            })

        }

        dismiss(animated: true)

    }
    
}

// MARK: - TextView delegate
extension PublishNoteViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            
            textView.text = nil
            
            textView.textColor = UIColor.black
            
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            
            textView.text = "請描述內容......"
            
            textView.textColor = UIColor.lightGray
            
        }
        
    }
    
}
