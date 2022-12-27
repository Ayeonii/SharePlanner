//
//  SharePlannerTests.swift
//  SharePlannerTests
//
//  Created by 이아연 on 2022/12/18.
//

import XCTest
@testable import SharePlanner

final class CalendarContainerTests: XCTestCase {

    var sut: CalendarContainerVC!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let reactor = CalendarContainerReactor()
        sut = (Scene.calendarContainer(reactor).instantiate() as! CalendarContainerVC)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_ym을변경했을때_input값이_reactor의state로_잘적용되는지() {
        //given
        let inputYM = YearMonth(year: 2023, month: .fab)
        
        //when
        sut.reactor.action.onNext(.changeCurrentYM(inputYM))
        
        //then
        XCTAssertEqual(sut.reactor.currentState.currentYM, inputYM)
    }

}
