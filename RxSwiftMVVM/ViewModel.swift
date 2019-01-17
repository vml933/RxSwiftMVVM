//
//  ViewModel.swift
//  RxSwiftMVVM
//
//  Created by Mark on 2019/1/16.
//  Copyright © 2019 Mark. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewModel {
    
    let validationUsername:Driver<ValidationResult>
    let validationPwd:Driver<ValidationResult>
    let validationRepeatPwd:Driver<ValidationResult>
    
    let signupEnable:Driver<Bool>
    let signedIn:Driver<Bool>
    let signingIn:Driver<Bool>
    
    init(
        input:
        (
            username:Driver<String>,
            pwd:Driver<String>,
            repeatPwd:Driver<String>,
            tap:Signal<Void>
        ),
        dependency:
        (
            validateService:GitHubValidationService,
            api:GitHubAPI
        )
        )
    {
        let activityIndicator = ActivityIndicator()
        signingIn = activityIndicator.asDriver()
        
        validationUsername = input.username
            .flatMapLatest{
                dependency.validateService.validationUsername($0)
                    .asDriver(onErrorJustReturn: ValidationResult.fail(message: "cannot connect server"))}
        
        validationPwd = input.pwd
            .flatMapLatest{ pwd in
                let result = dependency.validateService.validationPwd(pwd)
                return Driver.just(result)
        }
        
        validationRepeatPwd = Driver.combineLatest(input.pwd, input.repeatPwd, resultSelector: dependency.validateService.validationRepeatPwd)
        
        signupEnable = Driver.combineLatest(validationUsername, validationPwd, validationRepeatPwd, signingIn, resultSelector: { (usernameResult, pwdResult, repeatPwdResult, signingValue) in
            return usernameResult.isValid &&
                pwdResult.isValid &&
                repeatPwdResult.isValid &&
                !signingValue
            
        })
        .distinctUntilChanged()
        
        let usernameAndPwd = Driver.combineLatest(input.username, input.pwd) {
            (username:$0, pwd:$1)
        }
        
        signedIn = input.tap
            .withLatestFrom(usernameAndPwd)
            .flatMapLatest({ (pair)  in                
                return dependency.api.signup(pair.username, pair.pwd)
                    .trackActivity(activityIndicator)
                    .asDriver(onErrorJustReturn: false)
            })                        
    }
}
