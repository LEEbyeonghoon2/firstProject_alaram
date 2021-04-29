//
//  plusSchedule.swift
//  firstProject_Schedule
//
//  Created by 이병훈 on 2021/01/31.
//

import UIKit
import UserNotifications

class plusSchedule: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var alaramAgree: UISwitch!
    @IBOutlet weak var doingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var alarmLabel: UILabel!
    let datePicker = UIDatePicker()
    let textField1 = UITextField()
    let formatter = DateFormatter()

//    var date: Int! = nil
    
    override func viewDidLoad() {
        textFieldUI()
        createDate()
        self.view.addSubview(textField1)
        self.textField1.leadingAnchor.constraint(equalTo: self.doingLabel.trailingAnchor,constant: 90).isActive = true
        self.textField1.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 10).isActive = true
    }
    func textFieldUI() {
        self.textField1.frame = CGRect(x: 150, y: 100, width: 200, height: 34)
        self.textField1.backgroundColor = .none
        self.textField1.font = UIFont.systemFont(ofSize: 20)
        self.textField1.layer.cornerRadius = 5
        self.textField1.placeholder = "할일을 적으세요"
        self.textField1.layer.borderWidth = 0.1
        self.textField1.delegate = self
        if self.textField1.adjustsFontSizeToFitWidth == false {
            self.textField1.adjustsFontSizeToFitWidth = true
        }
    }
    func createDate() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(selectbtn))
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelbtn))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) // 서로 버튼간의 공간 추가를 위한 BarButton
        
        cancelBtn.tintColor = .red
        
        toolbar.setItems([cancelBtn,flexibleSpace,doneBtn], animated: true)
        self.dateText.inputAccessoryView = toolbar
        
        self.dateText.inputView = datePicker
        datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.datePickerMode = .dateAndTime
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.isEmpty == true {
            let alert = UIAlertController(title: "텍스트 필드창이 비어있습니다.", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            
            self.present(alert, animated: true)
        }
        textField.resignFirstResponder() //키보드 내려가게 하기
        
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        return true
    }
    @objc func selectbtn() {
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        self.dateText.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    @objc func cancelbtn() {
        self.view.endEditing(true)
    }

    @IBAction func addSchedule(_ sender: Any) {
        var data = scheduleInfo()
        data.date = self.dateText.text
        data.alarm = self.alaramAgree.isOn
        data.doing = self.textField1.text

        let ad = UIApplication.shared.delegate as? AppDelegate //appdelegate 인스턴스 가저옴
        ad?.scheduleList.append(data)
        DispatchQueue.main.async {//메인스레드로 실행하기
            if self.alaramAgree.isOn == true {
                UNUserNotificationCenter.current().getNotificationSettings(){ setting in
                    if setting.authorizationStatus == UNAuthorizationStatus.authorized {
                        let nContent = UNMutableNotificationContent()
                        nContent.badge = 1
                        nContent.title = "\(data.doing!)"
                        nContent.body = "body alarm"
                        nContent.sound = .default

                        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self.datePicker.date) //date를 dateComponents로 변환하기 미쳤다

                        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

                        let request = UNNotificationRequest(identifier: "test", content: nContent, trigger: trigger)

                        UNUserNotificationCenter.current().add(request)
                    } else {
                        print("no access")
                    }
                }
            } else {
                print("알람 설정 안함")
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
