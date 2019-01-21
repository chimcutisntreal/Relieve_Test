//
//  HomeViewController.swift
//  Relieve_Test
//
//  Created by Chinh on 11/24/18.
//

import UIKit
import AVFoundation
import Pastel

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnSetTimer: RoundedButton!

    
    var fullView = UIView()
    var audioPlayerArray = [AVAudioPlayer]()
    var audioPlayer : AVAudioPlayer!
    var selectedArray = [String]()
    var selectedIndex = [Int]()
    let items = [ "cafe", "fan", "fire", "forest",
                  "night", "rain", "stream", "thunderstorm",
                  "train", "waterdrop", "waves", "wind", ]
    var imageItems : [UIImage] = [
        UIImage(named: "cafe")!, UIImage(named: "fan")!, UIImage(named: "fire")!,
        UIImage(named: "forest")!, UIImage(named: "night")!, UIImage(named: "rain")!,
        UIImage(named: "stream")!, UIImage(named: "thunderstorm")!, UIImage(named: "train")!,
        UIImage(named: "waterdrop")!, UIImage(named: "waves")!, UIImage(named: "wind")!,
    ]
    var valueOfSlider : UILabel!
    var timerSlider : UISlider!
    var timer = Timer()
    var isRunning = false
    var countTimer : Int!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        collectionView.reloadData()
        collectionView.allowsMultipleSelection = true;
        btnSetTimer.isEnabled = false
        setGradient()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        cell.imageView.image = imageItems[indexPath.row]
        cell.imageView.isUserInteractionEnabled = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedItem : String = items[indexPath.row]
        if  imageItems[indexPath.row] == UIImage(named: items[indexPath.row])! {
            imageItems[indexPath.row] = UIImage(named: items[indexPath.row]+"_onclick")!
            playSound(soundName: selectedItem)
//            print("selected "+selectedItem)
//            print(indexPath.row)
            selectedArray.append(items[indexPath.row])
            selectedIndex.append(indexPath.row)
//            print("select \(selectedIndex)")
            
        } else {
            imageItems[indexPath.row] = UIImage(named: items[indexPath.row])!
            
            if let currentIndex = selectedArray.firstIndex(where: {$0 == items[indexPath.row]}) {
                
                audioPlayerArray[currentIndex].stop()
                audioPlayerArray.remove(at: currentIndex)
                selectedArray.remove(at: currentIndex)
                selectedIndex.remove(at: currentIndex)
//                print("deselect \(selectedIndex)")
            }
        }
        if selectedArray == [] {
            btnSetTimer.isEnabled = false
        } else {
            btnSetTimer.isEnabled = true
        }
        
        
        print(selectedArray)
        collectionView.reloadData()
    }
    
    func playSound(soundName: String){
        
        do {
            if let soundURL = Bundle.main.path(forResource: soundName, ofType: "mp3") {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundURL))
                audioPlayerArray.append(audioPlayer)
            } else {
                print("No file with specified name exists")
            }
        } catch let error {
            print("Can't play the audio file failed with an error \(error.localizedDescription)")
        }
        
        audioPlayer.numberOfLoops = -1
        audioPlayer.play()
        
        print(audioPlayerArray)
    }
    
    
    @IBAction func pressOnTimer(_ sender: Any) {
        if isRunning == true {
            timer.invalidate()
            btnSetTimer.setTitle("Set Timer", for: .normal)
            isRunning = false
        } else {
            let timerAlert = UIAlertController(title: "Timer", message: "\n\n\n", preferredStyle: .actionSheet)
            timerAlert.view.backgroundColor = UIColor(red: 237/255, green: 239/255, blue: 242/255, alpha: 0.1)
            timerAlert.view.layer.cornerRadius = timerAlert.view.frame.width/2
            timerAlert.view.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
            timerAlert.view.layer.borderWidth = 1/UIScreen.main.nativeScale
            
            let btnTimerDone = UIAlertAction(title: "Set Timer", style: .default, handler: pressOnTimerDone)
            timerAlert.addAction(btnTimerDone)
            
            timerSlider = UISlider(frame: CGRect(x: 34, y: 45, width: 280, height: 50))
            timerSlider.minimumValue = 0
            timerSlider.maximumValue = 120
            timerSlider.setThumbImage(UIImage(named: "timer"), for: .normal)
            timerSlider.tintColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
            timerSlider.addTarget(self, action: #selector(sliderInAction(sender:)), for: .valueChanged)
            timerSlider.isContinuous = true
            timerSlider.value = 60
            timerAlert.view.addSubview(timerSlider)
            
            let leftValue = UILabel(frame: CGRect(x: 10, y: 45, width: 20, height: 50))
            leftValue.text = "0"
            leftValue.font = UIFont.boldSystemFont(ofSize: 20)
            leftValue.textColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
            timerAlert.view.addSubview(leftValue)
            
            let rightValue = UILabel(frame: CGRect(x: 316, y: 45, width: 40, height: 50))
            rightValue.text = "120"
            rightValue.font = UIFont.boldSystemFont(ofSize: 20)
            rightValue.textColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
            timerAlert.view.addSubview(rightValue)
            
            self.present(timerAlert, animated: true) {
                let tapOutside = UITapGestureRecognizer(target: self, action: #selector(self.dismissTimerAlert))
                timerAlert.view.superview?.subviews[0].addGestureRecognizer(tapOutside)
            }
            
            valueOfSlider = UILabel(frame: CGRect(x: 0, y: 75, width: 350, height: 50))
            valueOfSlider.textColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1)
            valueOfSlider.textAlignment = .center
            valueOfSlider.font = UIFont.boldSystemFont(ofSize: 20)
            timerAlert.view.addSubview(valueOfSlider)
            valueOfSlider.text = "60"
        }
//        let btnTimerDone = UIButton(frame: CGRect(x: 0, y: 110, width: 360, height: 50))
//        btnTimerDone.layer.borderWidth = 1/UIScreen.main.nativeScale
//        btnTimerDone.contentEdgeInsets = UIEdgeInsets(top: 3.5, left: 43, bottom: 3.5, right: 43)
//        btnTimerDone.titleLabel?.adjustsFontSizeToFitWidth = true
//        btnTimerDone.titleLabel?.adjustsFontForContentSizeCategory = true
//        btnTimerDone.backgroundColor = .black
//        btnTimerDone.layer.cornerRadius = 25
//        btnTimerDone.layer.borderColor = UIColor(red: 237/255, green: 239/255, blue: 242/255, alpha: 1).cgColor
//        btnTimerDone.setTitle("Set Timer", for: .normal)
//        timerAlert.view.addSubview(btnTimerDone)
        
    }
    @IBAction func pressOnFavorites(_ sender: Any) {
    }
    
    @IBAction func pressOnRandom(_ sender: Any) {
    }
    
    @objc func sliderInAction(sender: UISlider){
        valueOfSlider.text = String(Int(sender.value))
    }
    
    @objc func dismissTimerAlert() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func pressOnTimerDone(timerAlert:UIAlertAction!){
        countTimer = Int(valueOfSlider.text!)!
        if countTimer > 0 {
            if countTimer == 1 {
                btnSetTimer.setTitle("Turn off sound after \(countTimer!) minute", for: .normal)
            } else {
                btnSetTimer.setTitle("Turn off sound after \(countTimer!) minutes", for: .normal)
            }
            
//            let deadlineTime = DispatchTime.now() + .seconds(countTimer!)
//            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
//                self.turnOff()
//            }
            timerRunning()


        }
        print(valueOfSlider.text!)
        
        
        
    }
    
    func timerRunning(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        isRunning = true
    }
    
    @objc func updateTimer(){
        countTimer -= 1
        if countTimer == 0{
            timer.invalidate()
            self.turnOff()
            isRunning = false
        } else if countTimer == 1 {
            btnSetTimer.setTitle("Turn off sound after \(countTimer!) minute", for: .normal)
        } else {
            btnSetTimer.setTitle("Turn off sound after \(countTimer!) minutes", for: .normal)
        }
        
        print(countTimer!)
        
    }
    
    func turnOff(){
        audioPlayerArray.forEach{ audioPlaying in
            audioPlaying.stop()
        }
        
        selectedIndex.forEach{ indexItem in
            imageItems[indexItem] = UIImage(named: items[indexItem])!
        }
        selectedIndex.removeAll()
        selectedArray.removeAll()
        audioPlayerArray.removeAll()
        collectionView.reloadData()
        btnSetTimer.setTitle("Set Timer", for: .normal)
    }
}

extension UIViewController {
    func setGradient(){
        let pastelView = PastelView(frame: view.bounds)

//        // Custom Direction
//        pastelView.startPastelPoint = .bottomRight
//        pastelView.endPastelPoint = .topLeft
//
        // Custom Duration
        pastelView.animationDuration = 20.0
        
        // Custom Color
        pastelView.setColors([UIColor(red: 19/255, green: 78/255, blue: 94/255, alpha: 1.0),
                              UIColor(red: 13/255, green: 178/255, blue: 128/255, alpha: 1.0),
                              UIColor(red: 117/255, green: 58/255, blue: 136/255, alpha: 1.0),
                              UIColor(red: 204/255, green: 43/255, blue: 94/255, alpha: 1.0)])

        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
    }
}
class CustomSlider: UISlider {
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: 5.0))
        super.trackRect(forBounds: customBounds)
        return customBounds
    }
    
}
