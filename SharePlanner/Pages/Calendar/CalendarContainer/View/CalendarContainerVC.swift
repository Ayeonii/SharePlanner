//
//  CalendarContainerViewController.swift
//  SharePlanner
//
//  Created by Ayeon on 2022/12/22.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import SnapKit
import Then

class CalendarContainerVC: BaseViewController<CalendarContainerReactor> {
    
    lazy var vcArray: [UIViewController] = {
        let currentYM = state.currentYM
        let prevReactor = CalendarContentReactor(yearMonth: currentYM.getPrevYM())
        let currentReactor = CalendarContentReactor(yearMonth: currentYM)
        let nextReactor = CalendarContentReactor(yearMonth: currentYM.getNextYM())
    
        return [Scene.calendar(prevReactor).instantiate(),
                Scene.calendar(currentReactor).instantiate(),
                Scene.calendar(nextReactor).instantiate()]
    }()
    
    lazy var pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal).then {
        $0.delegate = self
        $0.dataSource = self
    }

    var backgroundImage = UIImageView().then {
        $0.image = UIImage(named: "backgroundImage2")
    }
    
    var topNaviView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    var menuBtn = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "menuIcon"), for: .normal)
    }
    
    var monthBtn = UIButton().then {
        $0.setTitle("DECEMBER", for: .normal)
        $0.titleLabel?.font = .appFont(size: 50)
        $0.setTitleColor(.black, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupPageController()
    }
    
    override func configureLayout() {
        self.view.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.setupTopViewLayout()
        self.setupPageControllerLayout()
    }
    
    func bindAction(_ reactor: CalendarContainerReactor) {
        
    }
    
    func bindState(_ reactor: CalendarContainerReactor) {
        
    }
}

extension CalendarContainerVC {
    func setupTopViewLayout() {
        self.view.addSubview(topNaviView)
        self.topNaviView.addSubview(menuBtn)
        self.topNaviView.addSubview(monthBtn)
        
        topNaviView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(52)
        }
        
        menuBtn.snp.makeConstraints {
            $0.height.width.equalTo(24)
            $0.left.equalToSuperview().offset(15)
            $0.centerY.equalToSuperview()
        }
        
        monthBtn.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalTo(180)
        }
    }
    
    func setupPageController() {
        pageController.setViewControllers([vcArray[1]], direction: .forward, animated: true)
    }
    
    func setupPageControllerLayout() {
        self.addChild(pageController)
        self.view.addSubview(pageController.view)
        self.topNaviView.layer.zPosition = 1
        
        pageController.view.snp.makeConstraints {
            $0.top.equalTo(topNaviView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        pageController.didMove(toParent: self)
    }

}

extension CalendarContainerVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = vcArray.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1

        log.debug("이전달", state.currentYM.getPrevYM())
        if previousIndex < 0 {
            guard let vc = vcArray.last as? CalendarContentVC else { return nil }
            vc.reactor.action.onNext(.setYearMonth(state.currentYM.getPrevYM()))
            return vc
        } else {
            guard let vc = vcArray[previousIndex] as? CalendarContentVC else { return nil }
            vc.reactor.action.onNext(.setYearMonth(state.currentYM.getPrevYM()))
            return vc
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = vcArray.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
       
        log.debug("다음달", state.currentYM.getNextYM())
        if nextIndex > vcArray.count - 1 {
            guard let vc = vcArray.first as? CalendarContentVC else { return nil }
            vc.reactor.action.onNext(.setYearMonth(state.currentYM.getNextYM()))
            return vc
        } else {
            guard let vc = vcArray[nextIndex] as? CalendarContentVC else { return nil }
            vc.reactor.action.onNext(.setYearMonth(state.currentYM.getNextYM()))
            return vc
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished, completed {
            if let dates = pageViewController.viewControllers?.first as? CalendarContentVC {
                let currentYM = dates.reactor.currentState.yearMonth
                log.debug("finished current: ->", dates.reactor.currentState.yearMonth)
                self.monthBtn.setTitle("\(currentYM.month.getEngName())", for: .normal)
                self.reactor.action.onNext(.changeCurrentYM(currentYM))
            }
        }
    }
}
