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
    var reactor: CalendarContainerReactor!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        reactor = CalendarContainerReactor()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        reactor = nil
        sut = nil
    }
    
    //MARK: - View -> Action Testing
    func test_MenuButton_클릭시_showSideMenu_Action이_잘_전달되는지() {
        //given
        reactor.isStubEnabled = true
        sut = (Scene.calendarContainer(reactor).instantiate() as! CalendarContainerVC)
        
        //when
        sut.menuBtn.sendActions(for: .touchUpInside)
        
        //then
        XCTAssertEqual(reactor.stub.actions.last, .showSideMenu)
    }
    
    //MARK: - Action -> State Testing
    func test_ym을변경했을때_input값이_reactor의state로_잘적용되는지() {
        //given
        let inputYM = YearMonth(year: 2023, month: .fab)
        
        //when
        reactor.action.onNext(.changeCurrentYM(inputYM))
        
        //then
        XCTAssertEqual(reactor.currentState.currentYM, inputYM)
    }
}
