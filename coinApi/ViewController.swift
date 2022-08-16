//
//  ViewController.swift
//  coinApi
//
//  Created by Max on 18.07.2022.
//

import UIKit

class ViewController: UIViewController {    
    
    let formatterApi = DateFormatter()
    let formatterLabel = DateFormatter()
    
    @IBOutlet weak var onOfSegmContr: UISegmentedControl?
    @IBOutlet weak var onOfSwith: UISwitch?
    @IBOutlet weak var nameCoinLabel: UILabel?
    @IBOutlet weak var assetIdBase: UILabel?
    @IBOutlet weak var timeConstLabel: UILabel?
    @IBOutlet weak var timeLabel: UILabel?
    @IBOutlet weak var assetIdQuoteLabel: UILabel?
    @IBOutlet weak var rateLabel: UILabel?
    @IBOutlet weak var errorView: UIView?
    @IBOutlet weak var errorLabel: UILabel?
    @IBOutlet weak var actInd: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        formatterApi.locale = Locale(identifier: "en_US_POSIX")
        formatterApi.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSZ"
        
        formatterLabel.dateFormat = "HH:mm, d MMM y"
    }

    @IBAction func getResponse(_ sender: UIButton) {
        
        actInd?.isHidden = false
        
        guard let positionSwith = onOfSwith?.isOn else { return }
        guard let selectedIndex = onOfSegmContr?.selectedSegmentIndex else { return }
        
        let coin = Coin(rawValue: selectedIndex) ?? .btc
        NetworkService.makeRequest(uahCurrency: positionSwith, coin: coin) { (error, rate) in
            if let error = error {
                self.actInd?.isHidden = true                
                self.errorView?.isHidden = false
                self.errorLabel?.isHidden = false
                self.errorLabel?.text = error.localizedDescription
            } else {
                self.actInd?.isHidden = true
                self.nameCoinLabel?.isHidden = false
                self.timeConstLabel?.isHidden = false
                self.updateUI(rate: rate)
            }
        }
    }
    
    func updateUI(rate: Exchangerate?) {
        
        let date = formatterApi.date(from: rate?.time ?? "")
        
        timeLabel?.text = formatterLabel.string(from: date ?? Date())
        
        assetIdBase?.text = rate?.assetIdBase
        assetIdQuoteLabel?.text = rate?.assetIdQuote
        
        if let rateFloat = rate?.rate {
            rateLabel?.text = String(format: "%.3f", Double(rateFloat))
        }
    }
}


