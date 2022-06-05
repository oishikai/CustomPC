//
//  CheckCompatibility.swift
//  CustomPC
//
//  Created by Kai on 2022/06/05.
//

import Foundation

class CheckCompatibility {
    
    func compatibilityCpuMotherboard(cpu: PcParts, motherboard:PcParts) -> Bool {
        let cpuMaker = cpu.maker
        let chipset = motherboard.specs[0]
        
        if ((cpuMaker != "[インテル]" && chipset.contains("INTEL")) || (cpuMaker != "[AMD]" && chipset.contains("AMD"))) {
            // 対応するチップセットとCUPメーカーが一致しない場合
            return false
        }
        
        
        return false
    }
}
