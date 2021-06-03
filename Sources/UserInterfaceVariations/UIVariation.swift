import UIKit

public enum SizeClassDimension {
    case horizontal, vertical
}

public class UIVariation<Object: AnyObject, Value>: NSObject {
    
    public weak var traitEnvironment: UITraitEnvironment?
    
    public let object: Object
    public let property: ReferenceWritableKeyPath<Object, Value>
    public var value: Value {
        didSet { applyIfMatchesTraitEnvironment() }
    }
    public let horizontalSizeClass: UIUserInterfaceSizeClass?
    public let verticalSizeClass: UIUserInterfaceSizeClass?
    
    public static func make(for object: Object,
                            property: ReferenceWritableKeyPath<Object, Value>,
                            sizeClassDimension: SizeClassDimension,
                            whenCompact: Value,
                            whenRegular: Value) -> [UIVariation<Object, Value>] {
        switch sizeClassDimension {
        case .horizontal:
            return [
                UIVariation<Object, Value>(object: object, keyPath: property, value: whenCompact, horizontalSizeClass: .compact, verticalSizeClass: nil),
                UIVariation<Object, Value>(object: object, keyPath: property, value: whenRegular, horizontalSizeClass: .regular, verticalSizeClass: nil),
            ]
        case .vertical:
            return [
                UIVariation<Object, Value>(object: object, keyPath: property, value: whenCompact, horizontalSizeClass: nil, verticalSizeClass: .compact),
                UIVariation<Object, Value>(object: object, keyPath: property, value: whenRegular, horizontalSizeClass: nil, verticalSizeClass: .regular),
            ]
        }
    }
    
    public init(object: Object,
                keyPath: ReferenceWritableKeyPath<Object, Value>,
                value: Value,
                horizontalSizeClass: UIUserInterfaceSizeClass? = nil,
                verticalSizeClass: UIUserInterfaceSizeClass? = nil) {
        self.object = object
        self.property = keyPath
        self.value = value
        self.horizontalSizeClass = horizontalSizeClass
        self.verticalSizeClass = verticalSizeClass
    }
    
    public override var description: String {
        """
        <Variation<\(Object.self), \(Value.self): \(Unmanaged.passUnretained(self).toOpaque()))> {
            object: \(object)
            keyPath: \(property._kvcKeyPathString ?? String(describing: property))
            value: \(value)
            horizontalSizeClass: \(horizontalSizeClass?.name ?? "nil")
            verticalSizeClass: \(verticalSizeClass?.name ?? "nil")
        }
        """
    }
}

extension UIVariation: UIVariationApplying {
    
    func applyIfMatchesTraitEnvironment() {
        guard doesMatchTraitEnvironment() else { return }
        object[keyPath: property] = value
    }
    
    func applyIfMatchesTraitEnvironment() where Value: Equatable {
        guard doesMatchTraitEnvironment() else { return }
        guard object[keyPath: property] != value else { return }
        object[keyPath: property] = value
    }
    
    private func doesMatchTraitEnvironment() -> Bool {
        guard let traitCollection = traitEnvironment?.traitCollection else {
            print("Missing traitEnvironment when trying to apply \(self)")
            return false
        }
        if let horizontalSizeClass = horizontalSizeClass {
            if traitCollection.horizontalSizeClass != horizontalSizeClass { return false }
        }
        if let verticalSizeClass = verticalSizeClass {
            if traitCollection.verticalSizeClass != verticalSizeClass { return false }
        }
        return true
    }
}

extension UIUserInterfaceSizeClass {
    
    fileprivate var name: String {
        switch self {
        case .unspecified: return "unspecified"
        case .compact: return "compact"
        case .regular: return "regular"
        @unknown default: return "unknown"
        }
    }
}
