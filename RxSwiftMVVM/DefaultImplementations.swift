//
//  DefaultImplementations.swift
//  RxSwiftMVVM
//
//  Created by Mark on 2019/1/16.
//  Copyright © 2019 Mark. All rights reserved.
//

import RxSwift
import RxCocoa

class GitHubDefaultAPI:GitHubAPI{
    
    let urlSession:URLSession
    
    static let sharedAPI = GitHubDefaultAPI(urlSession: URLSession.shared)
    
    init(urlSession:URLSession) {
        self.urlSession = urlSession
    }
    
    func usernameAvailable(_ username: String) -> Observable<Bool> {
        let url = URL(string: "https://github.com/\(username.URLEscaped)")!
        let request = URLRequest(url: url)
        return urlSession.rx
            .response(request:  request)
            .map{ $0.response.statusCode == 404}
    }
    
    func signup(_ username: String, _ pwd: String) -> Observable<Bool> {
        print("do signup")
        let result = arc4random() % 3 == 0
        return Observable.just(result).delay(1, scheduler: MainScheduler.instance)
    }
}

class GitHubDefaultValidationService:GitHubValidationService {
    
    let minPwdCount = 5
    
    let API:GitHubAPI
    
    static let sharedService = GitHubDefaultValidationService(API: GitHubDefaultAPI.sharedAPI)
    
    init(API:GitHubAPI) {
        self.API = API
    }
    
    func validationUsername(_ username: String) -> Observable<ValidationResult> {
        if username.isEmpty {
            return Observable.just(ValidationResult.empty)
        }
        if username.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            return Observable.just(ValidationResult.fail(message: "allow contain eng & number"))
        }
        return API.usernameAvailable(username)
            .map{ $0 ? ValidationResult.ok(message: "Valid username"): ValidationResult.fail(message: "already has")}
            .startWith(ValidationResult.validating)        
    }
     
    func validationPwd(_ pwd: String) -> ValidationResult {
        if pwd.isEmpty {
            return ValidationResult.empty
        }
        if pwd.count < minPwdCount {
            return ValidationResult.fail(message: "not enough count")
        }
        return ValidationResult.ok(message: "Valid pwd")
    }
    
    func validationRepeatPwd(_ pwd: String, _ repeatPwd: String) -> ValidationResult {
        if repeatPwd.isEmpty {
            return ValidationResult.empty
        }
        if pwd != repeatPwd {
            return ValidationResult.fail(message: "pwd not match")
        }
        return ValidationResult.ok(message: "Valid repeat")
    }
    
    
}
