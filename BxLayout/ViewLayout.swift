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
import BxUtility

public typealias EdgeInsets = NSDirectionalEdgeInsets

extension EdgeInsets {
    
    public init(leading: CGFloat = 0, trailing: CGFloat = 0, top: CGFloat = 0, bottom: CGFloat = 0) {
        self.init(top: top, leading: leading, bottom: bottom, trailing: trailing)
    }
}

public final class ViewLayout {
    
    public enum Orientation {
        case vertical
        case horizontal
    }
    
    public struct Center {
        
        internal unowned let viewLayout: ViewLayout
        
        public var x: BaseLayoutAttribute<NSLayoutXAxisAnchor> {
            return BaseLayoutAttribute(viewLayout: viewLayout,
                                       anchor: viewLayout.view.centerXAnchor)
        }
        
        public var y: BaseLayoutAttribute<NSLayoutYAxisAnchor> {
            return BaseLayoutAttribute(viewLayout: viewLayout,
                                       anchor: viewLayout.view.centerYAnchor)
        }
    }
    
    public struct Margin {
        
        internal unowned let viewLayout: ViewLayout
        
        public var leading: BaseLayoutAttribute<NSLayoutXAxisAnchor> {
            return BaseLayoutAttribute(viewLayout: viewLayout,
                                       anchor: viewLayout.view.layoutMarginsGuide.leadingAnchor)
        }
        
        public var trailing: BaseLayoutAttribute<NSLayoutXAxisAnchor> {
            return BaseLayoutAttribute(viewLayout: viewLayout,
                                       anchor: viewLayout.view.layoutMarginsGuide.trailingAnchor)
        }
        
        public var top: BaseLayoutAttribute<NSLayoutYAxisAnchor> {
            return BaseLayoutAttribute(viewLayout: viewLayout,
                                       anchor: viewLayout.view.layoutMarginsGuide.topAnchor)
        }
        
        public var bottom: BaseLayoutAttribute<NSLayoutYAxisAnchor> {
            return BaseLayoutAttribute(viewLayout: viewLayout,
                                       anchor: viewLayout.view.layoutMarginsGuide.bottomAnchor)
        }
    }
    
    public struct Baseline {
        
        internal unowned let viewLayout: ViewLayout
        
        public var first: BaseLayoutAttribute<NSLayoutYAxisAnchor> {
            return BaseLayoutAttribute(viewLayout: viewLayout, anchor: viewLayout.view.firstBaselineAnchor)
        }
        
        public var last: BaseLayoutAttribute<NSLayoutYAxisAnchor> {
            return BaseLayoutAttribute(viewLayout: viewLayout, anchor: viewLayout.view.lastBaselineAnchor)
        }
    }
    
    internal var constraints: [NSLayoutConstraint] = []
    internal unowned let view: UIView
    internal let isSuperview: Bool
    internal weak var parent: ViewLayout?
    
    internal init(describing: UIView, isSuperview: Bool, parent: ViewLayout? = nil) {
        self.view = describing
        self.isSuperview = isSuperview
    }
    
    internal var topmostParent: ViewLayout {
        if let parent = parent {
            return parent.topmostParent
        }
        return self
    }
    
    public var superview: ViewLayout? {
        return view.superview |> { ViewLayout(describing: $0, isSuperview: false, parent: self) }
    }
    
    public var leading: BaseLayoutAttribute<NSLayoutXAxisAnchor> {
        return BaseLayoutAttribute(viewLayout: self, anchor: view.leadingAnchor)
    }
    
    public var trailing: BaseLayoutAttribute<NSLayoutXAxisAnchor> {
        return BaseLayoutAttribute(viewLayout: self, anchor: view.trailingAnchor)
    }
    
    public var top: BaseLayoutAttribute<NSLayoutYAxisAnchor> {
        return BaseLayoutAttribute(viewLayout: self, anchor: view.topAnchor)
    }
    
    public var bottom: BaseLayoutAttribute<NSLayoutYAxisAnchor> {
        return BaseLayoutAttribute(viewLayout: self, anchor: view.bottomAnchor)
    }
    
    public var height: BaseLayoutAttribute<NSLayoutDimension> {
        return BaseLayoutAttribute(viewLayout: self, anchor: view.heightAnchor)
    }
    
    public var width: BaseLayoutAttribute<NSLayoutDimension> {
        return BaseLayoutAttribute(viewLayout: self, anchor: view.widthAnchor)
    }
    
    public var center: Center {
        return Center(viewLayout: self)
    }
    
    public var margin: Margin {
        return Margin(viewLayout: self)
    }
    
    public var baseline: Baseline {
        return Baseline(viewLayout: self)
    }
    
    public var aspectRatio: NumericLayoutAttribute {
        return NumericLayoutAttribute(viewLayout: self, anchor1: view.widthAnchor, anchor2: view.heightAnchor)
    }
    
    public struct MarginOptions: OptionSet {
        
        public let rawValue: Int16
        
        public init(rawValue: Int16) {
            self.rawValue = rawValue
        }
        
        public static let leading = MarginOptions(rawValue: 0x1)
        public static let trailing = MarginOptions(rawValue: 0x2)
        public static let top = MarginOptions(rawValue: 0x4)
        public static let bottom = MarginOptions(rawValue: 0x8)
        
        public static let marginLeading = MarginOptions(rawValue: 0x10)
        public static let marginTrailing = MarginOptions(rawValue: 0x20)
        public static let marginTop = MarginOptions(rawValue: 0x40)
        public static let marginBottom = MarginOptions(rawValue: 0x80)
        
        public static let edgesVertical: MarginOptions = [.top, .bottom]
        public static let edgesHorizontal: MarginOptions = [.leading, .trailing]
        public static let edges: MarginOptions = [.edgesVertical, .edgesHorizontal]
        
        public static let marginsVertical: MarginOptions = [.marginTop, .marginBottom]
        public static let marginsHorizontal: MarginOptions = [.marginLeading, .marginTrailing]
        public static let margins: MarginOptions = [.marginsVertical, .marginsHorizontal]
    }
    
    @discardableResult
    public func follow(_ layout: ViewLayout,
                       on margins: MarginOptions = .edges,
                       insetBy: EdgeInsets = EdgeInsets()) -> ViewLayout {
        assert(!margins.contains(.leading) || !margins.contains(.marginLeading),
               "Cannot constraint to margin and edge simultaneously.")
        assert(!margins.contains(.trailing) || !margins.contains(.marginTrailing),
               "Cannot constraint to margin and edge simultaneously.")
        assert(!margins.contains(.top) || !margins.contains(.marginTop),
               "Cannot constraint to margin and edge simultaneously.")
        assert(!margins.contains(.bottom) || !margins.contains(.marginBottom),
               "Cannot constraint to margin and edge simultaneously.")
        
        if margins.contains(.leading) {
            self.leading == layout.leading + insetBy.leading
        } else if margins.contains(.marginLeading) {
            self.leading == layout.margin.leading + insetBy.leading
        }
        if margins.contains(.trailing) {
            self.trailing == layout.trailing - insetBy.trailing
        } else if margins.contains(.marginTrailing) {
            self.trailing == layout.margin.trailing - insetBy.trailing
        }
        if margins.contains(.top) {
            self.top == layout.top + insetBy.top
        } else if margins.contains(.marginTop) {
            self.top == layout.margin.top + insetBy.top
        }
        if margins.contains(.bottom) {
            self.bottom == layout.bottom - insetBy.bottom
        } else if margins.contains(.marginBottom) {
            self.bottom == layout.margin.bottom - insetBy.bottom
        }
        return self
    }
    
    @discardableResult
    public func follow(centerOf layout: ViewLayout, offsetBy offset: CGPoint = .zero) -> ViewLayout {
        self.center.x == layout.center.x + offset.x
        self.center.y == layout.center.y + offset.y
        return self
    }
    
    @discardableResult
    public func set(width: CGFloat? = nil, height: CGFloat? = nil) -> ViewLayout {
        if let width = width {
            constraints.append(self.width == width)
        }
        if let height = height {
            constraints.append(self.height == height)
        }
        return self
    }
}

extension NSLayoutConstraint {
    
    fileprivate func adding(to layout: ViewLayout) -> NSLayoutConstraint {
        layout.topmostParent.constraints += [self]
        return self
    }
}

@discardableResult
public func == (lhs: BaseLayoutAttribute<NSLayoutDimension>, rhs: CGFloat) -> NSLayoutConstraint {
    return (lhs.anchor as! NSLayoutDimension).constraint(equalToConstant: rhs).adding(to: lhs.viewLayout)
}

@discardableResult
public func == <L: LayoutAttribute>(lhs: BaseLayoutAttribute<NSLayoutDimension>,
                                    rhs: L) -> NSLayoutConstraint where L.Dimension == NSLayoutDimension {
    return (lhs.anchor as! NSLayoutDimension).constraint(equalTo: rhs.anchor as! NSLayoutDimension,
                                                         multiplier: rhs.multiplier,
                                                         constant: rhs.constant).adding(to: lhs.viewLayout)
}

@discardableResult
public func == <L: LayoutAttribute, D>(lhs: BaseLayoutAttribute<D>, rhs: L) -> NSLayoutConstraint where L.Dimension == D {
    return lhs.anchor.constraint(equalTo: rhs.anchor, constant: rhs.constant).adding(to: lhs.viewLayout)
}

@discardableResult
public func >= (lhs: BaseLayoutAttribute<NSLayoutDimension>, rhs: CGFloat) -> NSLayoutConstraint {
    return (lhs.anchor as! NSLayoutDimension).constraint(greaterThanOrEqualToConstant: rhs).adding(to: lhs.viewLayout)
}

@discardableResult
public func >= <L: LayoutAttribute>(lhs: BaseLayoutAttribute<NSLayoutDimension>,
                                    rhs: L) -> NSLayoutConstraint where L.Dimension == NSLayoutDimension {
    return (lhs.anchor as! NSLayoutDimension).constraint(greaterThanOrEqualTo: rhs.anchor as! NSLayoutDimension,
                                                         multiplier: rhs.multiplier,
                                                         constant: rhs.constant).adding(to: lhs.viewLayout)
}

@discardableResult
public func >= <L: LayoutAttribute, D>(lhs: BaseLayoutAttribute<D>, rhs: L) -> NSLayoutConstraint where L.Dimension == D {
    return lhs.anchor.constraint(greaterThanOrEqualTo: rhs.anchor, constant: rhs.constant).adding(to: lhs.viewLayout)
}

@discardableResult
public func <= (lhs: BaseLayoutAttribute<NSLayoutDimension>, rhs: CGFloat) -> NSLayoutConstraint {
    return (lhs.anchor as! NSLayoutDimension).constraint(lessThanOrEqualToConstant: rhs).adding(to: lhs.viewLayout)
}

@discardableResult
public func <= <L: LayoutAttribute>(lhs: BaseLayoutAttribute<NSLayoutDimension>,
                                    rhs: L) -> NSLayoutConstraint where L.Dimension == NSLayoutDimension {
    return (lhs.anchor as! NSLayoutDimension).constraint(lessThanOrEqualTo: rhs.anchor as! NSLayoutDimension,
                                                         multiplier: rhs.multiplier,
                                                         constant: rhs.constant).adding(to: lhs.viewLayout)
}

@discardableResult
public func <= <L: LayoutAttribute, D>(lhs: BaseLayoutAttribute<D>, rhs: L) -> NSLayoutConstraint where L.Dimension == D {
    return lhs.anchor.constraint(lessThanOrEqualTo: rhs.anchor, constant: rhs.constant).adding(to: lhs.viewLayout)
}

@discardableResult
public func == (lhs: NumericLayoutAttribute, rhs: CGFloat) -> NSLayoutConstraint {
    return lhs.firstAnchor.constraint(equalTo: lhs.secondAnchor, multiplier: rhs).adding(to: lhs.viewLayout)
}

precedencegroup ReverseAssignmentPrecedence {
    associativity: left
    lowerThan: TernaryPrecedence
}

infix operator =>: ReverseAssignmentPrecedence

public func => (lhs: NSLayoutConstraint, rhs: inout NSLayoutConstraint) {
    rhs = lhs
}

public func => (lhs: NSLayoutConstraint, rhs: inout NSLayoutConstraint?) {
    rhs = lhs
}
