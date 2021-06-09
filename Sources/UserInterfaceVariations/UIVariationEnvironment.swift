import UIKit

public protocol UIVariationEnvironment { }

extension UIVariationEnvironment where Self: UITraitEnvironment {
    
    public var variations: NSMutableArray {
        get {
            let key = Unmanaged.passUnretained(association).toOpaque()
            if let array = objc_getAssociatedObject(self, key) as! NSMutableArray? { return array }
            let array = NSMutableArray()
            objc_setAssociatedObject(self, key, array, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return array
        }
    }
    
    public func addVariation<Object, Value>(_ variation: UIVariation<Object, Value>) {
        variation.traitEnvironment = self
        variations.add(variation)
        variation.applyIfMatchesTraitEnvironment()
    }
    
    public func addVariations<Object, Value>(_ variations: [UIVariation<Object, Value>]) {
        for variation in variations {
            addVariation(variation)
        }
    }
    
    public func removeVariation<Object, Value>(_ variation: UIVariation<Object, Value>) {
        variations.remove(variation)
        variation.traitEnvironment = nil
    }
    
    public func addVariation<Object: AnyObject, Value>(for object: Object,
                                                       property: ReferenceWritableKeyPath<Object, Value>,
                                                       sizeClassDimension: SizeClassDimension,
                                                       whenCompact: Value) {
        switch sizeClassDimension {
        case .horizontal:
            addVariation(UIVariation<Object, Value>(object: object,
                                                    keyPath: property,
                                                    value: object[keyPath: property],
                                                    horizontalSizeClass: .regular,
                                                    verticalSizeClass: nil))
            addVariation(UIVariation<Object, Value>(object: object,
                                                    keyPath: property,
                                                    value: whenCompact,
                                                    horizontalSizeClass: .compact,
                                                    verticalSizeClass: nil))
        case .vertical:
            addVariation(UIVariation<Object, Value>(object: object,
                                                    keyPath: property,
                                                    value: object[keyPath: property],
                                                    horizontalSizeClass: nil,
                                                    verticalSizeClass: .regular))
            addVariation(UIVariation<Object, Value>(object: object,
                                                    keyPath: property,
                                                    value: whenCompact,
                                                    horizontalSizeClass: nil,
                                                    verticalSizeClass: .compact))
        }
    }
    
    /// Call this method when trait collection changes to keep variations reacting to them.
    ///
    ///     override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    ///         super.traitCollectionDidChange(previousTraitCollection)
    ///         activateVariationsMatchingTraitEnvironment()
    ///     }
    ///
    public func activateVariationsMatchingTraitEnvironment() {
        for variation in variations as! [UIVariationApplying] {
            variation.applyIfMatchesTraitEnvironment()
        }
    }
}

private let association = NSObject()
