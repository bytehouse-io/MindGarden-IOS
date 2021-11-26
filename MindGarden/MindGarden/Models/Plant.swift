//
//  Plant.swift
//  MindGarden
//
//  Created by Dante Kim on 7/27/21.
//
import SwiftUI


struct Plant: Hashable {
    let title: String
    let price: Int
    let selected: Bool
    let description: String
    let packetImage: Image
    let one: Image
    let two: Image
    let coverImage: Image
    let head: Image
    let badge: Image

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    static func == (lhs: Plant, rhs: Plant) -> Bool {
        return lhs.title == rhs.title
    }
    static var plants: [Plant] = [
        Plant(title: "White Daisy", price: 100, selected: false, description: "With their white petals and yellow centers, white daisies symbolize innocence and the other classic daisy traits, such as babies, motherhood, hope, and new beginnings.", packetImage: Img.daisyPacket, one: Img.daisy1, two: Img.daisy2, coverImage: Img.daisy3, head: Img.daisyHead, badge: Img.daisyBadge),
        Plant(title: "Red Tulip", price: 90, selected: false, description: "Red Tulips are a genus of spring-blooming perennial herbaceous bulbiferous geophytes. Red tulips symbolize eternal love, undying love, perfect love, true love.", packetImage: Img.redTulipsPacket, one: Img.redTulips1, two: Img.redTulips2,  coverImage: Img.redTulips3, head: Img.redTulipHead, badge: Img.redTulipsBadge),
        Plant(title: "Cactus", price: 130, selected: false, description: "Cactuses are type of desert plant that has thick, leafless stems covered in prickly spines or sharp spikes, some cacti are able to store hundreds of gallons of water. Cactus originates from the Greek name Kaktos.", packetImage: Img.cactusPacket, one: Img.cactus1, two: Img.cactus2, coverImage: Img.cactus3, head: Img.cactusHead, badge: Img.cactusBadge),
        Plant(title: "Blueberry", price: 150, selected: false, description: "Blueberries are a crown forming, woody, perennial shrub in the flower family Ericaceae. They ranked number one in antioxidant health benefits in a comparison with more than 40 fresh fruits and vegetables.", packetImage: Img.blueberryPacket, one: Img.blueberry1, two: Img.blueberry2, coverImage: Img.blueberry3, head: Img.blueberryHead, badge: Img.blueberryBadge),
        Plant(title: "Monstera", price: 160, selected: false, description: "The Monstera  also known as the swiss cheese plant is native to Central America. It is a climbing, evergreen perennial vine that is perhaps most noted for its large perforated leaves on thick plant stems and its long cord-like aerial roots", packetImage: Img.monsterraPacket, one: Img.monstera1, two: Img.monstera2, coverImage: Img.monstera3, head: Img.monsteraHead, badge: Img.monsteraBadge),
        Plant(title: "Daffodil", price: 100, selected: false, description: "Daffodils are reliable spring-flowering bulbs. They symbolize new beginnings & friendships and were also named after a greek myth.", packetImage: Img.daffodilPacket, one: Img.daffodil1, two: Img.daffodil2, coverImage: Img.daffodil3, head: Img.daffodilHead, badge: Img.daffodilBadge),
        Plant(title: "Rose", price: 140, selected: false, description: "Roses are woody perennial flowering plant of the genus Rosa, in the family Rosaceae. They're one of the oldest flowers & are commonly used in perfumes. They symbolize romance, love, beauty, and courage.", packetImage: Img.rosePacket, one: Img.rose1, two: Img.rose2, coverImage: Img.rose3, head: Img.roseHead, badge: Img.roseBadge),
        Plant(title: "Lavender", price: 100, selected: false, description: "Lavenders are small, branching and spreading shrubs with grey-green leaves and long flowering shoots. They have a wonderful and aromatic smell and symbolize purity, silence, devotion, serenity, grace, and calmness", packetImage: Img.lavenderPacket, one: Img.lavender1, two: Img.lavender2, coverImage: Img.lavender3, head: Img.lavenderHead, badge: Img.lavenderBadge),
        Plant(title: "Sunflower", price: 110, selected: false, description: "Sunflowers are annual plants, harvested after one growing season and can reach 1–3.5 m (3.3–11.5 ft) in height. They symbolize include happiness, optimism, honesty, longevity, peace, admiration, and devotion", packetImage: Img.sunflowerPacket, one: Img.sunflower1, two: Img.sunflower2, coverImage: Img.sunflower3, head: Img.sunflowerHead, badge: Img.sunflowerBadge),
        Plant(title: "Lily of the Valley", price: 100, selected: false, description: "Lily of the valley is a woodland flowering plant with sweetly scented, pendent, bell-shaped white flowers borne in sprays in spring. This flower symbolizes absolute purity, youth, sincerity, and discretion. But most importantly, it symbolizes happiness.", packetImage: Img.lilyValleyPacket, one: Img.lilyValley1, two: Img.lilyValley2, coverImage: Img.lilyValley3, head: Img.lilyValleyHead, badge: Img.lilyValleyBadge),
        Plant(title: "Lily", price: 100, selected: false, description: "Lilies are erect perennial plants with leafy stems, scaly bulbs, usually narrow leaves, and solitary or clustered flowers. They symbolize purity and fertility", packetImage: Img.lilyPacket, one: Img.lily1, two: Img.lily2, coverImage: Img.lily3, head: Img.lilyHead, badge: Img.lilyBadge),
        Plant(title: "Strawberry", price: 150, selected: false, description: "The strawberry is widely appreciated for its characteristic aroma, bright red color, juicy texture, and sweetness. The average strawberry has 200 seeds.", packetImage: Img.strawberryPacket, one: Img.strawberry1, two: Img.strawberry2, coverImage: Img.strawberry3, head: Img.strawberryHead, badge: Img.strawberryBadge),
        //head
        Plant(title: "Aloe", price: 160, selected: false, description: "Aloe sometimes described as a “wonder plant,” is a short-stemmed shrub. It is grown commercially for the health and moisturizing benefits found inside its leaves. Cleopatra applied aloe gel to her body as part of her beauty regimen!", packetImage: Img.aloePacket, one: Img.aloe1, two: Img.aloe2, coverImage: Img.aloe3, head: Img.aloeHead, badge: Img.aloeBadge),
    ]
}
