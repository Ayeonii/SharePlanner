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
    
    let floatingButton = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "plusCircle"), for: .normal)
    }
    
    var yearLabel = UILabel().then {
        $0.text = "\(Date().year)"
        $0.textAlignment = .center
        $0.font = .appFont(size: 22)
        $0.textColor = .black
    }
    
    var monthBtn = UIButton().then {
        $0.setTitle(Date().monthType.getEngName(), for: .normal)
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
    
    override func configureLayer() {
        self.floatingButton.layer.cornerRadius = self.floatingButton.bounds.height / 2
    }
    
    func bindAction(_ reactor: CalendarContainerReactor) {
        menuBtn.rx.tap
            .map{ CalendarContainerReactor.Action.showSideMenu }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        floatingButton.rx.tap
            .compactMap{ [weak self] in
                guard let self = self,
                      let currentVC = self.pageController.viewControllers?.first as? CalendarContentVC else { return nil }
                
                return CalendarContainerReactor.Action.showRegister(currentVC.state.yearMonth)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
    
    func bindState(_ reactor: CalendarContainerReactor) {
        reactor.state
            .filter{ $0.shouldShowSideMenu }
            .asDriver{ _ in .never() }
            .drive(onNext: {[weak self] _ in
                self?.showSideMenu()
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap{ $0.registerDate }
            .asDriver{ _ in .never() }
            .drive(onNext: { [weak self] date in
                self?.showRegisterCalendar(date: date)
            })
            .disposed(by: disposeBag)
    }
}

extension CalendarContainerVC {
    func setupTopViewLayout() {
        self.view.addSubview(topNaviView)
        self.pageController.view.addSubview(floatingButton)
        self.topNaviView.addSubview(menuBtn)
        self.topNaviView.addSubview(yearLabel)
        self.topNaviView.addSubview(monthBtn)
        
        
        topNaviView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(52)
        }
        
        floatingButton.snp.makeConstraints {
            $0.width.height.equalTo(53)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-55)
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
        
        yearLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(180)
            $0.top.equalToSuperview().offset(-5)
            $0.bottom.equalTo(monthBtn.snp.top).offset(12)
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
            if let currentVC = pageViewController.viewControllers?.first as? CalendarContentVC {
                let currentYM = currentVC.reactor.currentState.yearMonth
                self.yearLabel.text = "\(currentYM.year)"
                self.monthBtn.setTitle("\(currentYM.month.getEngName())", for: .normal)
                self.reactor.action.onNext(.changeCurrentYM(currentYM))
                currentVC.reactor.action.onNext(.setSelectDefault)
            }
        }
    }
}

extension CalendarContainerVC {
    func showSideMenu() {
        let reactor = SideMenuReactor()
        self.transition(to: .sideMenu(reactor), using: .dimmPresent(from: .left, dimmColor: UIColor.black.withAlphaComponent(0.2)), animated: true)
    }
    
    func showRegisterCalendar(date: YearMonth) {
        let reactor = CalendarRegisterReactor(ym: date)
        self.transition(to: .calendarRegister(reactor), using: .present, animated: true)
    }
}
