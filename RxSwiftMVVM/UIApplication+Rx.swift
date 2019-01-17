//
//  UIApplication+Rx.swift
//  RxSwiftMVVM
//
//  Created by Mark on 2019/1/17.
//  Copyright © 2019 Mark. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

public enum AppState{
    case active
    case inactive
    case background
    case terminted
}

//for first subscribe 
extension UIApplication.State {
    func toState()->AppState{
        switch self {
        case .active:
            return .active
        case .background:
            return .background
        case .inactive:
            return .inactive
        }
    }
}

extension Reactive where Base:UIApplication{
    
    var delegate:DelegateProxy<UIApplication, UIApplicationDelegate>{
       return RxUIApplicationDelegateProxy.proxy(for: base)
    }
    
    var didBecomeActive:Observable<AppState>{
        return delegate.methodInvoked(#selector(UIApplicationDelegate.applicationDidBecomeActive(_:)))
            .map{ _ in return .active }
    }
    
    var willResignActive:Observable<AppState>{
        return delegate.methodInvoked(#selector(UIApplicationDelegate.applicationWillResignActive(_:)))
            .map{ _ in return .inactive}
    }
    
    var willEnterForeground:Observable<AppState>{
        return delegate.methodInvoked(#selector(UIApplicationDelegate.applicationWillEnterForeground(_:)))
            .map{_ in return .inactive}
    }
    
    var didEnterForeground:Observable<AppState>{
        return delegate.methodInvoked(#selector(UIApplicationDelegate.applicationDidEnterBackground(_:)))
            .map{_ in return .active}
    }
    
    var willTerminate:Observable<AppState>{
        return delegate.methodInvoked(#selector(UIApplicationDelegate.applicationWillTerminate(_:)))
            .map{_ in return .terminted}
    }
    
    var state:Observable<AppState> {
        return Observable
            .merge([didBecomeActive, willResignActive, willEnterForeground, didEnterForeground, willTerminate])
            .startWith(base.applicationState.toState())
    }
    
    
    
    
    
}
