//
//  ViewController.swift
//  RxSwiftMVVM
//
//  Created by Mark on 2019/1/11.
//  Copyright © 2019 Mark. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    

    @IBOutlet weak var inputUsername: UITextField!
    @IBOutlet weak var lbUsername: UILabel!
    @IBOutlet weak var inputPwd: UITextField!
    @IBOutlet weak var lbPwd: UILabel!
    @IBOutlet weak var InputRepeatPwd: UITextField!
    @IBOutlet weak var lbRepeatPwd: UILabel!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var activityIcon: UIActivityIndicatorView!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = ViewModel(
            input: (
                username: inputUsername.rx.text.orEmpty.asDriver().throttle(2),
                pwd: inputPwd.rx.text.orEmpty.asDriver(),
                repeatPwd: InputRepeatPwd.rx.text.orEmpty.asDriver(),
                tap: btnSignUp.rx.tap.asSignal()
            ),
            dependency: (
                validateService: GitHubDefaultValidationService.sharedService,
                api: GitHubDefaultAPI.sharedAPI))
        
        viewModel.signupEnable
            .drive(btnSignUp.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.validationUsername
            .drive(lbUsername.rx.validationResult)
            .disposed(by: disposeBag)
        
        viewModel.validationPwd
            .drive(lbPwd.rx.validationResult)
            .disposed(by: disposeBag)
        
        viewModel.validationRepeatPwd
            .drive(lbRepeatPwd.rx.validationResult)
            .disposed(by: disposeBag)
        
        viewModel.signedIn
            .drive(onNext: { (result) in
                print("signIn result:\(result)")
            })
            .disposed(by: disposeBag)
        
        viewModel.signingIn
            .drive(activityIcon.rx.isAnimating)
            .disposed(by: disposeBag)
        
    }
    
    
    


}

