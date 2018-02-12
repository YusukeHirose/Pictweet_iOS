//
//  PostViewController.swift
//  Pictweet
//
//  Created by User on 2018/02/06.
//  Copyright © 2018年 User. All rights reserved.
//

import UIKit
import NCMB

class PostViewController: UIViewController {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var postScrollView: UIScrollView!
    @IBOutlet weak var selectMessageLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.cornerRadius = 2
        //キーボードが出現or消滅した際の通知先を設定
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
        sendButton.isHidden = true
    }
    
    @IBAction func didTapCameraButton(_ sender: UIButton) {
        let sourceType = UIImagePickerControllerSourceType.camera
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = sourceType
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapLibraryButton(_ sender: UIButton) {
        let sourceType = UIImagePickerControllerSourceType.photoLibrary
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = sourceType
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //キーボードが表示されたときに呼ばれるメソッド
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any] else { return }
        guard let keyboardInfo = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double else { return }
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0) //余白
        UIView.animate(withDuration: duration, animations: {
            self.postScrollView.contentInset = contentInsets
            self.postScrollView.scrollIndicatorInsets = contentInsets
            self.postScrollView.contentOffset = CGPoint.init(x: 0, y: keyboardSize.height)
            self.view.layoutIfNeeded()
        })
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        postScrollView.contentInset = .zero
        postScrollView.scrollIndicatorInsets = .zero
    }
    
    @IBAction func didTapSendButton(_ sender: UIButton) {
        if let image = postImageView.image {
            //postImageブランチでは1になっていると思いますが、0.1にしてください。
            let data = UIImageJPEGRepresentation(image, 0.1)
            let fileName = NSUUID().uuidString + ".jpg"
            let file = NCMBFile.file(withName: fileName, data: data) as! NCMBFile
            file.saveInBackground(){ error in
                if error != nil {
                    print("ファイル作成失敗")
                }
            }
            if let comment = commentTextView.text {
                let tweet = Tweet(imageFileName: fileName, comment: comment)
                tweet.save()
            } else {
                let tweet = Tweet(imageFileName: fileName, comment: "")
                tweet.save()
            }
        }
    }
    
    @objc func toTimeLine(sender: Any) {
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "navi")
        self.present(nextView, animated: true, completion: nil)
    }
    
}

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            postImageView.image = pickedImage
            postImageView.backgroundColor = UIColor.clear
            selectMessageLabel.isHidden = true
            sendButton.isHidden = false
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
