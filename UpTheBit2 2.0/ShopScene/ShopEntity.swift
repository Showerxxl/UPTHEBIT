
import Foundation

struct ShopItem {
    static var selectedSection: Int = 1
}

struct BoxItem {
    let price: Double
    var isBought: Bool
    let characteristic: Int
}

struct ShopEntity {

    var boxListWeapon: [BoxItem]
    var boxListArmor: [BoxItem]
    var boxListCash: [BoxItem]
    
    init() {
        let weaponCharacteristics = [2, 5, 8, 13]
        let armorCharacteristics = [7, 10, 15, 20]
        let cashCharacteristics = [2, 3, 4, 5]
        let prices = [10.0, 10.0, 15.0, 20.0]
        
        boxListWeapon = prices.enumerated().map { (index, price) in
            let isBought = UserDefaults.standard.bool(forKey: "boxButton_1_\(index)_isBought")
            let characteristic = weaponCharacteristics[index]
            return BoxItem(price: price, isBought: isBought, characteristic: characteristic)
        }
        
        boxListArmor = prices.enumerated().map { (index, price) in
            let isBought = UserDefaults.standard.bool(forKey: "boxButton_2_\(index)_isBought")
            let characteristic = armorCharacteristics[index]
            return BoxItem(price: price, isBought: isBought, characteristic: characteristic)
        }
        
        boxListCash = prices.enumerated().map { (index, price) in
            let isBought = UserDefaults.standard.bool(forKey: "boxButton_3_\(index)_isBought")
            let characteristic = cashCharacteristics[index]
            return BoxItem(price: price, isBought: isBought, characteristic: characteristic)
        }
    }
}
