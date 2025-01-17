//
//  OnboardingViewController.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 14.01.25.
//
import UIKit
import Combine

final class OnboardingViewController: UIPageViewController {
    private var pages: [UIViewController] = {
        let pages = [
            DemoViewController(
                imageName: GreetingImages.FirstGreeting,
                titleText: OnboardingTexts.firstPageTitle,
                pageDescription: OnboardingTexts.firstPageDescription),
            DemoViewController(
                imageName: GreetingImages.SecondGreeting,
                titleText: OnboardingTexts.secondPageTitle,
                pageDescription: OnboardingTexts.secondPageDescription),
            DemoViewController(
                imageName: GreetingImages.ThirdGreeting,
                titleText: OnboardingTexts.thirdPageTitle,
                pageDescription: OnboardingTexts.thirdPageDescription)
        ]
        return pages
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(.accentBlack, for: .normal)
        button.titleLabel?.font = UIFont(name: CustomFonts.nutinoBold, size: 18)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.accentRed, for: .normal)
        button.titleLabel?.font = UIFont(name: CustomFonts.nutinoBold, size: 18)
        return button
    }()
    
    private let previousButton: UIButton = {
        let button = UIButton()
        button.setTitle("Prev", for: .normal)
        button.setTitleColor(.customGray, for: .normal)
        button.titleLabel?.font = UIFont(name: CustomFonts.nutinoBold, size: 18)
        return button
    }()
    
    private let currentPageLabel = UILabel()
    
    private let pageControl = UIPageControl()
    private var currentPage = CurrentValueSubject<Int, Never>(0)
    
    private var subscriptions = Set<AnyCancellable>()
    var doneRequested: () -> Void
    
    init(doneRequested: @escaping () -> Void) {
        self.doneRequested = doneRequested
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        view.backgroundColor = .customWhite
        setupPageControl()
        setupButtons()
        setupCurrentPageLabel()
        setupPageControlStyle()
        setupConstraints()
    }
    
    private func setupBindings() {
        currentPage
            .sink { [weak self] page in
                let newTitle = page == 2 ? "Get Started" : "Next"
                self?.nextButton.setTitleWithAnimation(newTitle)
            }
            .store(in: &subscriptions)
        
        currentPage
            .sink { [weak self] page in
                if page == 0 {
                    self?.previousButton.dissapearWithAnimation()
                } else {
                    self?.previousButton.apearWithAnimation()
                }
            }
            .store(in: &subscriptions)
        
        currentPage
            .sink { [weak self] page in
                let pageText = "\(page + 1)/3"
                let attributedText = NSMutableAttributedString(string: pageText)
                attributedText.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: 1))
                self?.currentPageLabel.attributedText = attributedText
            }
            .store(in: &subscriptions)
    }
    
    private func setupPageControl() {
        delegate = self
        dataSource = self
        
        setViewControllers([pages[0]], direction: .forward, animated: true)
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
    }
    
    private func setupButtons() {
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(previousTapped), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
    }
    
    private func setupCurrentPageLabel() {
        currentPageLabel.font = UIFont(name: CustomFonts.nutinoMedium, size: 18)
        currentPageLabel.textColor = .customGray
    }
    
    private func setupPageControlStyle() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .accentRed
        pageControl.pageIndicatorTintColor = .customGray
        pageControl.numberOfPages = pages.count
    }
    
    private func setupConstraints() {
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        previousButton.translatesAutoresizingMaskIntoConstraints = false
        currentPageLabel.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(skipButton)
        view.addSubview(nextButton)
        view.addSubview(previousButton)
        view.addSubview(currentPageLabel)
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            skipButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            previousButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            previousButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            
            currentPageLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            currentPageLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func nextTapped() {
        guard pageControl.currentPage < pages.count - 1 else {
            doneRequested()
            return
        }
        pageControl.currentPage += 1
        currentPage.send(pageControl.currentPage)
        goToNextPage()
    }
    
    @objc private func previousTapped() {
        guard pageControl.currentPage > 0 else { return }
        pageControl.currentPage -= 1
        currentPage.send(pageControl.currentPage)
        goToPreviousPage()
    }
    
    @objc private func skipTapped() {
        doneRequested()
        print("presssseeeeeddddd")
        print()
    }
    
    private func goToNextPage() {
        let nextPage = pages[pageControl.currentPage]
        setViewControllers([nextPage], direction: .forward, animated: true)
    }
    
    private func goToPreviousPage() {
        let previousPage = pages[pageControl.currentPage]
        setViewControllers([previousPage], direction: .reverse, animated: true)
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        guard currentIndex != 0 else { return nil }
        
        let previousIndex = currentIndex - 1
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        guard currentIndex != pages.count - 1 else { return nil }
        
        let nextIndex = currentIndex + 1
        return pages[nextIndex]
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
       func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
           
           guard let viewControllers = pageViewController.viewControllers else { return }
           guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
           
           currentPage.send(currentIndex)
           pageControl.currentPage = currentIndex
       }
}


extension OnboardingViewController {
    @objc func pageControlTapped(_ sender: UIPageControl) {
        setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true)
    }
}
