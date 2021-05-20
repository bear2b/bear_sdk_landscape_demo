//
//  ViewController.swift
//  BearSDK Landscape
//
//  Created by Vladimir Nitochkin on 19.05.2021.
//

import BearSDK
import UIKit

class ViewController: UIViewController {
    
    lazy var ar = (UIApplication.shared.delegate as! AppDelegate).arController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ar.delegate = self
    }
    
    @IBAction func scanTapped(_ sender: Any) {
        switch ar.handler.viewState {
        case .idle:
            ar.handler.startScanning()
        case .scanning:
            ar.handler.stopScanning()
        default:
            return
        }
    }
}

extension ViewController: ARDelegate {
    func recognizedMarker(withId markerId: Int, assetIds: [Int]) {
        print("called \(#function)")
    }
    
    func recognitionTimeoutReached() {
        print("called \(#function)")
    }

    func assetClicked(with assetId: Int) {
        print("called \(#function)")
    }
    
    func viewStateChanged(_ state: ARViewState) {
        print("called \(#function), state - \(state.rawValue)")
    }
    
    func didFail(withError error: BearError) {
        print("called \(#function)")
    }
}

