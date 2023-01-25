//
//  CalendarContentTest.swift
//  SharePlannerTests
//
//  Created by 이아연 on 2022/12/28.
//

import XCTest
import RxSwift
import RxTest
@testable import SharePlanner

final class CalendarContentTest: XCTestCase {
    
    var sut: CalendarContentVC!
    var reactor: CalendarContentReactor!

    override func setUpWithError() throws {
        try super.setUpWithError()
        reactor = CalendarContentReactor(yearMonth: YearMonth(date:  Date()))
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        reactor = nil
        sut = nil
    }
    
    //MARK: - State -> View Testing
    func test_setYearMonth_Action을발생시켰을때_CalendarView의_presentYM에_반영되는지() {
        //given
        sut = (Scene.calendar(reactor).instantiate() as! CalendarContentVC)
        let inputYM = YearMonth(year: 2023, month: .aug)
        
        //when
        sut.reactor.action.onNext(.setYearMonth(inputYM))
        
        //then
        XCTAssertEqual(sut.calendarView.presentYM, inputYM)
    }
    
    //MARK: - Action -> State Testing
    func test_setYearMonth_Action을발생시켰을때_State의yearMonth가_변경되는지() {
        //given
        sut = (Scene.calendar(reactor).instantiate() as! CalendarContentVC)
        let inputYM = YearMonth(year: 2025, month: .dec)
        
        //when
        sut.reactor.action.onNext(.setYearMonth(inputYM))
        
        //then
        XCTAssertEqual(reactor.currentState.yearMonth, inputYM)
    }

    func test_setSelectDefault_Action을발생시켰을때_State의_shouldUpdateDefaultSelect가_true였다가_nil로_바뀌는지() {
        //given
        let scheduler = TestScheduler(initialClock: 0)
        let disposeBag = DisposeBag()
        
        //when
        scheduler
            .createHotObservable([
                .next(100, .setSelectDefault)
            ])
            .subscribe(reactor.action)
            .disposed(by: disposeBag)
        
        //then
        let response = scheduler.start(created: 0, subscribed: 0, disposed: 101) {
            self.reactor.state.map(\.shouldUpdateDefaultSelect)
        }
        
        XCTAssertEqual(response.events.compactMap(\.value.element), [
            nil,  // initial state
            true, // just after .setSelectDefault
            nil   // after setSelectDefault
        ])
    }
    
    func test_deselectCell_Action을발생시켰을때_State의_shouldUpdateDefaultSelect가_false였다가_nil로_바뀌는지() {
        //given
        let scheduler = TestScheduler(initialClock: 0)
        let disposeBag = DisposeBag()
        
        //when
        scheduler
            .createHotObservable([
                .next(100, .deselectCell)
            ])
            .subscribe(reactor.action)
            .disposed(by: disposeBag)
        
        //then
        let response = scheduler.start(created: 0, subscribed: 0, disposed: 101) {
            self.reactor.state.map(\.shouldUpdateDefaultSelect)
        }
        
        XCTAssertEqual(response.events.compactMap(\.value.element), [
            nil,
            false,
            nil
        ])
    }
    
    func test_showAlert_Action을발생시켰을때_State의_showAlertWithMsg가_주입된String이였다가_nil로_바뀌는지() {
        //given
        let scheduler = TestScheduler(initialClock: 0)
        let disposeBag = DisposeBag()
        let inputMsg = "TestMessage"
        
        //when
        scheduler
            .createHotObservable([
                .next(100, .showAlert(inputMsg))
            ])
            .subscribe(reactor.action)
            .disposed(by: disposeBag)
        
        //then
        let response = scheduler.start(created: 0, subscribed: 0, disposed: 101) {
            self.reactor.state.map(\.showAlertWithMsg)
        }
        
        XCTAssertEqual(response.events.compactMap(\.value.element), [
            nil,
            inputMsg,
            nil
        ])
    }
    
}
