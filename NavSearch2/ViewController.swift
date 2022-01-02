//
//  ViewController.swift
//  NavSearch2
//
//  Created by 신희준 on 2021/12/28.
//
import UIKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController {
    
    @IBOutlet weak var addressSearchBtn: UITextField!
    
    let NaverClientId = Bundle.main.object(forInfoDictionaryKey: "NaverClientId") as? String
    let NaverClientSecret = Bundle.main.object(forInfoDictionaryKey: "NaverClientSecret") as? String
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addressSearch(_ sender: Any) {
        
        naverSearchPlace()
        
    }
    
    
    func naverSearchPlace() {
          
          guard let searchText = addressSearchBtn.text else {
              return
          }
        let encodeAddress = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                
        let header1 = HTTPHeader(name: "X-Naver-Client-Id", value: "lJCZNY8owGgkwTVSp4Jp")
        let header2 = HTTPHeader(name: "X-Naver-Client-Secret", value: "g_D5PKCzsS")
        let headers = HTTPHeaders([header1,header2])
    
        AF.request("https://openapi.naver.com/v1/search/local.json?query=" + encodeAddress + "&display=5", method: .get,headers: headers).validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value as [String:Any]):
                    let json = JSON(value)
                    print(json)
                    let data = json["addresses"]
                    let lat = data[0]["mapy"]
                    let lon = data[0]["mapx"]
                    print("\(searchText)의 위도는 \(lat) 경도는 \(lon)")
                case .failure(let error):
                    print(error.errorDescription ?? "")
                default :
                    fatalError()
                }
            }
    }
}
