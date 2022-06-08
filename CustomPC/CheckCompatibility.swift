//
//  CheckCompatibility.swift
//  CustomPC
//
//  Created by Kai on 2022/06/05.
//

import Foundation

class CheckCompatibility {
    
    static func compatibilityCpuMotherboard(cpu: PcParts, motherboard:PcParts) -> Bool {
        let cpuMaker = cpu.maker
        let chipset = motherboard.specs[0]
        
        if ((cpuMaker != "[インテル]" && chipset.contains("INTEL")) || (cpuMaker != "[AMD]" && chipset.contains("AMD"))) {
            // 対応するチップセットとCUPメーカーが一致しない場合
            return false
        }
        
        let cpuSocket = cpu.specs[1].replacingOccurrences(of: "ソケット形状 ", with: "")
        let motherboardSocket = motherboard.specs[1].replacingOccurrences(of: "CPUソケット", with: "")
        
        if (cpuSocket != motherboardSocket) {
            // CPUソケットが一致しない場合
            return false
        }
        //let generation = cpu.specs[1].replacingOccurrences(of: "世代", with: "").replacingOccurrences(of: "第", with: "")
        return true
    }
    
//    static func compatibilityChipsetForIntel(generation:String, chipset:String) -> Bool{
//        let cs = chipset.replacingOccurrences(of: "チップセットINTEL", with: "")
//        let chipsetGen = cs.index(cs.startIndex, offsetBy: 1)
//        print(cs[chipsetGen])
//        return false
//    }
    
    static func compatibilityCpucoolerMotherboard(cpuCooler: PcParts, motherBoard: PcParts) -> Bool{
        let motherBoardSocket = motherBoard.specs[0]
        if (motherBoardSocket.contains("INTEL")){
            let motherSocket = motherBoardSocket.replacingOccurrences(of: "CPUソケット", with: "")
            let combineIntelSocket = cpuCooler.specs[0].replacingOccurrences(of: "Intel対応ソケットLGA ", with: "").replacingOccurrences(of: "LGA ", with: "/")
            let sockets = combineIntelSocket.split(separator: "/")
            
            for sc in sockets {
                let coolerSockets = "LGA" + sc
                if (coolerSockets == motherSocket) { return true }
            }
        }
        
        if(motherBoardSocket.contains("AMD")){
            let motherSocket = motherBoardSocket.replacingOccurrences(of: "CPUソケットSocket", with: "")
            let combineIntelSocket = cpuCooler.specs[0].replacingOccurrences(of: "AMD対応ソケットLGA ", with: "")
            let sockets = combineIntelSocket.split(separator: "/")
            
            for sc in sockets {
                if (sc == motherSocket && !motherSocket.contains("/")) { return true }
                
                let motherSockets = motherSocket.split(separator: "/")
                for ms in motherSockets {
                    if (ms == sc) {
                        return true
                    }
                }
            }
        }
        return false
    }
}
