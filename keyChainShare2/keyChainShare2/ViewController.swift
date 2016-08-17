//
//  ViewController.swift
//  keyChainShare1
//
//  Created by Scott Moon on 8/17/16.
//  Copyright © 2016 scott. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // 키체인 그룹 엑세스 ID
    let key : String = "FNDVP9SLK2.com.scott.keyChainShare1.infoData"
    // 사용할 키체인 데이터 콜룸 설정
    let classKey: String = "dataKey"
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.text = self.insertKeyChainData()
    }
    
    
    
}

extension ViewController : keychainClass {
    
    func insertKeyChainData() -> String {
        // 데이터가 없을 경우 : -25300 오류가 날 수 있음
        // 초기 이니셜 라이징을 했을 경우, 그냥 무시해도 좋음
        // 자세한 에러 코드 정의는 KeychainExtension.swift 클래스 참고
        return self.findValue(key, classKey: classKey)
    }
    
    func commited(textField: UITextField) {
        if textField.text?.isEmpty == false {
            self.addValue(key, classKey: classKey, value: textField.text!)
        }
        
        self.view.endEditing(true)
    }
}

//Mark: -UITextField 딜리게이트 함수들
extension ViewController : UITextFieldDelegate {
    // textField Delegate
    func textFieldDidEndEditing(textField: UITextField) {
        self.commited(textField)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.commited(textField)
        return true
    }
}

//MARK: - 버튼 액션 함수들
extension ViewController {
    
    @IBAction func commitedAction(sender: AnyObject) {
        self.commited(textField)
    }
    

}



