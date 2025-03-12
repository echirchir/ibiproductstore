//
//  LoginViewModelTests.swift
//  IBI Products StoreTests
//
//  Created by Elisha Chirchir on 12/03/2025.
//

import XCTest
@testable import IBI_Products_Store

final class LoginViewModelTests: XCTestCase {
    var viewModel: LoginViewModel!

    override func setUp() {
        super.setUp()
        viewModel = LoginViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    func testValidCredentials() {
        // Given
        let username = "admin"
        let password = "testPassword2025"

        // When
        let isValid = viewModel.validateCredentials(username: username, password: password)

        // Then
        XCTAssertTrue(isValid, "Valid credentials should return true")
    }

    func testInvalidUsername() {
        // Given
        let username = "wrongUser"
        let password = "testPassword123"

        // When
        let isValid = viewModel.validateCredentials(username: username, password: password)

        // Then
        XCTAssertFalse(isValid, "Invalid username should return false")
    }

    func testInvalidPassword() {
        // Given
        let username = "testUser"
        let password = "wrongPassword"

        // When
        let isValid = viewModel.validateCredentials(username: username, password: password)

        // Then
        XCTAssertFalse(isValid, "Invalid password should return false")
    }

    func testEmptyCredentials() {
        // Given
        let username = ""
        let password = ""

        // When
        let isValid = viewModel.validateCredentials(username: username, password: password)

        // Then
        XCTAssertFalse(isValid, "Empty credentials should return false")
    }
}
