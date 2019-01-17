//
//  UIImagePickerController+RxCreate.swift
//  RxSwiftMVVM
//
//  Created by Mark on 2019/1/17.
//  Copyright © 2019 Mark. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base:UIImagePickerController{
    
    static func createWithParent(_ parent:UIViewController?,
                                animated:Bool = true,
                                configurate:@escaping (UIImagePickerController)throws->(Void)) -> Observable<UIImagePickerController>{
        
        return Observable.create({ [weak parent] (observer) -> Disposable in
            
            let imagePicker = UIImagePickerController()
            
//            let disposable1 =
//                Observable
//                .merge(
//                    imagePicker.rx.didFinishPickingMediaWthInfo.map{_ in ()},
//                    imagePicker.rx.didCancel)
//                .subscribe(onNext: { () in
//                        //trigger return dispose
//                        observer.onCompleted()
//                })
            
            //click cancel handler
            let disposable1 =
                imagePicker.rx
                    .didCancel
                    .subscribe(onNext: { [weak imagePicker] in
                        guard
                            let imagePicker = imagePicker
                            else{return}
                            dismissViewController(imagePicker, animated:animated)
                    })
            
            let disposable2 =
                Disposables.create {
                  dismissViewController(imagePicker, animated:animated)
            }
            
            let disposable3 = Disposables.create {
                print("hihi this custome dispose trigger")
            }
            
            do{
                try configurate(imagePicker)
            }catch{
                observer.onError(error)
                return Disposables.create()
            }
            guard
                let parent = parent
                else{
                    observer.onCompleted()
                    return Disposables.create()
            }
            
            parent.present(imagePicker, animated: true, completion: nil)
            observer.onNext(imagePicker)

            //when observer.onCompleted() called,
            //call disposable2 & disposable3 code auto exec,
            //add disposable1 beacuse to add gc mechism
            return Disposables.create(disposable1, disposable2, disposable3)            
//            return disposable2
        })
        
    }
    
    static func dismissViewController(_ viewController:UIViewController, animated:Bool){
        
        if viewController.isBeingPresented || viewController.isBeingPresented {
            DispatchQueue.main.async {
                dismissViewController(viewController, animated: animated)
            }
            return
        }
        
        if viewController.presentingViewController != nil {
            viewController.dismiss(animated: animated, completion: nil)
        }
    }
}
