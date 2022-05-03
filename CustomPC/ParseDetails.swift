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
    
    static func getFullscaleImages(detailUrl: String, completionHandler: @escaping (URL) -> Void) -> Void{
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
                }
            }
        }
    }
    
    private static func fullscaleImage(detailUrl: String, completionHandler: @escaping (URL?) -> Void) -> Void{
        var url:URL?
        AF.request(detailUrl).responseString (encoding: String.Encoding.shiftJIS){ response in
            if let html = response.value {
                if let doc = try? HTML(html: html, encoding: String.Encoding.utf8) {
                    for node in doc.css("img[src]") {
                        if let strUrl = node["src"]{
                            if (strUrl.contains("https://img1.kakaku.k-img.com/images/productimage/fullscale/")){
                                url = URL(string: strUrl)!
                                print("a")
                                completionHandler(url)
                                return
                            }
                        }
                    }
                    completionHandler(url)
                }
            }
        }
    }
    
    static func getAllFullscaleImages(detailUrl: String, completionHandler: @escaping (URL) -> Void) -> Void {
        let imageViewUrl = detailUrl.replacingOccurrences(of: "?lid=pc_ksearch_kakakuitem", with: "") + "images/"
        var i = 0
        var varUrl = imageViewUrl
        while true{
            fullscaleImage(detailUrl: varUrl) { imageUrl in
                if let url = imageUrl {
                    completionHandler(url)
                }
            }
            
            if(i == 10){
                break
            }
            
            i += 1
            varUrl = imageViewUrl + "page=ka_\(i)/"
        }
    }
}
