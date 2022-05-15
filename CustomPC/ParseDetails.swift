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
    
    static func getSpec(category : category) -> Void{
        AF.request("https://kakaku.com/item/K0001319993/spec/#tab").responseString (encoding: String.Encoding.shiftJIS){ response in
            if let html = response.value {
                if let doc = try? HTML(html: html, encoding: String.Encoding.utf8) {
                    for unko in doc.xpath("//*[@id=\"mainLeft\"]/div[1]") {
                        let u = unko.text ?? "un"
                        print(u)
                    }
                    
                    var a = [String]()
                    let makerXPath = "//*[@id='mainLeft']/table"
                    
                    for unko in doc.xpath(makerXPath) {
                        let u = unko.text ?? "un"
                        a.append(u)
                    }
                    var u = doc.xpath(makerXPath).first?.text
                    var spec = a[0]
                    spec = spec.replacingOccurrences(of: "\r\n\r\n\r\n", with: "?").replacingOccurrences(of: "\r\n", with: "?")
                    var specs = spec.split(separator: "?")
                    var except: [String.SubSequence] = []
                    for spec in specs{
                        if (!spec.contains("　") && !spec.contains("  ")){
                            except.append(spec)
                        }
                    }
                    print(except)
                    
                    
                    return
                }
            }
        }
    }
}
