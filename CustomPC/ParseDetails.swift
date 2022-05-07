//
//  ParseDetails.swift
//  CustomPC
//
//  Created by Kai on 2022/04/27.
//

import Foundation

import Alamofire
import Kanna


class ParseDetails {
    
    static func getFullscaleImages(detailUrl: String, completionHandler: @escaping (URL?) -> Void) -> Void{
        let imageViewUrl = detailUrl.replacingOccurrences(of: "?lid=pc_ksearch_kakakuitem", with: "") + "images/"
        AF.request(imageViewUrl).responseString (encoding: String.Encoding.shiftJIS){ response in
            if let html = response.value {
                if let doc = try? HTML(html: html, encoding: String.Encoding.utf8) {
                    for node in doc.css("img[src]") {
                        if let strUrl = node["src"]{
                            if (strUrl.contains("https://img1.kakaku.k-img.com/images/productimage/fullscale/")){
                                completionHandler(URL(string: strUrl)!)
                                return
                            }
                        }
                    }
                    completionHandler(nil)
                    return
                }
            }
        }
    }
    
    static func getSpec() -> Void{
        AF.request("https://kakaku.com/item/K0001374433/spec/?lid=spec_anchorlink_details#tab").responseString (encoding: String.Encoding.shiftJIS){ response in
            if let html = response.value {
                if let doc = try? HTML(html: html, encoding: String.Encoding.utf8) {
                    let elements = doc.xpath("//*[@id='default']/div[2]/div[2]/div/div[4]/div/div").count
                    
                    
                    // //*[@id="mainLeft"]/table/tbody/tr[2]/th[1]
                    var a = [String]()
                    let makerXPath = "//*[@id='mainLeft']/table"
                    
                    for unko in doc.xpath(makerXPath) {
                        let u = unko.text ?? "un"
                        a.append(u)
                    }
                    print(elements)
                    
                    print(a)
                    return
                }else{
                    print("")
                }
            }
        }
    }
}
