//
//  InputGenderRIBTests.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/7/25.
//

@testable import FeatureOnboarding

import XCTest



class InputGenderRIBTestCase: XCTestCase {
    
    
    func test_buttonIsEnabled() {
        
        // Given
        let presenter = InputGenderViewController()
        let interactor = InputGenderInteractor(presenter: presenter)
        presenter.loadView()
        XCTAssertFalse(presenter.mainView.ctaButton.isEnabled)
        
        // When
        presenter.action(.selectedGender(.male))
        
        
        // Then
        XCTAssertTrue(presenter.mainView.ctaButton.isEnabled)
    }
}
