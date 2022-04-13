//
//  SearchParts.swift
//  CustomPC
//
//  Created by Kai on 2022/04/10.
//

import Foundation

import Alamofire
import Kanna

class SearchParts {
    static func getPartsTitleFirst(completionHandler: @escaping (Array<String>) -> Void) {
        AF.request("https://kakaku.com/search_results/%83O%83%89%83b%83t%83B%83b%83N%83%7B%81%5B%83h/?category=0001%2C0028").responseString { response in
            if let html = response.value {
                if let doc = try? HTML(html: html, encoding: .utf8) {
                    var titles = [String]()
                    let elements: Int = doc.xpath("//*[@id=\"default\"]/div[2]/div[2]/div/div[5]/div/div").count
                    for i in 1 ... (elements) {
                        let title = "//*[@id=\"default\"]/div[2]/div[2]/div/div[5]/div/div[\(i)]/div/div[1]/div[1]/div/p[2]"
                        for link in doc.xpath(title) {
                            titles.append(link.text ?? "")
//                            if let text = link.text {
//                                titles.append(link.text!)
//                            }
                        }
                    }
                    completionHandler(titles)
                }
            }
        }
    }
}
