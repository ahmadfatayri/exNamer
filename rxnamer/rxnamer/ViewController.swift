//
//  ViewController.swift
//  rxnamer
//
//  Created by Ahmad Fatayri on 3/28/19.
//  Copyright © 2019 Ahmad Fatayri. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var nameEntryTextField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var namesLbl: UILabel!
    @IBOutlet weak var helloLbl: UILabel!
    
    let disposeBag = DisposeBag()
    var namesArray: Variable<[String]> = Variable([])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindTextField()
        bindSubmitButton()
    }

    func bindTextField() {
        
        nameEntryTextField.rx.text
            .debounce(0.5, scheduler: MainScheduler.instance)
            .map {
                if $0 == "" {
                    return "Type your name below"
                }
                else {
                    return "Hello, \($0!)."
                }
            }
            .bind(to: helloLbl.rx.text)
            .addDisposableTo(disposeBag)
    }
    
    func bindSubmitButton() {
        submitBtn.rx.tap
            .subscribe(onNext: {
                if self.nameEntryTextField.text != "" {
                    self.namesArray.value.append(self.nameEntryTextField.text!)
                    self.namesLbl.rx.text.onNext(self.namesArray.value.joined(separator: ", "))
                    self.nameEntryTextField.rx.text.onNext("")
                    self.helloLbl.rx.text.onNext("Type your name below")
                }
            })
            .addDisposableTo(disposeBag)
    }
    
}

