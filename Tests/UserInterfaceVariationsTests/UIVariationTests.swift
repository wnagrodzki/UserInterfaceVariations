import XCTest
@testable import UserInterfaceVariations

final class UIVariationTests: XCTestCase {
    
    let label = UILabel()
    let traitEnvironment = TraitEnvironmentStub()
    let valueWhenCompact = "value when compact"
    let valueWhenRegular = "value when regular"
    
    override func setUp() {
        label.text = nil
        traitEnvironment.traitCollection = UITraitCollection()
    }
    
    func test_When_horizontalSizeClass_matches_traitEnvironment_Then_variation_is_applied() {
        let sut = UIVariation(object: label,
                              keyPath: \.text,
                              value: valueWhenCompact,
                              horizontalSizeClass: .compact,
                              verticalSizeClass: nil)
        traitEnvironment.traitCollection = UITraitCollection(horizontalSizeClass: .compact)
        sut.traitEnvironment = traitEnvironment
        sut.applyIfMatchesTraitEnvironment()
        XCTAssertEqual(label.text, sut.value)
    }
    
    func test_When_verticalSizeClass_matches_traitEnvironment_Then_variation_is_applied() {
        let sut = UIVariation(object: label,
                              keyPath: \.text,
                              value: valueWhenCompact,
                              horizontalSizeClass: nil,
                              verticalSizeClass: .compact)
        traitEnvironment.traitCollection = UITraitCollection(verticalSizeClass: .compact)
        sut.traitEnvironment = traitEnvironment
        sut.applyIfMatchesTraitEnvironment()
        XCTAssertEqual(label.text, sut.value)
    }
    
    func test_When_horizontalSizeClass_do_not_match_traitEnvironment_Then_variation_is_NOT_applied() {
        let sut = UIVariation(object: label,
                              keyPath: \.text,
                              value: valueWhenCompact,
                              horizontalSizeClass: .compact,
                              verticalSizeClass: nil)
        traitEnvironment.traitCollection = UITraitCollection(horizontalSizeClass: .regular)
        sut.traitEnvironment = traitEnvironment
        sut.applyIfMatchesTraitEnvironment()
        XCTAssertNotEqual(label.text, sut.value)
    }
    
    func test_When_verticalSizeClass_do_not_match_traitEnvironment_Then_variation_is_NOT_applied() {
        let sut = UIVariation(object: label,
                              keyPath: \.text,
                              value: valueWhenCompact,
                              horizontalSizeClass: nil,
                              verticalSizeClass: .compact)
        traitEnvironment.traitCollection = UITraitCollection(verticalSizeClass: .regular)
        sut.traitEnvironment = traitEnvironment
        sut.applyIfMatchesTraitEnvironment()
        XCTAssertNotEqual(label.text, sut.value)
    }
    
    func test_When_horizontalSizeClass_matches_traitEnvironment_and_value_is_modified_Then_variation_is_applied() {
        let newValue = "value when compact after modification"
        let sut = UIVariation(object: label,
                              keyPath: \.text,
                              value: "value when compact before modification",
                              horizontalSizeClass: .compact,
                              verticalSizeClass: nil)
        traitEnvironment.traitCollection = UITraitCollection(horizontalSizeClass: .compact)
        sut.traitEnvironment = traitEnvironment
        sut.value = newValue
        XCTAssertEqual(label.text, newValue)
    }
    
    func test_When_traitEnvironment_is_nil_Then_variation_is_NOT_applied() {
        let sut = UIVariation(object: label,
                              keyPath: \.text,
                              value: valueWhenCompact,
                              horizontalSizeClass: .compact,
                              verticalSizeClass: nil)
        traitEnvironment.traitCollection = UITraitCollection(horizontalSizeClass: .compact)
        sut.applyIfMatchesTraitEnvironment()
        XCTAssertNotEqual(label.text, sut.value)
    }
    
    func test_factory_method_for_sizeClassDimension_horizontal() {
        let variations = UIVariation.make(for: label,
                                          property: \.text,
                                          sizeClassDimension: .horizontal,
                                          whenCompact: valueWhenCompact,
                                          whenRegular: valueWhenRegular)
        
        XCTAssertTrue(variations[0].object === label)
        XCTAssertTrue(variations[0].property == \.text)
        XCTAssertTrue(variations[0].value == valueWhenCompact)
        XCTAssertTrue(variations[0].horizontalSizeClass == .compact)
        XCTAssertTrue(variations[0].verticalSizeClass == nil)
        
        XCTAssertTrue(variations[1].object === label)
        XCTAssertTrue(variations[1].property == \.text)
        XCTAssertTrue(variations[1].value == valueWhenRegular)
        XCTAssertTrue(variations[1].horizontalSizeClass == .regular)
        XCTAssertTrue(variations[1].verticalSizeClass == nil)
    }
    
    func test_factory_method_for_sizeClassDimension_vertical() {
        let variations = UIVariation.make(for: label,
                                          property: \.text,
                                          sizeClassDimension: .vertical,
                                          whenCompact: valueWhenCompact,
                                          whenRegular: valueWhenRegular)
        
        XCTAssertTrue(variations[0].object === label)
        XCTAssertTrue(variations[0].property == \.text)
        XCTAssertTrue(variations[0].value == valueWhenCompact)
        XCTAssertTrue(variations[0].horizontalSizeClass == nil)
        XCTAssertTrue(variations[0].verticalSizeClass == .compact)
        
        XCTAssertTrue(variations[1].object === label)
        XCTAssertTrue(variations[1].property == \.text)
        XCTAssertTrue(variations[1].value == valueWhenRegular)
        XCTAssertTrue(variations[1].horizontalSizeClass == nil)
        XCTAssertTrue(variations[1].verticalSizeClass == .regular)
    }
}

class TraitEnvironmentStub: NSObject, UITraitEnvironment {
    
    var traitCollection = UITraitCollection()
    
    func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
    }
}
