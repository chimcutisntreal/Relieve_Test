//
//  TimerViewController.swift
//  Relieve_Test
//
//  Created by Chinh on 12/4/18.
//

import UIKit

class TimerViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {

    var seconds : Int!
    var timer = Timer()
    var isTimerRunning = false
    var resumeTapped = false
    var cancelTapped = false
    var hour : Int!
    var minute : Int!
    var fullView = UIView()
    
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var countDownButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var homeButton: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradient()
        disableButton(button: startButton)
        disableButton(button: pauseButton)
        countDownButton.setTitle("Tap here to set timer", for: .normal)
        
    }

    func disableButton(button: UIButton) {
        button.isEnabled = false
        button.isEnabled = false
        
        button.setTitleColor(UIColor.lightText, for: .normal)
        button.setTitleColor(UIColor.lightText, for: .normal)
    }
    
    func enableButton(button: UIButton) {
        button.isEnabled = true
        button.isEnabled = true
        
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
    }
    @IBAction func pressOnHome(_ sender: Any) {
        let Home = storyboard?.instantiateViewController(withIdentifier: "Home") as! HomeViewController
        self.present(Home, animated: true, completion: nil)
    }
    
    @IBAction func pressOnCD(_ sender: Any) {
        //timerPicker
        timePicker()
        disableButton(button: startButton)
        disableButton(button: pauseButton)
    }


    @IBAction func startButtonTapped(_ sender: UIButton) {
        if self.cancelTapped == false {
            isTimerRunning = true
            runTimer()
            startButton.setTitle("Cancel", for: .normal)
            enableButton(button: pauseButton)
            self.cancelTapped = true
            
        } else {
            timer.invalidate()
            countDownButton.setTitle("Tap here to set timer", for: .normal)
            isTimerRunning = false
            startButton.setTitle("Start", for: .normal)
            self.cancelTapped = false
            
            disableButton(button: startButton)
            disableButton(button: pauseButton)
            pauseButton.setTitle("Pause", for: .normal)
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
        pauseButton.isEnabled = true
    }
    
    @IBAction func pauseButtonTapped(_ sender: UIButton) {
        if self.resumeTapped == false {
            timer.invalidate()
            isTimerRunning = false
            self.resumeTapped = true
            self.pauseButton.setTitle("Resume",for: .normal)
        } else {
            runTimer()
            self.resumeTapped = false
            isTimerRunning = true
            self.pauseButton.setTitle("Pause",for: .normal)
        }
    }
    
    
    
    @objc func updateTimer() {
        if seconds == 0 {
            timer.invalidate()
            let alert = UIAlertController(title: "Time's Up", message: nil, preferredStyle: .alert)
            
            let OK = UIAlertAction(title: "Got it!", style: .default, handler: nil)
            alert.addAction(OK)
            self.present(alert, animated: true, completion: nil)
        } else {
            seconds -= 1
            countDownButton.setTitle(timeString(time: TimeInterval(seconds)), for: .normal)
            
        }
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02d:%02d:%02d", hours, minutes, seconds)
    }

    //UIPICKERVIEW
    func timePicker(){
        fullView = UIView(frame: CGRect(x: 0, y: view.frame.height - 260, width: view.frame.width, height: 260))
        
        //ToolBar
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: fullView.frame.width, height: 40))
        
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.items = [cancelButton,spaceButton,doneButton]
        toolBar.isUserInteractionEnabled = true
        fullView.addSubview(toolBar)
        
        let timePicker: UIPickerView = UIPickerView()
        timePicker.delegate = self
        timePicker.dataSource = self
        
        timePicker.frame = CGRect(x: 0, y: toolBar.frame.height, width: self.view.frame.width, height: 220)
        timePicker.backgroundColor = UIColor(red: 79/255, green: 122/255, blue: 98/255, alpha: 0.5)
        timePicker.tintColor = .white
        fullView.addSubview(timePicker)
        
        self.view.addSubview(fullView)
        disableButton(button: startButton)
        disableButton(button: pauseButton)
        homeButton.isEnabled = false
        
        
    }
    //PICKERVIEWDELEGATE
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 24
        } else {
            return 60
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return String(format: "%02i hours ",row)
        } else {
            return String(format: "%02i minutes ",row)
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            hour = row
            print("hour: ",hour)
        } else {
            minute = row
            print("minute: ",minute)
        }
        
        self.seconds = ((hour ?? 0)*3600)+((minute ?? 0)*60)
        self.countDownButton.setTitle(self.timeString(time: TimeInterval(self.seconds)), for: .normal)
        self.countDownButton.titleLabel?.font = UIFont(name: "Rockwell", size: 40)
    }
    
    @objc func doneClick() {
        enableButton(button: startButton)
        homeButton.isEnabled = true
        
        self.fullView.removeFromSuperview()
        self.pauseButton.isEnabled = false
    }
    @objc func cancelClick() {
        countDownButton.setTitle("Tap here to set timer", for: .normal)
        disableButton(button: startButton)
        disableButton(button: pauseButton)
        self.fullView.removeFromSuperview()
    }

}


