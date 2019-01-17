//
//  TestViewController.swift
//  RxSwiftMVVM
//
//  Created by Mark on 2019/1/17.
//  Copyright © 2019 Mark. All rights reserved.
//

import UIKit
import Photos
import RxSwift


class TestViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnGet: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let imagePicker = UIImagePickerController()
        
        /*
        btnGet.rx.tap
            .asObservable()
            .bind { [weak self] () in
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = false
                self?.present(imagePicker, animated: true, completion: nil)
        }
        .disposed(by: disposeBag)
        
        imagePicker.rx
            .didFinishPickingMediaWthInfo
            .map{$0[UIImagePickerController.InfoKey.originalImage] as! UIImage}
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
        
        imagePicker.rx
            .didFinishPickingMediaWthInfo
            .subscribe(onNext: { _ in
                imagePicker.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        */
        
        btnGet.rx.tap
            .asObservable()
            .flatMapLatest { [weak self] in
                 return UIImagePickerController.rx.createWithParent(self){ picker in
                        picker.sourceType = .photoLibrary
                        picker.allowsEditing = false}
                        .flatMap{$0.rx.didFinishPickingMediaWthInfo}
                        .take(1) // because there is no observer.onComplete() in the createWithParent(), so we use take(1) force after emited once and than complete(bring to createWithParent() force called)
            }
            .map{
                $0[UIImagePickerController.InfoKey.originalImage] as! UIImage
            }
            .bind(to: imageView.rx.image)
            .disposed(by: disposeBag)
        
//        btnGet.rx.tap
//            .asObservable()
//            .flatMapLatest { [weak self] in
//                return UIImagePickerController.rx.createWithParent(self){ picker in
//                    picker.sourceType = .photoLibrary
//                    picker.allowsEditing = false}
////                    .flatMap{$0.rx.didFinishPickingMediaWthInfo}
////                    .take(1)
//            }
//            .subscribe { (event) in
//                switch event{
//                case .next:
//                    print("hihi next:\(event.element)")
//                case .error:
//                    print("hihi error")
//                case .completed:
//                    print("hihi oncomplete")
//
//                }
//            }
//            .disposed(by: disposeBag)
        
    }
    
}
