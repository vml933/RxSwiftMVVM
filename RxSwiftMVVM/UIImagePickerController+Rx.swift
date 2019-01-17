//
//  UIImagePickerController+Rx.swift
//  RxSwiftMVVM
//
//  Created by Mark on 2019/1/17.
//  Copyright © 2019 Mark. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

extension Reactive where Base:UIImagePickerController {
    
    var pickerDelegate:DelegateProxy<UIImagePickerController, UIImagePickerControllerDelegate & UINavigationControllerDelegate>{
        return RxImagePickerDelegateProxy.proxy(for: base)
    }
    
    var didFinishPickingMediaWthInfo:Observable<[UIImagePickerController.InfoKey:Any]>{
        return pickerDelegate.methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerController(_:didFinishPickingMediaWithInfo:)))
            .map{param in                
                return try self.castOrThrow(Dictionary<UIImagePickerController.InfoKey, Any>.self, param[1])
            }
    }
    
    var didCancel:Observable<()>{
        return pickerDelegate.methodInvoked(#selector(UIImagePickerControllerDelegate.imagePickerControllerDidCancel(_:)))
            .map{ param in
                ()
            }
    }
    
    fileprivate func castOrThrow<T>(_ resultType:T.Type, _ object:Any) throws -> T {
        guard
            let returnValue = object as? T
        else {
            throw RxCocoaError.castingError(object: object, targetType: resultType)
        }
        return returnValue
    }
}
