# BxLayout
BxLayout provides a beautiful interface for performing iOS autolayout in code.

## Usage

### Getting Started
Suppose you have a text field `textField` and a label `label` that are subviews of a view `view`:
 * You want to position the text field in the middle of the view and it should cover the view to the margins.
 * You want to put the label below the text field with a margin of 5 points.
 * You want to align the leading edge of the text field with the one of the label.
 
Given these thoughts, the code can directly be derived:
```swift
view.addSubviews(textField, label) // Adds the views to the view, no need to do so otherwise
    .layout { superview, textField, label in 
    // You need to declare all views that you want to layout
    // * The first parameter is always the superview onto which views are added
    // * Subsequent parameters are in the order of the parameters passed into the function
    // The declared views are not views anymore but layout objects.
    
        textField.center.y == superview.center.y
        textField.leading == superview.margin.leading
        textField.trailing == superview.margin.trailing
        
        label.top == textField.bottom + 5
        label.leading == textField.leading
    
    }.apply() 
    // `apply` actually creates the layout constraints and sets the autoresizing masks of
    // all subviews to `false`.
```

### Convenience Functions
The above code already looks very clean, however, there are two functions that enable even more beautiful layout code:
 * `follow`: A function on a layout object that describes a set of equality constraints.
 * `stack`: A function to layout views next to each other.
Using these, the above can be rewritten as follows:
```swift
view.addSubviews(textField, label)
    .layout { superview, textField, label in
    
        textField.follow(superview, on: [.centerY, .marginLeading, .marginTrailing])
        
        stack(textField, 5, label)
        label.leading == textField.leading
    
    }.apply()
```
By default, the stack function stacks views vertically, however, an orientation can be given explicitly like:
```swift
stack(textField, 5, label, 
      orientation: .vertical)
```

### Advanced Convenience Functions
The convenience functions above are, however, even more powerful:

The `follow` function is informally defined as follows:
```swift
func follow(<view>, on: <set of equalities>, insetBy: <edge insets>)
```
Possible values for the set of equalities are intuitive, there are even some combinations. The above application of `follow` may be rewritten like this:
```swift
textField.follow(superview, on: [.centerY, .marginHorizontal])
```
The default set of equalities is set to all edges.

The edge insets are given as `EdgeInsets(leading:trailing:top:bottom:)` where any combination of parameters may be used. They default to zero on all edges.

The stack function takes any number of parameters. The sequence of parameters is subject to the following constraints:
 * A view must be followed by a view or a number (no number implies a number of 0).
 * A number must be followed by a view.
 * The superview may only the first and/or last parameter and there must be at least one view in between.
Application of the stack function *can* result in a runtime error in case the sequence of parameters does not meet the above requirements.

### Even More Advanced Concepts
Until now, we have mostly considered equalities. However, layout constraint can do much more.
Everything that layout constraints provide can easily be done in BxLayout:
 * Inequalities: e.g. `view1.height <= view2.height`
 * Addition of constants: e.g. `view1.height == view2.height + 10`
 * Multiplication with factors: e.g. `view1.height == view2.height * 2`
 * The combination of the above: e.g. `view1.height <= view2.height * 2 + 10`
 * Priorities (where the priorities are of type `UILayoutPriority`): e.g. `view1.height == view2.height ~ .priorityLow`
 * Assignment (in case a layout constraint is explicitly needed later): e.g. `view1.height == view2.height => self.myLayoutConstraint` (`myLayoutConstraint` is expected to be of type `NSLayoutConstraint?`)
 
Eventually, complex layout may require constraints between multiple superviews. However, the above interface is only available when adding subviews due to the required layout objects. As a result, there is another function that can be used to obtain layout objects. The application is exactly the same:
```swift
view.with(subviewOfOtherView1, subviewOfOtherView2)
    .layout { superview, view1, view2 in 
        // perform layout
    }.apply()
```

## CocoaPods
BxLayout is easily usable through CocoaPods. Just add one of the following to your Podfile:
 * `pod 'BxLayout'`
 * `pod 'Bx/Layout'`
 
## License
Usage of BxLayout is subject to the Apache 2.0 License.
