//
//  Maths.swift
//  AoC2019 Day 10
//
//  Created by Chris Rumpf on 12/27/19.
//  Copyright © 2019 Chris Rumpf. All rights reserved.
//

import Foundation

struct Cartesian {
    let x, y: Double

    func polar(to: Cartesian) -> Polar {
        return Polar(r: distance(to: to), theta: radian(to: to))
    }

    func distance(to: Cartesian) -> Double {
        let dx = to.x - x
        let dy = to.y - y
        return sqrt(dx * dx + dy * dy)
    }
    
    // been a hot minute since I've done calc, so I needed to look up a reference https://www.mathsisfun.com/polar-cartesian-coordinates.html
    func radian(to: Cartesian) -> Double {
        let dx = to.x - x
        let dy = to.y - y

        if dx == 0 && dy == 0 {
            return .nan
        } else if dx == 0 {
            return (dy > 0 ? 1 : 3) * .pi / 2
        } else if dx > 0 && dy >= 0 {
            // quadrant 1
            return atan(dy / dx)
        } else if dx < 0 && dy >= 0 {
            // quadrant 2
            return .pi - atan(dy / -dx)
        } else if dx < 0 && dy < 0 {
            // quadrant 3
            return .pi + atan(-dy / -dx)
        } else {
            // quadrant 4
            return 2 * .pi - atan(-dy / dx)
        }
    }

    func degree(to: Cartesian) -> Double {
        return radian(to: to) * 180 / .pi
    }
}

struct Polar {
    let r, theta: Double
}
