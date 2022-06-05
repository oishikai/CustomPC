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
    
    private static func getFullscaleImages(detailUrl: String, completionHandler: @escaping (URL?) -> Void) -> Void{
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
    
    static func getFullscaleImages(detailUrl :String, urls: [URL], completionHandler: @escaping ([URL]) -> Void) -> Void{
        ParseDetails.getFullscaleImages(detailUrl: detailUrl) { imageUrl in
            guard let url = imageUrl else{
                completionHandler(urls)
                return
            }
            
            var urlss = urls
            urlss.append(url)
            
            var nextUrl: String
            if detailUrl.contains("page=ka_") { // -> true
                nextUrl = detailUrl.replacingOccurrences(of: "page=ka_\(urlss.count - 1)/", with: "page=ka_\(urlss.count)/")
            }else{
                nextUrl = detailUrl + "page=ka_\(urlss.count)/"
            }
            //            var nextUrl = detailUrl.replacingOccurrences(of: "?lid=pc_ksearch_kakakuitem", with: "") + "images/"
            self.getFullscaleImages(detailUrl: nextUrl, urls: urlss, completionHandler: completionHandler)
        }
    }
    
    static func getSpec(detailUrl : String, completionHandler: @escaping ([String]) -> Void) -> Void{
        let specUrl = detailUrl.replacingOccurrences(of: "?lid=pc_ksearch_kakakuitem", with: "spec/#tab")
        AF.request(specUrl).responseString (encoding: String.Encoding.shiftJIS){ response in
            if let html = response.value {
                if let doc = try? HTML(html: html, encoding: String.Encoding.utf8) {
                    let makerXPath = "//*[@id='mainLeft']/table"
                    var except: [String] = []
                    if var spec = doc.xpath(makerXPath).first?.text {
                        spec = spec.replacingOccurrences(of: "\r\n\r\n\r\n", with: "?").replacingOccurrences(of: "\r\n", with: "?")
                        let specs = spec.split(separator: "?")
                        for spec in specs{
                            if (!spec.contains("　") && !spec.contains("  ")){
                                let str:String = String(spec)
                                except.append(str)
                            }
                        }
                        completionHandler(except)
                    }
                }
            }
        }
    }
    
    static func getPrices(detailUrl : String, completionHandler: @escaping ([String]) -> Void) -> Void{
        AF.request("https://kakaku.com/item/K0001385125/?lid=pc_ksearch_kakakuitem").responseString (encoding: String.Encoding.shiftJIS){ response in
            if let html = response.value {
                if let doc = try? HTML(html: html, encoding: String.Encoding.utf8) {
                    let makerXPath = "//*[@id='mainLeft']/table"
                    var except: [String] = []
                    if  var spec = doc.xpath(makerXPath).first?.text {
                        spec = spec.replacingOccurrences(of: "\r\n\r\n\r\n", with: "?").replacingOccurrences(of: "\r\n", with: "?")
                        let specs = spec.split(separator: "?")
                        print(specs)
                        var RankAndPrice :[String] = []
                        for (offset, spec) in specs.enumerated(){
                            if (spec.contains("位") && spec != "順位"){
                                RankAndPrice.append(String(specs[offset]))
                                RankAndPrice.append(String(specs[offset + 1]))
                                
                                var i = offset + 3
                                while(!specs[i].contains(")")){
                                    i += 1
                                }
                                RankAndPrice.append(String(specs[i - 1]))
                            }
                        }
                        completionHandler(RankAndPrice)
                    }
                }
            }
        }
    }
}
