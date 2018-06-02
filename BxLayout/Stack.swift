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

import Foundation
import UIKit

public func stack(_ layouts: Stackable..., orientation: ViewLayout.Orientation = .vertical) {
    assert(layouts.count >= 2, "Too few layout parameters.")
    assert(!layouts.enumerated().contains { param in
        if param.offset == 0 || param.offset == layouts.count - 1 { return !(param.element is ViewLayout) }
        else if param.element is CGFloatConvertible { return layouts[param.offset - 1] is CGFloatConvertible }
        else { return !(param.element is ViewLayout && !(param.element as! ViewLayout).isSuperview) }
        }, "Invalid layout parameters.")
    
    var index = 0
    while index < layouts.count - 1 {
        let layout1 = layouts[index] as! ViewLayout
        let spacing = (layouts[index + 1] as? CGFloatConvertible)?.asFloat()
        let layout2 = spacing == nil ? layouts[index + 1] as! ViewLayout : layouts[index + 2] as! ViewLayout
        switch orientation {
        case .horizontal: layout2.leading == (layout1.isSuperview ? layout1.leading : layout1.trailing) + (spacing ?? 0)
        case .vertical: layout1.bottom == (layout2.isSuperview ? layout2.bottom : layout2.top) - (spacing ?? 0)
        }
        index += spacing == nil ? 1 : 2
    }
}

public protocol Stackable { }

public protocol CGFloatConvertible: Stackable {
    
    func asFloat() -> CGFloat
}

extension ViewLayout: Stackable { }

extension CGFloat: CGFloatConvertible {
    
    public func asFloat() -> CGFloat {
        return self
    }
}

extension Int: CGFloatConvertible {
    
    public func asFloat() -> CGFloat {
        return CGFloat(self)
    }
}

extension Double: CGFloatConvertible {
    
    public func asFloat() -> CGFloat {
        return CGFloat(self)
    }
}

extension Float: CGFloatConvertible {
    
    public func asFloat() -> CGFloat {
        return CGFloat(self)
    }
}
