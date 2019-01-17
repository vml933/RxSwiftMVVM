//
//  Protocol.swift
//  RxSwiftMVVM
//
//  Created by Mark on 2019/1/16.
//  Copyright © 2019 Mark. All rights reserved.
//

import RxCocoa
import RxSwift

enum ValidationResult{
    case ok(message:String)
    case fail(message:String)
    case empty
    case validating
}

extension ValidationResult{
    var isValid:Bool{
        switch self {
        case .ok:
            return true
        default:
            return false
        }
    }
}

enum signupState{
    case signUp(signUp:Bool)
}

protocol GitHubValidationService {
    func validationUsername(_ username:String) -> Observable<ValidationResult>
    func validationPwd(_ pwd:String)->ValidationResult
    func validationRepeatPwd(_ pwd:String, _ repeatPwd:String)->ValidationResult
}

protocol GitHubAPI{
    func usernameAvailable(_ username:String) -> Observable<Bool>
    func signup(_ username:String, _ pwd:String) -> Observable<Bool>
}
