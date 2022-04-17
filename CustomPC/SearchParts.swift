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
    static func getPartsTitleFirst(parts: category,completionHandler: @escaping (Array<PcParts>) -> Void) {
        // alamofile encodingの引数にshiftJisを指定して文字化け回避
        AF.request(parts.startPageUrl()).responseString (encoding: String.Encoding.shiftJIS){ response in
            if let html = response.value {
                if let doc = try? HTML(html: html, encoding: String.Encoding.utf8) {
                    var partsSeq = [PcParts]()
                    var images = [String]()
                    // ページのパーツ数取得
                    let elements: Int = doc.xpath("//*[@id=\"default\"]/div[2]/div[2]/div/div[4]/div/div").count
                    // 選択されたカテゴリ以外を除く
                    for i in 1 ... (elements) {
                        let category = "//*[@id=\"default\"]/div[2]/div[2]/div/div[4]/div/div[\(i)]/div/div[1]/div[1]/div/div[1]/p[1]"
                        for ctg in doc.xpath(category) {
                            if let text = ctg.text {
                                if (text.contains(parts.rawValue)){ // ここでカテゴリを制限
                                    // ここからメーカー、タイトル、値段取得
                                    let makerXPath = "//*[@id=\"default\"]/div[2]/div[2]/div/div[4]/div/div[\(i)]/div/div[1]/div[1]/div/p[1]"
                                    let titleXPath = "//*[@id=\"default\"]/div[2]/div[2]/div/div[4]/div/div[\(i)]/div/div[1]/div[1]/div/p[2]"
                                    let priceXPath = "//*[@id=\"default\"]/div[2]/div[2]/div/div[4]/div/div[\(i)]/div/div[2]/div/p[1]/span"
                                    
                                    var maker :String
                                    var title :String
                                    var price :String
                                    
                                    for mk in doc.xpath(makerXPath) {
                                        maker = mk.text ?? "fault"
                                        
                                        for ti in doc.xpath(titleXPath){
                                            title = ti.text ?? "fault"
                                            
                                            for pr in doc.xpath(priceXPath) {
                                                price = pr.text ?? "fault"
                                                // PcPartsクラスインスタンス化
                                                let pcparts = PcParts(category:parts, maker: maker, title: title, price: price)
                                                partsSeq.append(pcparts)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    print(images)
                    completionHandler(partsSeq)
                }
            }
        }
    }
}
