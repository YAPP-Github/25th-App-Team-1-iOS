//
//  AlarmPickerColumnView.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/4/25.
//

import UIKit

import FeatureThirdPartyDependencies
import RxSwift
import RxRelay

final class AlarmPickerColumnView: UIView, UIScrollViewDelegate {
    struct Constant {
        static let cellSize = CGSize(width: 48, height: 48)
    }
    
    typealias Content = String
    
    // Sub view
    private var scrollView: UIScrollView!
    private var itemViews: [Content: AlarmPickerItemView] = [:]
    private var orderedItemViews: [AlarmPickerItemView] = []
    
    
    // Model
    private let items: [PickerSelectionItemable]
    
    
    // Feedback generator
    private let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    
    
    // View data
    private let itemSpacing: CGFloat
    private var viewSize: CGSize?
    private var mostAdjacentView: UIView?
    
    
    // Observable
    fileprivate let changeContent: BehaviorRelay<Content?> = .init(value: nil)
    fileprivate let currentSelectedItem: BehaviorRelay<PickerSelectionItemable?> = .init(value: nil)
    private let disposeBag = DisposeBag()
    
    override var intrinsicContentSize: CGSize {
        viewSize ?? super.intrinsicContentSize
    }
    
    
    init(itemSpacing: CGFloat, items: [PickerSelectionItemable]) {
        
        self.itemSpacing = itemSpacing
        self.items = items
        
        super.init(frame: .zero)
        
        createItemViews()
        
        setupUI()
        setupLayout()
        setReactive()
        
        self.selectionFeedbackGenerator.prepare()
    }
    
    required init?(coder: NSCoder) { nil }
    
    
    private func setupUI() {
        
        self.backgroundColor = .clear
    }
    
    
    private func createItemViews() {
        
        let itemViews = self.items.map { selectionItem in
            
            let itemView = AlarmPickerItemView(item: selectionItem)
            self.itemViews[selectionItem.content] = itemView
            
            return itemView
        }
        
        self.orderedItemViews = itemViews
    }
    
    
    private func setupLayout() {
        
        // self
        if items.count == 2 {
            let height = (Constant.cellSize.height * 3) + (itemSpacing * 2)
            
            viewSize = .init(
                width: Constant.cellSize.width,
                height: height
            )
            
        } else if items.count >= 3 {
            let height = (Constant.cellSize.height * 5) + (itemSpacing * 4)
            
            viewSize = .init(
                width: Constant.cellSize.width,
                height: height
            )
            
        } else {
            fatalError("아이템은 2개이상이 필요합니다.")
        }
        
        
        // Scroll view
        let stackView: UIStackView = .init(arrangedSubviews: orderedItemViews)
        stackView.axis = .vertical
        stackView.spacing = self.itemSpacing
        stackView.distribution = .fill
        
        
        let scrollView = createScrollView()
        scrollView.addSubview(stackView)
        
        let contentGuide = scrollView.contentLayoutGuide.snp
        let frameGuide = scrollView.frameLayoutGuide.snp
        
        
        var verticalInset: CGFloat = 0
        
        if items.count == 2 {
            verticalInset = Constant.cellSize.height + itemSpacing
        } else if items.count >= 3 {
            verticalInset = (Constant.cellSize.height * 2) + (itemSpacing * 2)
        }
        
        
        stackView.snp.makeConstraints { make in
            
            make.verticalEdges.equalTo(contentGuide.verticalEdges).inset(verticalInset)
            make.horizontalEdges.equalTo(contentGuide.horizontalEdges)
            make.width.equalTo(frameGuide.width)
        }
        
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            
            make.edges.equalToSuperview()
        }
        
        self.scrollView = scrollView
    }
    
    
    private func setReactive() {
        // changeContent
        changeContent
            .compactMap({ $0 })
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] content in
                guard let self else { return }
                    
                scrollView.isScrollEnabled = false
                defer {
                    scrollView.isScrollEnabled = true
                }
                mostAdjacentView = self.itemViews[content]!
                scrollToAdjacentItem(scrollView, animated: false)
                
                // publish state
                let itemView = itemViews[content]!
                currentSelectedItem.accept(itemView.selectionItem)
            })
            .disposed(by: disposeBag)
    }
    
    
    private func createScrollView() -> UIScrollView {
        
        let scrollView: UIScrollView = .init()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.delegate = self
        return scrollView
    }
    
    
    public func updateCellUI(_ closure: @escaping (AlarmPickerItemView) -> ()) {
        
        self.orderedItemViews.forEach { itemView in
            
            closure(itemView)
        }
    }
    
    
    private func findMostAdjacentViewFromCenter() -> AlarmPickerItemView {
        
        var minDistance: CGFloat = .infinity
        var currentAdjacentView: AlarmPickerItemView!
        
        for itemView in orderedItemViews {
            
            let itemViewFrameOnSelf = itemView.convert(itemView.bounds, to: self)
            let inset = (bounds.height - itemView.bounds.height) / 2
            let distance = abs(itemViewFrameOnSelf.minY-inset)
            
            if minDistance > distance {
                
                // 현재 가장 가까운 뷰를 도출
                minDistance = distance
                currentAdjacentView = itemView
            }
        }
        
        return currentAdjacentView
    }
}


// MARK: UIScrollViewDelegate
extension AlarmPickerColumnView {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // #1. 중심과 가장 가까운 뷰를 색출
        let currentAdjacentView = findMostAdjacentViewFromCenter()
        
        
        // #2. 가장가까운 뷰가 변경되었는지 확인
        let prevAdjacentView = mostAdjacentView
        
        if currentAdjacentView !== prevAdjacentView {
            
            // 중심에 가장 인접한 뷰가 변경된 경우
            
            let currentItem = currentAdjacentView.selectionItem
            self.currentSelectedItem.accept(currentItem)
            self.mostAdjacentView = currentAdjacentView
            
            
            // 피드백 전송
            self.selectionFeedbackGenerator.selectionChanged()
        }
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        scrollToAdjacentItem(scrollView)
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate { scrollToAdjacentItem(scrollView) }
    }
    
    
    func scrollToAdjacentItem(_ scrollView: UIScrollView, animated: Bool = true) {
        
        guard let mostAdjacentView else { return }
        
        let itemViewYPos = mostAdjacentView.frame.minY
        
        var emptySpaceHeight: CGFloat = 0
        if items.count == 2 {
            emptySpaceHeight = Constant.cellSize.height + itemSpacing
        } else if items.count >= 3 {
            emptySpaceHeight = (Constant.cellSize.height * 2) + (itemSpacing * 2)
        } else {
            fatalError("아이템은 2개이상이 필요합니다.")
        }
        
        let inset = (bounds.height - mostAdjacentView.bounds.height)/2
        let willMoveScrollAmount = (itemViewYPos - inset) + emptySpaceHeight
        
        UIView.animate(withDuration: animated ? 0.2 : 0.0) {
            scrollView.setContentOffset(
                .init(x: 0, y: willMoveScrollAmount),
                animated: false
            )
        }
    }
}


// MARK: Reactive
extension Reactive where Base == AlarmPickerColumnView {
    
    var selectedItem: Observable<PickerSelectionItemable> {
        base.currentSelectedItem.compactMap({ $0 })
    }
    
    var setContent: BehaviorRelay<String?> {
        base.changeContent
    }
}
