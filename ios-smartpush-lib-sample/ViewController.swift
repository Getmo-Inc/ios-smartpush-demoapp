//
//  ViewController.swift
//  ios-smartpush-sample
//
//  Created by Rodrigo Busata on 10/10/16.
//  Copyright © 2016 br.com.smartpush. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lbAliasId: UILabel!
    @IBOutlet weak var spinnerAliasId: UIActivityIndicatorView!
    @IBOutlet weak var lbRegisterId: UILabel!
    @IBOutlet weak var spinnerRegisterId: UIActivityIndicatorView!
    @IBOutlet weak var optionTag: UISegmentedControl!
    @IBOutlet weak var tfTagKey: UITextField!
    @IBOutlet weak var tfTagValue: UITextField!
    @IBOutlet weak var swRemoveTag: UISwitch!
    @IBOutlet weak var swBlockUser: UISwitch!
    @IBOutlet weak var tfLat: UITextField!
    @IBOutlet weak var tfLng: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Shadow on container view
        viewContainer.layer.shadowColor = UIColor.gray.cgColor
        viewContainer.layer.shadowOpacity = 1
        viewContainer.layer.shadowOffset = CGSize.zero
        viewContainer.layer.shadowRadius = 2
        viewContainer.layer.cornerRadius = 4
        
        viewContainer.isUserInteractionEnabled = false
        viewContainer.alpha = 0.5
        
        tfTagKey.delegate = self
        tfTagValue.delegate = self
        tfLat.delegate = self
        tfLng.delegate = self
        
        //Set TECNOPUC location
        tfLat.text = "-30.059047"
        tfLng.text = "-51.171546"
        
        
        //Add observer get device
        NotificationCenter.default.addObserver(self, selector: #selector(self.addedDevice), name: NSNotification.Name.SmartpushSDKDeviceAdded, object: nil)
        
        //Add observer get user info
        NotificationCenter.default.addObserver(self, selector: #selector(self.userInfo), name: NSNotification.Name.SmartpushSDKUserInfoObtained, object: nil)
        
        //Add observer block user
        NotificationCenter.default.addObserver(self, selector: #selector(self.blockUser), name: NSNotification.Name.SmartpushSDKBlockUser, object: nil)
    }
    
    func addedDevice(){
        self.lbAliasId.text = SmartpushSDK.sharedInstance().getDevice().alias
        self.spinnerAliasId.stopAnimating()
        self.viewContainer.alpha = 1
        self.viewContainer.isUserInteractionEnabled = true
        
        SmartpushSDK.sharedInstance().requestCurretUserInformation()
    }
    
    func userInfo(){
        if let regId = SmartpushSDK.sharedInstance().getUserInfo().regId{
            self.lbRegisterId.text = regId
            spinnerRegisterId.stopAnimating()
        }
    }
    
    func blockUser(){
        print("blockUser")
    }
    
    @IBAction func sendTag(_ sender: UIButton) {
        let key = tfTagKey.text
        let valueStr = tfTagValue.text
        let isAdd = !swRemoveTag.isOn
        
        switch optionTag.selectedSegmentIndex {
        case 0:
            if isAdd {
                SmartpushSDK.sharedInstance().setString(valueStr, forTag: key)
                
            } else {
                SmartpushSDK.sharedInstance().delStringTag(key)
            }
        case 1:
            if isAdd {
                guard let value = Double(valueStr ?? "") else {
                    showError()
                    return
                }
                SmartpushSDK.sharedInstance().setNumber(NSNumber(value: value), forTag: key)
            } else {
                SmartpushSDK.sharedInstance().delNumberTag(key)
            }
        case 2:
            if isAdd {
                if valueStr?.lowercased() != "true" && valueStr?.lowercased() != "false" {
                    showError()
                    return
                }
                SmartpushSDK.sharedInstance().setBool(valueStr?.lowercased() == "true", forTag: key)
                return
            } else {
                SmartpushSDK.sharedInstance().delBoolTag(key)
            }
        case 3:
            if isAdd {
                guard let value = Double(valueStr ?? "") else {
                    showError()
                    return
                }
                SmartpushSDK.sharedInstance().setDate(Date(timeIntervalSince1970: value), forTag: key)
            } else {
                SmartpushSDK.sharedInstance().delDateTag(key)
            }
        case 4:
            if isAdd {
                SmartpushSDK.sharedInstance().setArray([NSString(string: valueStr!), NSString(string: valueStr!)], forTag: key)
            } else {
                SmartpushSDK.sharedInstance().delArrayTag(key)
            }
        default:
            break
        }
    }
    
    @IBAction func sendBlockUser(_ sender: UIButton) {
        SmartpushSDK.sharedInstance().blockUser(swBlockUser.isOn)
        
    }
    
    @IBAction func sendLatLng(_ sender: UIButton) {
        guard let lat = Double(tfLat.text ?? "") else {
            showError()
            return
        }
        guard let lng = Double(tfLng.text ?? "") else {
            showError()
            return
        }
        SmartpushSDK.sharedInstance().nearestZone(withLatitude: lat, andLongitude: lng)
    }
    
    @IBAction func swRemoveTagChange(_ sender: UISwitch) {
        tfTagValue.isEnabled = !sender.isOn
    }
    
    private func showError(){
        UIAlertView(title: "Erro", message: "Valor inválido", delegate: nil, cancelButtonTitle: "OK").show()
    }
    
}

extension ViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

