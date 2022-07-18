//
//  CheckCompatibility.swift
//  CustomPC
//
//  Created by Kai on 2022/06/05.
//

import Foundation

class CheckCompatibility {
    
    static func isSelectedCpuMotherBoard(selected: [PcParts]) -> [PcParts]?{
        var cpu:PcParts?
        var motherboard:PcParts?
        
        for parts in selected {
            if parts.category.rawValue == "CPU" {
                cpu = parts
            }
            
            if parts.category.rawValue == "マザーボード" {
                motherboard = parts
            }
        }
        
        if let cpu = cpu, let motherboard = motherboard {
            let parts = [cpu, motherboard]
            return parts
        }
        return nil
    }
    
    static func isSelectedCpuCoolerMotherBoard(selected: [PcParts]) -> [PcParts]?{
        var cpuCooler:PcParts?
        var motherboard:PcParts?
        
        for parts in selected {
            if parts.category.rawValue == "CPUクーラー" {
                cpuCooler = parts
            }
            
            if parts.category.rawValue == "マザーボード" {
                motherboard = parts
            }
        }
        
        if let cpuCooler = cpuCooler, let motherboard = motherboard {
            let parts = [cpuCooler, motherboard]
            return parts
        }
        return nil
    }
    
    static func compatibilityMessage(cpuMother: Bool?, cpuCoolerMother : Bool?) -> String{
        var message = "選択されたパーツの互換性に問題ありません"
        if let cpuMother = cpuMother {
            if  !cpuMother {
                message = "選択されたパーツの互換性に問題があります"
                message += "\nCPUとマザーボードのソケット"
                
                if let cpuCoolerMother = cpuCoolerMother {
                    if !cpuCoolerMother {
                        message += "\nCPUクーラーとマザーボードのソケット"
                    }
                }
            }
        }else if let cpuCoolerMother = cpuCoolerMother {
            if !cpuCoolerMother {
                message = "選択されたパーツの互換性に問題があります"
                message += "\nCPUクーラーとマザーボードのソケット"
            }
        }
        return message
    }
    
    static func compatibilityCpuMotherboard(cpu: PcParts, motherboard:PcParts) -> Bool {
        let cpuMaker = cpu.maker
        let chipset = motherboard.specs[0]
        
        if ((cpuMaker != "[インテル]" && chipset.contains("INTEL")) || (cpuMaker != "[AMD]" && chipset.contains("AMD"))) {
            // 対応するチップセットとCUPメーカーが一致しない場合
            return false
        }
        
        let cpuSocket = cpu.specs[1].replacingOccurrences(of: "ソケット形状 ", with: "").replacingOccurrences(of: "Socket ", with: "")
        let motherboardSocket = motherboard.specs[1].replacingOccurrences(of: "CPUソケット", with: "").replacingOccurrences(of: "Socket", with: "")
        
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
            print("here")
            let motherSocket = motherBoard.specs[1].replacingOccurrences(of: "CPUソケット", with: "")
            let combineIntelSocket = cpuCooler.specs[0].replacingOccurrences(of: "Intel対応ソケットLGA ", with: "").replacingOccurrences(of: "LGA ", with: "/")
            let sockets = combineIntelSocket.split(separator: "/")
            
            for sc in sockets {
                let coolerSockets = "LGA" + sc
                if (coolerSockets == motherSocket) { return true }
            }
        }
        
        if(motherBoardSocket.contains("AMD")){
            let motherSocket = motherBoard.specs[1].replacingOccurrences(of: "CPUソケットSocket", with: "")
            if (cpuCooler.specs[1] == nil) { return false }
            let combineIntelSocket = cpuCooler.specs[1].replacingOccurrences(of: "AMD対応ソケット", with: "")
            let sockets = combineIntelSocket.split(separator: "/")
            for sc in sockets {
                 print(sc)
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
