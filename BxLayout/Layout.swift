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

extension UIView {

    @discardableResult
    public func addSubviews(_ subview: UIView, _ others: UIView...) -> ViewLayoutSet {
        ([subview] + others).forEach {
            self.addSubview($0)
        }
        return ViewLayoutSet(forSuperview: self, views: [subview] + others)
    }
    
    public func with(_ view: UIView, _ others: UIView...) -> ViewLayoutSet {
        return ViewLayoutSet(forSuperview: self, views: [view] + others)
    }

    internal var layout: ViewLayout {
        return ViewLayout(describing: self, isSuperview: false)
    }
}
