//
//  ViewController.swift
//  Metronome
//
//  Created by Ilya Tereshkin on 23.06.2021.
//

import UIKit
import AVFoundation

class MainController: UIViewController {
    
    //private var player: AVAudioPlayer
    private let metronomeLogic = MetronomeLogic()
    @IBOutlet weak var tempoLabel: UILabel!
    @IBOutlet var minusTenTempoBtn: TempoBtns!
    @IBOutlet var minusOneTempoBtn: TempoBtns!
    @IBOutlet var plusOneTempoBtn: TempoBtns!
    @IBOutlet var plusTenTempoBtn: TempoBtns!
    @IBOutlet var sizeBtn: UIButton!
    @IBOutlet var size_2Btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tempoLabel.text = String(metronomeLogic.INIT_TEMPO)
        initController ()
        setupGestures()
    }
    
    private func initController ()
    {
        minusTenTempoBtn.tempo = -10
        minusOneTempoBtn.tempo = -1
        plusOneTempoBtn.tempo = 1
        plusTenTempoBtn.tempo = 10
    }
    
    func setupGestures ()
    {
        let tap_1 = MyTapGesture(target: self, action: #selector(changeSize))
        tap_1.numberOfTapsRequired = 1
        tap_1.strParam = "FirstSize"
        sizeBtn.addGestureRecognizer(tap_1)
        
        let tap_2 = MyTapGesture(target: self, action: #selector(changeSize))
        tap_2.numberOfTapsRequired = 1
        tap_2.strParam = "SecondSize"
        size_2Btn.addGestureRecognizer(tap_2)
    }
    
    @objc
    func changeSize(sender : MyTapGesture)
    {
        guard let sizeVC = storyboard?.instantiateViewController(identifier: "sizeVC") else {
            print("Error, can't create sizeVC")
            return
        }
        print("Sender = \(sender.strParam)")
        
        let sizeVC_Casted = (sizeVC as! SizeViewController)
        sizeVC_Casted.modalPresentationStyle = .custom
        sizeVC_Casted.modalTransitionStyle = .crossDissolve
        sizeVC_Casted.preferredContentSize = CGSize(width: 250, height: 250)
        sizeVC_Casted.metronomeLogic = metronomeLogic
        
        switch sender.strParam {
        case "FirstSize":
            sizeVC_Casted.activeData = DataContainer.Instance.sizeData_1
            break
        case "SecondSize":
            sizeVC_Casted.activeData = DataContainer.Instance.sizeData_2
            break
        default:
            sizeVC_Casted.activeData = DataContainer.Instance.sizeData_1
        }
        
        self.present(sizeVC, animated: true)
    }
    
    private func updateTempoView ()
    {
        tempoLabel.text = String(metronomeLogic.beepTime)
    }
    
    @IBAction func onStartBtnPress(_ sender: UIButton)
    {
        metronomeLogic.startMetronomeHandler()
    }
    
    @IBAction func onTempoBtnPress(_ sender: TempoBtns) {
        metronomeLogic.beepTime += sender.tempo
        updateTempoView ()
    }
}
