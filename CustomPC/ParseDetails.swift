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
    
    static func getEnlargedImages(detailUrl: String) -> Void{
        let imageViewUrl = detailUrl.replacingOccurrences(of: "?lid=pc_ksearch_kakakuitem", with: "") + "images/"
        
        AF.request(imageViewUrl).responseString (encoding: String.Encoding.shiftJIS){ response in
            if let html = response.value {
                if let doc = try? HTML(html: html, encoding: String.Encoding.utf8) {
                    var imageUrls = [URL]()
                    for node in doc.css("img[data-src]") {
                        if let strUrl = node["data-src"]{
                            if (strUrl.contains("https://img1.kakaku.k-img.com/images/productimage/fullscale/")){
                                imageUrls.append(URL(string: strUrl)!)
                            }
                        }
                    }
                }
            }
        }
        
    }
}
