//
//  PCParts.swift
//  CustomPC
//
//  Created by Kai on 2022/04/13.
//

import Foundation

enum PcParts: String {
    case cpu = "CPU"
    case cpuCooler = "CPUクーラー"
    case memory = "メモリー"
    case graphicsCard = "グラフィックボード・ビデオカード"
    case ssd = "SSD"
    case hdd = "ハードディスク・HDD"
    case pcCase = "PCケース"
    case powerUnit = "電源ユニット"
    case caseFan = "ケースファン"
    case monitor = "PCモニター・液晶ディスプレイ"
    
    func startPageUrl() -> String{
        switch self {
        case .cpu:
            return "https://kakaku.com/search_results/cpu/"
        case .cpuCooler:
            return "https://kakaku.com/search_results/cpu%83N%81%5B%83%89%81%5B/"
        case .memory:
            return "https://kakaku.com/search_results/ddr4%83%81%83%82%83%8A/"
        case .graphicsCard:
            return "https://kakaku.com/search_results/%83O%83%89%83b%83t%83B%83b%83N%83%7B%81%5B%83h/"
        case .ssd:
            return "https://kakaku.com/search_results/SSD/"
        case .hdd:
            return "https://kakaku.com/search_results/hdd/"
        case .pcCase:
            return "https://kakaku.com/search_results/pc%83P%81%5B%83X/"
        case .powerUnit:
            return "https://kakaku.com/search_results/%93d%8C%B9%83%86%83j%83b%83g/"
        case .caseFan:
            return "https://kakaku.com/search_results/%93d%8C%B9%83%86%83j%83b%83g/"
        case .monitor:
            return "https://kakaku.com/search_results/%83%82%83j%83%5E%81%5B/"
        }
    }
}
