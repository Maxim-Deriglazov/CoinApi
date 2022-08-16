//
//  ViewController.swift
//  coinApi
//
//  Created by Max on 18.07.2022.
//

import UIKit

class ViewController: UIViewController {
    
    var response: IpResponse?
    var exchangerate: Exchangerate?
    var rateString: Float?
    
    @IBOutlet weak var onOfSegmContr: UISegmentedControl?
    @IBOutlet weak var onOfSwith: UISwitch?
    @IBOutlet weak var assetIdBase: UILabel?
    @IBOutlet weak var timeLabel: UILabel?
    @IBOutlet weak var assetIdQuoteLabel: UILabel?
    @IBOutlet weak var rateLabel: UILabel?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
//API Key: E4D428BB-7AC9-48F9-803D-54F06CD02393

    @IBAction func getResponse(_ sender: UIButton) {
        makeRequest()
    }
    
    func makeRequest() {
     //   curl https://rest.coinapi.io/v1/exchangerate/BTC?invert=false \
      //    --request GET
      //    --header "X-CoinAPI-Key: 73034021-THIS-IS-SAMPLE-KEY"
        
        let swichPos = onOfSwith?.isOn == true ? "UAH" : "USD"
 
        let selectedIndex = onOfSegmContr?.selectedSegmentIndex
        var segmContrPos = "BTC/"
//        switch selectedIndex {
//        case <#pattern#>:
//            <#code#>
//        default:
//            <#code#>
//        }
        if selectedIndex == 0 {
            segmContrPos = "BTC/"
        }
        else if selectedIndex == 1 {
            segmContrPos = "ETH/"
        }
        else if selectedIndex == 2 {
            segmContrPos = "BCH/"
        }
//        guard let url = URL(string: "https://rest.coinapi.io/v1/exchangerate/BTC?invert=false") else { return }
        guard let url = URL(string: "https://rest.coinapi.io/v1/exchangerate/" + segmContrPos + swichPos) else { return }
        //curl https://rest.coinapi.io/v1/exchangerate/BTC/USD
//        activity?.startAnimating()
            
        var request = URLRequest(url: url)// создание запроса с параметрами
        request.httpMethod = "GET"// параметр (метод запроса)

        request.allHTTPHeaderFields = ["X-CoinAPI-Key" : "E4D428BB-7AC9-48F9-803D-54F06CD02393"]// хедер - в любой тип запроса можно использова. Конкретно тыт это ключ авторизации, необходимый сервесу,который используем
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in// ответ от сервера (data - инфа по ответу, response - общая инфа по состоянию ответа, error - еслиесть ошибка)
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase//позволяет использовать переменные нормального вида, а не такие как просит Джейсон Напримар assetIdQuote а не asset_id_quote
//            decoder.dateDecodingStrategy = .iso8601
            let dictionary = try? decoder.decode(Exchangerate.self, from: data)// дакодируем в джейсон словарь [String:String]
           
            self?.exchangerate = dictionary
            DispatchQueue.main.async {// переходим в основной поток (до этого все обрабатывалось не в основном, а юай рисуется только в основном)
//                self?.assetIdBase?.text = dictionary?.assetIdBase
//                self?.timeLabel?.text = dictionary?.rates.first?.time
//                self?.assetIdQuoteLabel?.text = dictionary?.rates.first?.assetIdQuote
//                self?.rateString = dictionary?.rates.first?.rate
//                guard let rateString = self?.rateString else { return }
//                self?.rateLabel?.text = String(format: "%.3f", Double(rateString))
                self?.assetIdBase?.text = dictionary?.assetIdBase
                self?.timeLabel?.text = dictionary?.time
                self?.assetIdQuoteLabel?.text = dictionary?.assetIdQuote
                self?.rateString = dictionary?.rate
                guard let rateString = self?.rateString else { return }
                self?.rateLabel?.text = String(format: "%.3f", Double(rateString))
            }
        }
            task.resume()// запускаем созданную, описанную таску
    }
    
}

struct arrRates: Codable {
    var time: String
    var assetIdQuote: String
    var rate: Float
    
//    var date: Date? {
//        var str = time
//        if let range = time.range(of: ".") {
//            str = (time as NSString).substring(to: (time as NSString).range(of: ".").location)
//            str += "Z"
//        }
//        //"2022-07-19T10:01:11.0000000Z"
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZZZZ"
//        //        formatter.dateFormat = "yyyy-mm-ddThh:mm:ssZ"
//        return formatter.date(from: str)
//    }
    
    /*
     enum CodingKeys: String, CodingKey {
         case firstName = "user_first_name"
         case lastName = "user_last_name"
         case age
     }     */
}
struct IpResponse: Codable {
    var assetIdBase: String
    var rates: [arrRates]
}

struct Exchangerate: Codable {
    var time: String
    var assetIdBase: String
    var assetIdQuote: String
    var rate: Float
}
