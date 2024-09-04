//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Bakyt Temishov on 20.08.2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    
    func testViewControllerLight() throws {
        let vc = TrackersViewController()
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
    }
    
    func testViewControllerDark() throws {
        let vc = TrackersViewController()
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
    
    override func setUpWithError() throws {}
    
    override func tearDownWithError() throws {}
    
    func testExample() throws {}
    
    func testPerformanceExample() throws {
        measure {}
    }
    
}
