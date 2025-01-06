//
//  AlarmPickerColumnView.swift
//  FeatureOnboarding
//
//  Created by choijunios on 1/4/25.
//

import UIKit

import SnapKit

protocol SelectionItemRepresentable: UIView {
    
    init()
    
    func update(selectionItem: SelectionItem)
}


class AlarmPickerColumnView: UIView, UIScrollViewDelegate {
    
    // Sub view
    private var itemViews: [AlarmPickerItemView] = []
    
    
    // Model
    private let items: [SelectionItem]
    
    
    // View data
    private let itemSpacing: CGFloat
    private var viewSize: CGSize?
    
    
    override var intrinsicContentSize: CGSize {
        viewSize ?? super.intrinsicContentSize
    }
    
    
    init(itemSpacing: CGFloat, items: [SelectionItem]) {
        
        self.itemSpacing = itemSpacing
        self.items = items
        
        super.init(frame: .zero)
        
        createItemViews()
        
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) { nil }
    
    
    private func setupUI() {
        
    }
    
    
    private func createItemViews() {
        
        let itemViews = self.items.map { selectionItem in
            
            AlarmPickerItemView(item: selectionItem)
        }
        
        self.itemViews = itemViews
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
        let stackView: UIStackView = .init(arrangedSubviews: itemViews)
        stackView.axis = .vertical
        stackView.spacing = self.itemSpacing
        stackView.distribution = .fill
        
        
        let scrollView = createScrollView()
        scrollView.addSubview(stackView)
        
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
        
        
        stackView.snp.makeConstraints { make in
            
            make.verticalEdges.equalTo(contentGuide.verticalEdges).inset(verticalInset)
            make.horizontalEdges.equalTo(contentGuide.horizontalEdges)
            make.width.equalTo(frameGuide.width)
        }
        
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            
            make.edges.equalToSuperview()
        }
    }
    
    
    private func createScrollView() -> UIScrollView {
        
        let scrollView: UIScrollView = .init()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.delegate = self
        return scrollView
    }
    
    
    public func updateCellUI(_ closure: @escaping (AlarmPickerItemView) -> ()) {
        
        itemViews.forEach { itemView in
            
            closure(itemView)
        }
    }
    
    var asd: Bool = true
}


// MARK: UIScrollViewDelegate
extension AlarmPickerColumnView {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        scrollToAdjacentItem(scrollView)
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate { scrollToAdjacentItem(scrollView) }
    }
    
    
    func scrollToAdjacentItem(_ scrollView: UIScrollView) {
        
        var adjacentView: UIView!
        var minDistance: CGFloat = .infinity
        
        for itemView in itemViews {
            
            let itemViewFrameOnSelf = itemView.convert(itemView.bounds, to: self)
            let inset = (bounds.height - itemView.bounds.height) / 2
            let distance = abs(itemViewFrameOnSelf.minY-inset)
            
            if minDistance > distance {
                
                minDistance = distance
                adjacentView = itemView
            }
        }
        
        let itemViewYPos = adjacentView.frame.minY
        
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
        
        let inset = (bounds.height - adjacentView.bounds.height)/2
        let willMoveScrollAmount = (itemViewYPos - inset) + emptySpaceHeight
        
        UIView.animate(withDuration: 0.2) {
            scrollView.setContentOffset(
                .init(x: 0, y: willMoveScrollAmount),
                animated: false
            )
        }
    }
}


#Preview {
    
    let view = AlarmPickerColumnView(
        itemSpacing: 18,
        items: [
            SelectionItem(
                content: "12",
                displayingText: "12",
                contentSize: .init(width: 48, height: 48)
            ),
            SelectionItem(
                content: "12",
                displayingText: "12",
                contentSize: .init(width: 48, height: 48)
            ),
            SelectionItem(
                content: "12",
                displayingText: "12",
                contentSize: .init(width: 48, height: 48)
            ),
            SelectionItem(
                content: "12",
                displayingText: "12",
                contentSize: .init(width: 48, height: 48)
            ),
            SelectionItem(
                content: "12",
                displayingText: "12",
                contentSize: .init(width: 48, height: 48)
            ),
        ]
    )
    
    return view
}
