//
//  RxUIApplicationDelegateProxy.swift
//  RxSwiftMVVM
//
//  Created by Mark on 2019/1/17.
//  Copyright © 2019 Mark. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public class RxUIApplicationDelegateProxy:
    DelegateProxy<UIApplication, UIApplicationDelegate>,
    DelegateProxyType,
UIApplicationDelegate{
    
    public init(application:UIApplication){
        super.init(parentObject: application, delegateProxy: RxUIApplicationDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { (application) -> RxUIApplicationDelegateProxy in
            return RxUIApplicationDelegateProxy(application: application)
        }
    }
    
    public static func currentDelegate(for object: UIApplication) -> UIApplicationDelegate? {
        return object.delegate
    }
    
    public static func setCurrentDelegate(_ delegate: UIApplicationDelegate?, to object: UIApplication) {
        object.delegate = delegate
    }
    
    public override func setForwardToDelegate(_ delegate: UIApplicationDelegate?, retainDelegate: Bool) {
        return super.setForwardToDelegate(delegate, retainDelegate: true)
    }
    
}
