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
    // SearchPartsViewController遷移時(未検索時)の情報取得
    static func searchParts(selectedCategory: category, searchURL:String, completionHandler: @escaping (Array<PcParts>) -> Void) {
        // alamofile encodingの引数にshiftJisを指定して文字化け回避
        AF.request(searchURL).responseString (encoding: String.Encoding.shiftJIS){ response in
            if let html = response.value {
                if let doc = try? HTML(html: html, encoding: String.Encoding.utf8) {
                    var goods = [Goods]()
                    var goodsPath = 4 // 画像付き広告がない場合の商品のdivタグの位置
                    // 画像のurl全取得
                    var imageUrls = [URL]()
                    for node in doc.css("img[data-src]") {
                        if let strUrl = node["data-src"] {
                            imageUrls.append(URL(string: strUrl)!)
                        }
                    }
                    
                    var detailUrls = [String]()
                    for node in doc.css("a[href]") {
                        if let strUrl = node["href"] {
                            let standerd = "https://kakaku.com/item/"
                            let redirect = "https://kakaku.com/ksearch/redirect/"
                            if ( (strUrl.contains(standerd) || strUrl.contains(redirect)) && !detailUrls.contains(strUrl)){
                                detailUrls.append(strUrl)
                            }
                        }
                    }
                    
                    if (detectAd(doc: doc)) {
                        imageUrls.removeSubrange(0 ... 9)
                        detailUrls.removeSubrange(0 ... 9)
                        goodsPath = 5
                    }
                    
                    var adaptItr = 0
                    // ページのパーツ数取得
                    let elements: Int = doc.xpath("//*[@id='default']/div[2]/div[2]/div/div[4]/div/div").count
                    // 商品のタイトル、メーカー、値段の情報を取得し、画像と一緒にGoodsクラスとしてインスタンス化
                    for i in 1 ... (elements) {
                        
                        let arraysIterator = i - 1 // 画像と詳細URLの配列imageUrlsの添字用の変数
                        let categoryXPath = "//*[@id=\"default\"]/div[2]/div[2]/div/div[\(goodsPath)]/div/div[\(i)]/div/div[1]/div[1]/div/div[1]/p[1]"
                        let makerXPath = "//*[@id=\"default\"]/div[2]/div[2]/div/div[\(goodsPath)]/div/div[\(i)]/div/div[1]/div[1]/div/p[1]"
                        let titleXPath = "//*[@id=\"default\"]/div[2]/div[2]/div/div[\(goodsPath)]/div/div[\(i)]/div/div[1]/div[1]/div/p[2]"
                        let priceXPath = "//*[@id=\"default\"]/div[2]/div[2]/div/div[\(goodsPath)]/div/div[\(i)]/div/div[2]/div/p[1]/span"
                        
                        var maker :String
                        var title :String
                        var price :String
                        var category :String
                        
                        for ctg in doc.xpath(categoryXPath) {
                            category = ctg.text ?? "fault"
                            
                            for mk in doc.xpath(makerXPath) {
                                maker = mk.text ?? "fault"
                                
                                for ti in doc.xpath(titleXPath){
                                    title = ti.text ?? "fault"
                                    
                                    for pr in doc.xpath(priceXPath) {
                                        price = pr.text ?? "fault"
                                        
                                        if (title.contains("[PR企画]")){
                                            adaptItr += 1
                                            continue
                                        }
                                        
                                        let gds = Goods(title: title, price: price, maker: maker, category: category, image: imageUrls[arraysIterator - adaptItr], detail: detailUrls[arraysIterator - adaptItr])
                                        goods.append(gds)
                                    }
                                }
                            }
                        }
                    }
                    // Goodsクラスのカテゴリと選択されたカテゴリを比較 整合する場合PcPartsクラスとしてインスタンス化
                    var partsSeq = exceptOtherCategory(category: selectedCategory, goods: goods)
                    partsSeq = exceptOutsideDetailPage(parts: partsSeq)
                    completionHandler(partsSeq)
                }
            }
        }
    }
    
    static func searchPartsWithSearchBar(selectedCategory: category, word: String, completionHandler: @escaping (Array<PcParts>) -> Void) {
        let addCategoryPhrase = selectedCategory.rawValue + " " + word
        let encoded = addCategoryPhrase.sjisPercentEncoded
        let urlString = "https://kakaku.com/search_results/\(encoded)/"
        print(urlString)
        searchParts(selectedCategory: selectedCategory, searchURL: urlString) { parts in
            completionHandler(parts)
        }
    }
    
    // 選択されたカテゴリ(CPU,SSD等)と取得した商品のカテゴリ名の比較と照合する
    static func exceptOtherCategory(category:category, goods:Array<Goods>) -> Array<PcParts> {
        var partsSeq = [PcParts]()
        for gds in goods {
            if (gds.category.contains("ハードディスク") && gds.category.contains(category.rawValue)){ // 照合部分
                let pcparts = PcParts(category: category, maker: gds.maker, title: gds.title, price: gds.price, image: gds.image, detail: gds.detail)
                partsSeq.append(pcparts)
            }else if (gds.category == category.rawValue) {
                let pcparts = PcParts(category: category, maker: gds.maker, title: gds.title, price: gds.price, image: gds.image, detail: gds.detail)
                partsSeq.append(pcparts)
            }
        }
        return partsSeq
    }
    
    static func detectAd(doc:HTMLDocument) -> Bool {
        var ads = [String]()
        for link in doc.xpath("//div[@class='p-sponsorShop2']") {
            ads.append(link.text ?? "")
        }
        
        if (ads.count == 1){
            return true
        }else{
            return false
        }
    }
    
    static func exceptOutsideDetailPage(parts: Array<PcParts>)-> Array<PcParts>{
        var partsSeq = [PcParts]()
        
        for pts in parts {
            if (pts.detailUrl.contains("https://kakaku.com/item/")){
                partsSeq.append(pts)
            }
        }
        return partsSeq
    }
}

class Goods {
    let title:String
    let price:String
    let maker:String
    let category: String
    let image:URL
    let detail:String
    
    init(title:String, price:String, maker:String, category:String, image:URL, detail:String) {
        self.title = title
        self.price = price
        self.maker = maker
        self.category = category
        self.image = image
        self.detail = detail
    }
}
