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

public final class ViewLayoutSet {
    
    private let superview: UIView
    private let viewLayouts: [ViewLayout]
    
    internal init(forSuperview superview: UIView, views: [UIView]) {
        self.superview = superview
        viewLayouts = [ViewLayout(describing: superview, isSuperview: true)] + views.map { $0.layout }
    }
    
    public func apply(once: Bool = false) {
        viewLayouts.dropFirst().forEach {
            $0.view.translatesAutoresizingMaskIntoConstraints = false
        }
        viewLayouts.forEach {
            NSLayoutConstraint.activate($0.constraints)
        }
        if once {
            superview.setNeedsLayout()
            superview.layoutIfNeeded()
            viewLayouts.forEach {
                NSLayoutConstraint.deactivate($0.constraints)
            }
            viewLayouts.dropFirst().forEach {
                $0.view.translatesAutoresizingMaskIntoConstraints = true
            }
        }
    }
    
    public func layout(_ execute: (ViewLayout, ViewLayout) -> Void) -> ViewLayoutSet {
        execute(viewLayouts[0], viewLayouts[1])
        return self
    }
    
    public func layout(_ execute: (ViewLayout, ViewLayout, ViewLayout) -> Void) -> ViewLayoutSet {
        execute(viewLayouts[0], viewLayouts[1], viewLayouts[2])
        return self
    }
    
    public func layout(_ execute: (ViewLayout, ViewLayout, ViewLayout, ViewLayout) -> Void) -> ViewLayoutSet {
        execute(viewLayouts[0], viewLayouts[1], viewLayouts[2], viewLayouts[3])
        return self
    }
    
    public func layout(_ execute: (ViewLayout, ViewLayout,
                                   ViewLayout, ViewLayout, ViewLayout) -> Void) -> ViewLayoutSet {
        execute(viewLayouts[0], viewLayouts[1], viewLayouts[2], viewLayouts[3], viewLayouts[4])
        return self
    }
    
    public func layout(_ execute: (ViewLayout, ViewLayout, ViewLayout,
                                   ViewLayout, ViewLayout, ViewLayout) -> Void) -> ViewLayoutSet {
        execute(viewLayouts[0], viewLayouts[1], viewLayouts[2], viewLayouts[3],
                viewLayouts[4], viewLayouts[5])
        return self
    }
    
    public func layout(_ execute: (ViewLayout, ViewLayout, ViewLayout, ViewLayout,
                                   ViewLayout, ViewLayout, ViewLayout) -> Void) -> ViewLayoutSet {
        execute(viewLayouts[0], viewLayouts[1], viewLayouts[2], viewLayouts[3], viewLayouts[4],
                viewLayouts[5], viewLayouts[6])
        return self
    }
    
    public func layout(_ execute: (ViewLayout, ViewLayout, ViewLayout, ViewLayout, ViewLayout,
                                   ViewLayout, ViewLayout, ViewLayout) -> Void) -> ViewLayoutSet {
        execute(viewLayouts[0], viewLayouts[1], viewLayouts[2], viewLayouts[3], viewLayouts[4],
                viewLayouts[5], viewLayouts[6], viewLayouts[7])
        return self
    }
    
    public func layout(_ execute: (ViewLayout, ViewLayout, ViewLayout, ViewLayout, ViewLayout,
                                   ViewLayout, ViewLayout, ViewLayout, ViewLayout) -> Void) -> ViewLayoutSet {
        execute(viewLayouts[0], viewLayouts[1], viewLayouts[2], viewLayouts[3], viewLayouts[4],
                viewLayouts[5], viewLayouts[6], viewLayouts[7], viewLayouts[8])
        return self
    }
}
