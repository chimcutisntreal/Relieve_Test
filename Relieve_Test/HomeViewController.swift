//
//  HomeViewController.swift
//  Relieve_Test
//
//  Created by Chinh on 11/24/18.
//

import UIKit
import AVFoundation
import Pastel

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnSetTimer: RoundedButton!
    @IBOutlet weak var showTimer: UILabel!
    

    var audioPlayerArray = [AVAudioPlayer]()
    var audioPlayer : AVAudioPlayer!
    var selectedArray = [String]()
    let items = [ "cafe", "fan", "fire", "forest",
                  "night", "rain", "stream", "thunderstorm",
                  "train", "waterdrop", "waves", "wind", ]
    var imageItems : [UIImage] = [
        UIImage(named: "cafe")!, UIImage(named: "fan")!, UIImage(named: "fire")!,
        UIImage(named: "forest")!, UIImage(named: "night")!, UIImage(named: "rain")!,
        UIImage(named: "stream")!, UIImage(named: "thunderstorm")!, UIImage(named: "train")!,
        UIImage(named: "waterdrop")!, UIImage(named: "waves")!, UIImage(named: "wind")!,
    ]
    var arrSlider = [UISlider]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        collectionView.reloadData()
        collectionView.allowsMultipleSelection = true;
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
            print("selected "+selectedItem)
            print(indexPath.row)
            selectedArray.append(items[indexPath.row])
            
            
        } else {
            imageItems[indexPath.row] = UIImage(named: items[indexPath.row])!
            
            if let currentIndex = selectedArray.firstIndex(where: {$0 == items[indexPath.row]}) {
                
                audioPlayerArray[currentIndex].stop()
                audioPlayerArray.remove(at: currentIndex)
                selectedArray.remove(at: currentIndex)
                
            }
            print("deselected "+selectedItem)
        }
        
        //        print(audioPlayerArray)
        //        print(selectedArray)
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
        let Timer = storyboard?.instantiateViewController(withIdentifier: "Timer") as! TimerViewController
  
        self.present(Timer, animated: true, completion: nil)
    }
    @IBAction func pressOnFavorites(_ sender: Any) {
    }
    
    @IBAction func pressOnRandom(_ sender: Any) {
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
