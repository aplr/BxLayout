// Copyright 2018 Oliver Borchert
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import UIKit

public protocol LayoutAttribute {
    
    associatedtype Dimension: AnyObject
    
    var anchor: NSLayoutAnchor<Dimension> { get }
    var multiplier: CGFloat { get }
    var constant: CGFloat { get }
}

public struct BaseLayoutAttribute<Dimension: AnyObject>: LayoutAttribute {
    
    internal unowned let viewLayout: ViewLayout
    
    public let anchor: NSLayoutAnchor<Dimension>
    
    public var multiplier: CGFloat { return 1 }
    public var constant: CGFloat { return 0 }
    
    internal init(viewLayout: ViewLayout, anchor: NSLayoutAnchor<Dimension>) {
        self.viewLayout = viewLayout
        self.anchor = anchor
    }
    
    public static func + (lhs: BaseLayoutAttribute,
                             rhs: CGFloat) -> AdditiveLayoutAttribute<Dimension> {
        return AdditiveLayoutAttribute(anchor: lhs.anchor, multiplier: 1, constant: rhs)
    }
    
    public static func - (lhs: BaseLayoutAttribute,
                             rhs: CGFloat) -> AdditiveLayoutAttribute<Dimension> {
        return AdditiveLayoutAttribute(anchor: lhs.anchor, multiplier: 1, constant: -rhs)
    }
}

public func * (lhs: BaseLayoutAttribute<NSLayoutDimension>,
               rhs: CGFloat) -> MultiplicativeLayoutAttribute<NSLayoutDimension> {
    return MultiplicativeLayoutAttribute(anchor: lhs.anchor, multiplier: rhs)
}

public func / (lhs: BaseLayoutAttribute<NSLayoutDimension>,
               rhs: CGFloat) -> MultiplicativeLayoutAttribute<NSLayoutDimension> {
    return MultiplicativeLayoutAttribute(anchor: lhs.anchor, multiplier: 1 / rhs)
}

public struct MultiplicativeLayoutAttribute<Dimension: AnyObject>: LayoutAttribute {
    
    public let anchor: NSLayoutAnchor<Dimension>
    public let multiplier: CGFloat
    
    public var constant: CGFloat { return 0 }
    
    internal init(anchor: NSLayoutAnchor<Dimension>, multiplier: CGFloat) {
        self.anchor = anchor
        self.multiplier = multiplier
    }
    
    public static func + (lhs: MultiplicativeLayoutAttribute,
                          rhs: CGFloat) -> AdditiveLayoutAttribute<Dimension> {
        return AdditiveLayoutAttribute(anchor: lhs.anchor, multiplier: lhs.multiplier, constant: rhs)
    }
    
    public static func - (lhs: MultiplicativeLayoutAttribute,
                          rhs: CGFloat) -> AdditiveLayoutAttribute<Dimension> {
        return AdditiveLayoutAttribute(anchor: lhs.anchor, multiplier: lhs.multiplier, constant: -rhs)
    }
}

public struct AdditiveLayoutAttribute<Dimension: AnyObject>: LayoutAttribute {
    
    public let anchor: NSLayoutAnchor<Dimension>
    public let multiplier: CGFloat
    public let constant: CGFloat
    
    internal init(anchor: NSLayoutAnchor<Dimension>, multiplier: CGFloat, constant: CGFloat) {
        self.anchor = anchor
        self.multiplier = multiplier
        self.constant = constant
    }
}

public struct NumericLayoutAttribute {
    
    internal unowned let viewLayout: ViewLayout
    
    internal let firstAnchor: NSLayoutDimension
    internal let secondAnchor: NSLayoutDimension
    
    internal init(viewLayout: ViewLayout, anchor1: NSLayoutDimension, anchor2: NSLayoutDimension) {
        self.viewLayout = viewLayout
        self.firstAnchor = anchor1
        self.secondAnchor = anchor2
    }
}
