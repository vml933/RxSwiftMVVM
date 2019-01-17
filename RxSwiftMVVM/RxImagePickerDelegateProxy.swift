//
//  RxImagePickerDelegateProxy.swift
//  RxSwiftMVVM
//
//  Created by Mark on 2019/1/17.
//  Copyright © 2019 Mark. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RxImagePickerDelegateProxy:
    DelegateProxy<UIImagePickerController, UIImagePickerControllerDelegate & UINavigationControllerDelegate>,
    DelegateProxyType,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate{
    
    public init(imagePicker:UIImagePickerController){
        super.init(parentObject: imagePicker, delegateProxy: RxImagePickerDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { (imagePicker) -> RxImagePickerDelegateProxy in
            return RxImagePickerDelegateProxy(imagePicker: imagePicker)
        }
    }
    
    static func currentDelegate(for object: UIImagePickerController) -> (UIImagePickerControllerDelegate & UINavigationControllerDelegate)? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?, to object: UIImagePickerController) {
        object.delegate = delegate
    }
    
    
}
