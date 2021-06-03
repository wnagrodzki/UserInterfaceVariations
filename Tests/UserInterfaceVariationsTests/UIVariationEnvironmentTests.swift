import XCTest
@testable import UserInterfaceVariations

final class UIVariationEnvironmentTests: XCTestCase {
    
    let label = UILabel()
    let valueWhenCompact = "value when compact"
    let valueWhenRegular = "value when regular"
    
    override func setUp() {
        label.text = nil
    }
    
    func test_When_variation_matches_traitEnvironment_Then_it_is_applied() {
        let variationEnvironment = UIVariationEnvironmentFake(traitCollection: UITraitCollection(horizontalSizeClass: .compact))
        let variation = UIVariation(object: label,
                                    keyPath: \.text,
                                    value: valueWhenCompact,
                                    horizontalSizeClass: .compact,
                                    verticalSizeClass: nil)
        variationEnvironment.addVariation(variation)
        XCTAssertEqual(label.text, variation.value)
    }
    
    func test_adding_variation_convenience_method_for_sizeClassDimension_horizontal() {
        label.text = valueWhenRegular
        
        let variationEnvironment = UIVariationEnvironmentFake(traitCollection: UITraitCollection(horizontalSizeClass: .regular))
        variationEnvironment.addVariation(for: label,
                                          property: \.text,
                                          sizeClassDimension: .horizontal,
                                          whenCompact: valueWhenCompact)
        
        let variation0 = variationEnvironment.variations[0] as! UIVariation<UILabel, String?>
        XCTAssertTrue(variation0.object === label)
        XCTAssertTrue(variation0.property == \.text)
        XCTAssertTrue(variation0.value == valueWhenRegular)
        XCTAssertTrue(variation0.horizontalSizeClass == .regular)
        XCTAssertTrue(variation0.verticalSizeClass == nil)
        
        let variation1 = variationEnvironment.variations[1] as! UIVariation<UILabel, String?>
        XCTAssertTrue(variation1.object === label)
        XCTAssertTrue(variation1.property == \.text)
        XCTAssertTrue(variation1.value == valueWhenCompact)
        XCTAssertTrue(variation1.horizontalSizeClass == .compact)
        XCTAssertTrue(variation1.verticalSizeClass == nil)
    }
    
    func test_adding_variation_convenience_method_for_sizeClassDimension_vartical() {
        label.text = valueWhenRegular
        
        let variationEnvironment = UIVariationEnvironmentFake(traitCollection: UITraitCollection(horizontalSizeClass: .regular))
        variationEnvironment.addVariation(for: label,
                                          property: \.text,
                                          sizeClassDimension: .vertical,
                                          whenCompact: valueWhenCompact)
        
        let variation0 = variationEnvironment.variations[0] as! UIVariation<UILabel, String?>
        XCTAssertTrue(variation0.object === label)
        XCTAssertTrue(variation0.property == \.text)
        XCTAssertTrue(variation0.value == valueWhenRegular)
        XCTAssertTrue(variation0.horizontalSizeClass == nil)
        XCTAssertTrue(variation0.verticalSizeClass == .regular)
        
        let variation1 = variationEnvironment.variations[1] as! UIVariation<UILabel, String?>
        XCTAssertTrue(variation1.object === label)
        XCTAssertTrue(variation1.property == \.text)
        XCTAssertTrue(variation1.value == valueWhenCompact)
        XCTAssertTrue(variation1.horizontalSizeClass == nil)
        XCTAssertTrue(variation1.verticalSizeClass == .compact)
    }
    
    func test_When_verticalSizeClass_in_traitCollection_changes_Then_variation_is_applied() {
        let variationEnvironment = UIVariationEnvironmentFake(traitCollection: UITraitCollection(verticalSizeClass: .regular))
        label.text = valueWhenRegular
        variationEnvironment.addVariation(for: label,
                                          property: \.text,
                                          sizeClassDimension: .vertical,
                                          whenCompact: valueWhenCompact)
        variationEnvironment.traitCollection = UITraitCollection(verticalSizeClass: .compact)
        XCTAssertEqual(label.text, valueWhenCompact)
    }
}

class UIVariationEnvironmentFake: NSObject, UITraitEnvironment {
    
    var traitCollection = UITraitCollection() {
        didSet { traitCollectionDidChange(oldValue) }
    }
    
    init(traitCollection: UITraitCollection) {
        self.traitCollection = traitCollection
        super.init()
    }
    
    func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        activateVariationsMatchingTraitEnvironment()
    }
}

extension UIVariationEnvironmentFake: UIVariationEnvironment { }
