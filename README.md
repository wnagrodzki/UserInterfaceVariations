# UserInterfaceVariations

Allows defining user interface variations depending on `UIUserInterfaceSizeClass`. It is a substitute of functionality provided by *Xcode Interface Builder*.

## Example usages

Deactivate `NSLayoutConstraint` for compact horizontal size class:

```swift
addVariation(for: constraint,
             property: \.isActive,
             sizeClassDimension: .horizontal,
             whenCompact: false)
```

Control `UILabel` `text` in every size class configuration:

```swift
addVariations([
    UIVariation(object: label,
                keyPath: \.text,
                value: "w:C h:C",
                horizontalSizeClass: .compact,
                verticalSizeClass: .compact),
    UIVariation(object: label,
                keyPath: \.text,
                value: "w:C h:R",
                horizontalSizeClass: .compact,
                verticalSizeClass: .regular),
    UIVariation(object: label,
                keyPath: \.text,
                value: "w:R h:C",
                horizontalSizeClass: .regular,
                verticalSizeClass: .compact),
    UIVariation(object: label,
                keyPath: \.text,
                value: "w:R h:R",
                horizontalSizeClass: .regular,
                verticalSizeClass: .regular)
])
```

Make only horizontal class matter:

```swift
addVariations([
    UIVariation(object: label,
                keyPath: \.text,
                value: "w:C h:Any",
                horizontalSizeClass: .compact,
                verticalSizeClass: nil),
    UIVariation(object: label,
                keyPath: \.text,
                value: "w:R h:Any",
                horizontalSizeClass: .regular,
                verticalSizeClass: nil),
])
```

Assign new value to variation:

```swift
let variation = UIVariation(object: view,
                            keyPath: \.backgroundColor,
                            value: .white,
                            horizontalSizeClass: .compact,
                            verticalSizeClass: nil)
variation.value = .black
```

## Integration

Declare `UIVariationEnvironment` conformance on an object already conforming to `UITraitEnvironment` (e.g. `UIViewController`, `UIView`) and override following method.

```swift
class ViewController: UIViewController, UIVariationEnvironment {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        activateVariationsMatchingTraitEnvironment()
    }
}
```
