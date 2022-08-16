//
//  NetworkService.swift
//  coinApi
//
//  Created by Max on 02.08.2022.
//

import Foundation
import UIKit

enum Coin: Int {
        
    case btc
    case eth
    case bch
    
    var string: String {
        var result: String
        switch self {
        case .btc:
            result = "BTC/"
        case .eth:
            result = "ETH/"
        case .bch:
            result = "BCH/"
        }
        return result
    }
}

class NetworkService: NSObject {
    
    static var apiKey = "E4D428BB-7AC9-48F9-803D-54F06CD02393"
    typealias ExchangeRateCompletion = (Error?, Exchangerate?)->Void
    
    static func makeRequest(uahCurrency: Bool, coin: Coin, completion: ExchangeRateCompletion?) {
        
        let positionSwith = uahCurrency ? "UAH" : "USD"

        guard let url = URL(string: "https://rest.coinapi.io/v1/exchangerate/" + coin.string + positionSwith) else {
            let error = NSError(domain: "my+app", code: 501, userInfo: [NSLocalizedDescriptionKey: "my error"])
            completion?(error, nil)
            return
        }
  
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["X-CoinAPI-Key" : apiKey]
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            var rate: Exchangerate?
            if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                rate = try? decoder.decode(Exchangerate.self, from: data)
            }
            
            
            DispatchQueue.main.async { completion?(error, rate) }
        }
        task.resume()
    }
}
