//
//  BindingExtension.swift
//  RxSwiftMVVM
//
//  Created by Mark on 2019/1/16.
//  Copyright © 2019 Mark. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

extension ValidationResult:CustomStringConvertible{
    var description: String {
        switch self {
        case .validating:
            return "Validating..."
        case .ok(let message):
            return message
        case .fail(let message):
            return message
        default:
            return ""
        }
    }
}

extension ValidationResult{
    var textColor:UIColor{
        switch self {
        case .empty:
            return UIColor.black
        case .ok:
            return UIColor.green
        case .fail:
            return UIColor.red
        case .validating:
            return UIColor.blue
        }
    }
}

extension Reactive where Base:UILabel{
    var validationResult:Binder<ValidationResult>{
        return Binder(base){ (label, result) in
            label.textColor = result.textColor
            label.text = result.description
        }
    }
}

extension String{
    
    var URLEscaped:String{
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}
