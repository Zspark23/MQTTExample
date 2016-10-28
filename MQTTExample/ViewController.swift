//
//  ViewController.swift
//  MQTTExample
//
//  Created by Zack Spicer on 10/28/16.
//  Copyright © 2016 Zack Spicer. All rights reserved.
//

import UIKit
import CocoaMQTT

class ViewController: UIViewController {

    var isSubscribed = false
    var isConnected = false
    var mqtt: CocoaMQTT!
    
    @IBOutlet weak var messageTextField: UITextView!
    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var hostNameTextField: UITextField!
    @IBOutlet weak var portNumberTextField: UITextField!
    @IBOutlet weak var topicNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeButton.isEnabled = false
    }
    
    @IBAction func subscribeButtonTapped(_ sender: UIButton) {
        if isSubscribed == false {
            mqtt.subscribe(topicNameTextField.text!)
            isSubscribed = true
            topicNameTextField.isEnabled = false
            subscribeButton.setTitle("Unsubscribe", for: .normal)
        } else {
            mqtt.unsubscribe(topicNameTextField.text!)
            isSubscribed = false
            topicNameTextField.isEnabled = true
            subscribeButton.setTitle("Subscribe", for: .normal)
        }
    }
    
    @IBAction func conectButtonTapped(_ sender: UIButton) {
        if isConnected == false {
            mqtt = CocoaMQTT(clientId: "CocoaMQTT-" + String(ProcessInfo().processIdentifier), host: hostNameTextField.text!, port: UInt16(portNumberTextField.text!)!)
            mqtt.keepAlive = 90
            mqtt.delegate = self
            mqtt.connect()
            subscribeButton.isEnabled = true
            connectButton.setTitle("Disconnect", for: .normal)
            isConnected = true
        } else {
            mqtt.disconnect()
            subscribeButton.isEnabled = false
            connectButton.setTitle("Connect", for: .normal)
            isConnected = false
        }
    }
}

extension ViewController: CocoaMQTTDelegate {
    
    func mqtt(_ mqtt: CocoaMQTT, didConnect host: String, port: Int) {
        print("Connected to \(host):\(port)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        if let messageString = message.string {
            messageTextField.text = messageTextField.text + "\n" + messageString
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        print("Subscribed to \(topic)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print("Unsubscribed to \(topic)")
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print("")
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT){
        print("")
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        print("Disconnected")
    }
}

