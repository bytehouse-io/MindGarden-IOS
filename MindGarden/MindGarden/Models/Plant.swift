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
    let coverImage: Image

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    static func == (lhs: Plant, rhs: Plant) -> Bool {
        return lhs.title == rhs.title
    }
    static var plants: [Plant] = [Plant(title: "White Daisy", price: 100, selected: false, description: "With their white petals and yellow centers, white daisies symbolize innocence and the other classic daisy traits, such as babies, motherhood, hope, and new beginnings.", packetImage: Img.blueTulipsPacket, coverImage: Img.daisy), Plant(title: "Red Tulips", price: 90, selected: false, description: "Tulips are a genus of spring-blooming perennial herbaceous bulbiferous geophytes. The flowers are usually large, showy and brightly colored, generally red, pink, yellow, or white. ", packetImage: Img.redTulipsPacket, coverImage: Img.redTulips3)]
}
