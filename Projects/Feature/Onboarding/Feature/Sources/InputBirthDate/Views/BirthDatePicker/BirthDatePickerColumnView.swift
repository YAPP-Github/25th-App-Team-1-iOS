//
//  BirthDatePickerColumnView.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/8/25.
//

import UIKit

import FeatureResources

import Then
import SnapKit
import RxSwift
import RxRelay

final class BirthDatePickerColumnView: UIView, UIScrollViewDelegate {
    
    typealias Content = String
    
    // Sub view
    private var scrollView: UIScrollView!
    private var itemViews: [Content: BirthDatePickerItemView] = [:]
    private var orderedItemViews: [BirthDatePickerItemView] = []
    private lazy var itemStackView: UIStackView = .init().then {
        $0.axis = .vertical
        $0.spacing = self.itemSpacing
        $0.distribution = .fill
    }
    
    
    // Model
    private var items: [BirthDaySelectionItem]
    
    
    // Feedback generator
    private let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
    
    
    // View data
    private let itemSpacing: CGFloat
    private var viewSize: CGSize?
    private var mostAdjacentView: UIView?
    
    
    // Observable
    fileprivate let changeContent: BehaviorRelay<Content?> = .init(value: nil)
    fileprivate let currentSelectedContent: BehaviorRelay<Content?> = .init(value: nil)
    private let layoutSubViews: BehaviorSubject<Void?> = .init(value: nil)
    private let disposeBag = DisposeBag()
    
    override var intrinsicContentSize: CGSize {
        viewSize ?? super.intrinsicContentSize
    }
    
    
    init(itemSpacing: CGFloat, items: [BirthDaySelectionItem]) {
        
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
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutSubViews.onNext(())
    }
    
    
    private func setupUI() {
        
        self.backgroundColor = .clear
    }
    
    
    private func createItemViews() {
        
        let itemViews = self.items.map { selectionItem in
            
            let itemView = createItemView(item: selectionItem)
            self.itemViews[selectionItem.content] = itemView
            
            return itemView
        }
        
        self.orderedItemViews = itemViews
        
        orderedItemViews.forEach {
            itemStackView.addArrangedSubview($0)
        }
    }
    
    
    private func createItemView(item: BirthDaySelectionItem) -> BirthDatePickerItemView {
        
        BirthDatePickerItemView(
            content: item.content,
            viewSize: item.contentSize
        )
        .update(titleLabelText: item.displayingText)
        .update(titleLabelConfig: .init(
            font: .title2SemiBold,
            textColor: R.Color.white100
        ))
    }
    
    
    private func setupLayout() {
        
        // self
        if items.count == 2 {
            
            let cellSize = items.first!.contentSize
            let height = (cellSize.height * 3) + (itemSpacing * 2)
            
            viewSize = .init(
                width: cellSize.width,
                height: height
            )
            
        } else if items.count >= 3 {
            
            let cellSize = items.first!.contentSize
            let height = (cellSize.height * 5) + (itemSpacing * 4)
            
            viewSize = .init(
                width: cellSize.width,
                height: height
            )
            
        } else {
            fatalError("아이템은 2개이상이 필요합니다.")
        }
        
        
        // Scroll view
        let scrollView = createScrollView()
        scrollView.addSubview(itemStackView)
        
        let contentGuide = scrollView.contentLayoutGuide.snp
        let frameGuide = scrollView.frameLayoutGuide.snp
        
        
        var verticalInset: CGFloat = 0
        
        if items.count == 2 {
            
            let cellSize = items.first!.contentSize
            verticalInset = cellSize.height + itemSpacing
            
        } else if items.count >= 3 {
            
            let cellSize = items.first!.contentSize
            verticalInset = (cellSize.height * 2) + (itemSpacing * 2)
        }
        
        
        itemStackView.snp.makeConstraints { make in
            
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
        Observable
            .combineLatest(
                changeContent.compactMap({ $0 }),
                layoutSubViews.take(1)
            )
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] content, _ in
                guard let self else { return }
                    
                scrollView.isScrollEnabled = false
                defer {
                    scrollView.isScrollEnabled = true
                }
                
                
                // 지정한 아이템이 없는 경우 가장 마지막 아이템으로 이동
                if let selectedView = self.itemViews[content] {
                    
                    self.mostAdjacentView = selectedView
                    
                } else {
                    
                    self.mostAdjacentView = self.orderedItemViews.last!
                }
                
                scrollToAdjacentItem(scrollView, animated: false)
                
                // publish state
                let itemView = itemViews[content]!
                currentSelectedContent.accept(itemView.content)
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
    
    
    public func updateCellUI(_ closure: @escaping (BirthDatePickerItemView) -> ()) {
        
        self.orderedItemViews.forEach { itemView in
            
            closure(itemView)
        }
    }
    
    
    private func findMostAdjacentViewFromCenter() -> BirthDatePickerItemView {
        
        var minDistance: CGFloat = .infinity
        var currentAdjacentView: BirthDatePickerItemView!
        
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


// MARK: Public interface
extension BirthDatePickerColumnView {
    
    func update(items updatedItems: [BirthDaySelectionItem]) {
        
        // self
        if updatedItems.count == 2 {
            
            let cellSize = updatedItems.first!.contentSize
            let height = (cellSize.height * 3) + (itemSpacing * 2)
            
            viewSize = .init(
                width: cellSize.width,
                height: height
            )
            self.invalidateIntrinsicContentSize()
            
        } else if updatedItems.count >= 3 {
            
            let cellSize = updatedItems.first!.contentSize
            let height = (cellSize.height * 5) + (itemSpacing * 4)
            
            viewSize = .init(
                width: cellSize.width,
                height: height
            )
            self.invalidateIntrinsicContentSize()
            
        } else {
            fatalError("아이템은 2개이상이 필요합니다.")
        }
        
        let currentItemArrSize = self.items.count
        let newItemArrSize = updatedItems.count
        var newItemViewDictionary: [Content: BirthDatePickerItemView] = [:]
        
        if currentItemArrSize <= newItemArrSize {
            
            // 기존뷰가 업데이트 하려는 뷰의 수와 같거나 다를 때
            
            // #1. 기존의 아이템 업데이트
            for index in 0..<currentItemArrSize {
                
                let newItem = updatedItems[index]
                
                let updatedView = self.orderedItemViews[index]
                    .update(content: newItem.content)
                    .update(viewSize: newItem.contentSize)
                    .update(titleLabelText: newItem.displayingText)
                
                newItemViewDictionary[newItem.content] = updatedView
            }
            
            // #2. 새로운 뷰 추가(기존 뷰가 적은 경우)
            for index in currentItemArrSize..<newItemArrSize {
                
                let newItem = updatedItems[index]
                
                let newItemView = createItemView(item: newItem)
                
                itemStackView.addArrangedSubview(newItemView)
                orderedItemViews
                    .append(newItemView)
                
                newItemViewDictionary[newItem.content] = newItemView
            }
            
        } else {
            
            // 기존 뷰가 업데이트 하려는 뷰보다 수가 많아 삭제가 필요
            
            // #1. 기존의 아이템 업데이트
            for index in 0..<newItemArrSize {
                
                let newItem = updatedItems[index]
                
                let updatedView = self.orderedItemViews[index]
                    .update(content: newItem.content)
                    .update(viewSize: newItem.contentSize)
                    .update(titleLabelText: newItem.displayingText)
                
                newItemViewDictionary[newItem.content] = updatedView
            }
            
            // #1. 불필요 아이템 삭제
            for index in newItemArrSize..<currentItemArrSize {
                
                let needToRemoveItem = self.orderedItemViews[index]
                needToRemoveItem.removeFromSuperview()
            }
            let removeIndexSet = IndexSet(newItemArrSize..<currentItemArrSize)
            self.orderedItemViews.remove(atOffsets: removeIndexSet)
            
            
        }
        
        self.items = updatedItems
        self.itemViews = newItemViewDictionary
        self.setNeedsLayout()
    }
}


// MARK: UIScrollViewDelegate
extension BirthDatePickerColumnView {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // #1. 중심과 가장 가까운 뷰를 색출
        let currentAdjacentView = findMostAdjacentViewFromCenter()
        
        
        // #2. 가장가까운 뷰가 변경되었는지 확인
        let prevAdjacentView = mostAdjacentView
        
        if currentAdjacentView !== prevAdjacentView {
            
            // 중심에 가장 인접한 뷰가 변경된 경우
            
            let currentItemContent = currentAdjacentView.content
            self.currentSelectedContent.accept(currentItemContent)
            self.mostAdjacentView = currentAdjacentView
            
            
            // 피드백 전송
            self.selectionFeedbackGenerator.selectionChanged()
            
            
            /*
            if #available(iOS 17.5, *) {
                let centerOfView: CGPoint = .init(
                    x: self.bounds.width/2,
                    y: self.bounds.height/2
                )
                self.selectionFeedbackGenerator.selectionChanged(at: centerOfView)
            } else {
                self.selectionFeedbackGenerator.selectionChanged()
            }
             */
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
            let cellSize = items.first!.contentSize
            emptySpaceHeight = cellSize.height + itemSpacing
        } else if items.count >= 3 {
            let cellSize = items.first!.contentSize
            emptySpaceHeight = (cellSize.height * 2) + (itemSpacing * 2)
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
extension Reactive where Base == BirthDatePickerColumnView {
    
    var selectedContent: Observable<String> {
        base.currentSelectedContent.compactMap({ $0 })
    }
    
    var setContent: BehaviorRelay<String?> {
        base.changeContent
    }
}


#Preview {
    
    let view = BirthDatePickerColumnView(
        itemSpacing: 18,
        items: [
            BirthDaySelectionItem(
                content: "12",
                displayingText: "12",
                contentSize: .init(width: 48, height: 48)
            ),
            BirthDaySelectionItem(
                content: "12",
                displayingText: "12",
                contentSize: .init(width: 48, height: 48)
            ),
            BirthDaySelectionItem(
                content: "12",
                displayingText: "12",
                contentSize: .init(width: 48, height: 48)
            ),
            BirthDaySelectionItem(
                content: "12",
                displayingText: "12",
                contentSize: .init(width: 48, height: 48)
            ),
            BirthDaySelectionItem(
                content: "12",
                displayingText: "12",
                contentSize: .init(width: 48, height: 48)
            ),
        ]
    )
    
    return view
}
