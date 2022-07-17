//
//  UpdateLatestPartsInfo.swift
//  CustomPC
//
//  Created by Kai on 2022/07/17.
//

import Foundation

class UpdateLatestPartsInfo {
    
    static func fetartsSpec(storedParts: [PcParts]) -> [PcParts]{
        var partsList:[PcParts] = []
        
        for (index, parts) in storedParts.enumerated() {
            let category = parts.category
            if category != .cpu && category != .motherBoard && category != .cpuCooler {
                partsList.append(parts)
                continue
            }
            
            ParseDetails.getSpec(detailUrl: parts.detailUrl)  { specs in
                switch category {
                case .cpu:
                    for spec in specs {
                        if (spec.contains("世代第")){
                            parts.specs.append(spec)
                        }
                        
                        if (spec.contains("ソケット形状")){
                            parts.specs.append(spec)
                        }
                    }
                    partsList[index] = parts
                    break
                case .cpuCooler:
                    for spec in specs {
                        if (spec.contains("Intel対応ソケット")){
                            parts.specs.append(spec)
                        }
                        
                        if (spec.contains("AMD対応ソケット")){
                            parts.specs.append(spec)
                        }
                    }
                    partsList[index] = parts
                    break
                case .motherBoard:
                    for spec in specs {
                        if (spec.contains("チップセット")){
                            parts.specs.append(spec)
                        }
                        
                        if (spec.contains("CPUソケット")){
                            parts.specs.append(spec)
                        }
                    }
                    partsList[index] = parts
                    break
                default :
                    break
                }
            }
        }
        return partsList
    }
    
    static func fetchPartsSpec(pcParts: [PcParts], index: Int, completionHandler: @escaping ([PcParts]) -> Void) -> Void {
        ParseDetails.getSpec(detailUrl: pcParts[index].detailUrl) { specs in
            if index == (pcParts.count - 1) {
                completionHandler(pcParts)
                return
            }
            
            if pcParts[index].category == .cpu {
                for spec in specs {
                    if spec.contains("世代第") {
                        pcParts[index].specs.append(spec)
                    }
                    
                    if spec.contains("ソケット形状") {
                        pcParts[index].specs.append(spec)
                    }
                }
            }
            
            if pcParts[index].category == .cpuCooler {
                for spec in specs {
                    if spec.contains("Intel対応ソケット") {
                        pcParts[index].specs.append(spec)
                    }
                    
                    if spec.contains("AMD対応ソケット") {
                        pcParts[index].specs.append(spec)
                    }
                }
            }
            
            if pcParts[index].category == .motherBoard {
                for spec in specs {
                    if spec.contains("チップセット") {
                        pcParts[index].specs.append(spec)
                    }
                    
                    if spec.contains("CPUソケット") {
                        pcParts[index].specs.append(spec)
                    }
                }
            }
            
            let nextIndex = index + 1
            self.fetchPartsSpec(pcParts: pcParts, index: nextIndex, completionHandler: completionHandler)
        }
    }
}
