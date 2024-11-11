import UIKit
import SnapKit

class HorizontalProductsGroupView: UIView {
  
  // MARK: - Private variables
  private let collectionView: UICollectionView
  private let collectionViewLayout: UICollectionViewFlowLayout
  private let titleLabel = UILabel()
  private let showMoreButton = GreyButton()
  private var titleLabelToTopConstraint: Constraint?
  private var collectionViewHeightConstraint: Constraint?
  private var collectionViewToTopConstraint: Constraint?
  private var collectionViewToBottomConstraint: Constraint?
  private var showMoreButtonToBottomConstraint: Constraint?
  
  // MARK: - Life cycle
  override init(frame: CGRect) {
    collectionViewLayout = UICollectionViewFlowLayout()
    collectionViewLayout.scrollDirection = .horizontal
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    super.init(frame: frame)
    initConfigure()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func updateConstraints() {
    let height = UIConstants.CollectionView.cellHeight + UIConstants.CollectionView.bottom
    collectionViewHeightConstraint?.update(offset: height - 1)
    
    let hasTitleLabel = !titleLabel.isHidden
    collectionViewToTopConstraint?.isActive = !hasTitleLabel
    titleLabelToTopConstraint?.isActive = hasTitleLabel
    
    let hasShowMoreButton = !showMoreButton.isHidden
    collectionViewToBottomConstraint?.isActive = !hasShowMoreButton
    showMoreButtonToBottomConstraint?.isActive = hasShowMoreButton
    
    super.updateConstraints()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    collectionViewLayout.itemSize = CGSize(width: UIConstants.CollectionView.cellWidth,
                                           height: UIConstants.CollectionView.cellHeight)
  }
  
  // MARK: - Init configure
  private func initConfigure() {
    backgroundColor = UIConstants.SelfView.backgroundColor
    configureTitleLabel()
    configureCollectionView()
    configureShowMoreButton()
    titleLabelToTopConstraint?.isActive = false
    setTitle(nil)
    showMoreButtonToBottomConstraint?.isActive = false
    setShowMoreTitle(nil)
  }
  
  private func configureTitleLabel() {
    titleLabel.config
      .font(UIConstants.TitleLabel.font)
      .numberOfLines(UIConstants.TitleLabel.numberOfLines)
      .textColor(UIConstants.TitleLabel.textColor)
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      titleLabelToTopConstraint = make.top.equalToSuperview().offset(UIConstants.TitleLabel.top).constraint
      make.leading.trailing.equalToSuperview().inset(UIConstants.TitleLabel.left)
    }
    titleLabel.setContentHuggingPriority(.required, for: .vertical)
    titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
  }
  
  private func configureCollectionView() {
    collectionView.backgroundColor = UIConstants.CollectionView.backgroundColor
    addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(titleLabel.snp.bottom).offset(UIConstants.CollectionView.top)
      collectionViewToTopConstraint = make.top.equalToSuperview().priority(999).constraint
      collectionViewHeightConstraint = make.height.equalTo(UIConstants.CollectionView.height).constraint
      collectionViewToBottomConstraint = make.bottom.equalToSuperview().constraint
    }
    collectionView.contentInset.left = UIConstants.CollectionView.horizontalInset
    collectionView.contentInset.right = UIConstants.CollectionView.horizontalInset
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.showsVerticalScrollIndicator = false
    collectionView.clipsToBounds = false
  }
  
  private func configureShowMoreButton() {
    addSubview(showMoreButton)
    showMoreButton.snp.makeConstraints { make in
      make.top.equalTo(collectionView.snp.bottom).offset(UIConstants.ShowMoreButton.top)
      make.left.right.equalToSuperview().inset(UIConstants.ShowMoreButton.left)
      make.height.equalTo(UIConstants.ShowMoreButton.height)
      showMoreButtonToBottomConstraint = make.bottom.equalToSuperview()
        .inset(UIConstants.ShowMoreButton.bottom)
        .priority(999).constraint
    }
  }
  
  // MARK: - Interface
  
  func setTitle(_ title: String?) {
    titleLabel.text = title
    titleLabel.isHidden = title == nil
  }
  
  func setShowMoreTitle(_ title: String?) {
    showMoreButton.setTitle(title, for: .normal)
    showMoreButton.isHidden = title == nil
  }
  
  func getCollectionView() -> UICollectionView {
    return collectionView
  }
  
  func getShowMoreButton() -> UIButton {
    return showMoreButton
  }
}

private enum UIConstants {
  enum SelfView {
    static let backgroundColor = UIColor.clear
  }
  
  enum CollectionView {
    static let top: CGFloat = 15
    static let bottom: CGFloat = 25
    static let aspect: CGFloat = 16.0 / 9.0
    static let width = Constants.Screen.screenWidth
    static let height = (cellWidth * aspect).rounded()
    
    static let horizontalInset: CGFloat = 16
    static let interitemSpacing: CGFloat = 8
    
    static let cellWidth: CGFloat = (width - 2 * horizontalInset - interitemSpacing) / 2
    static let cellHeight: CGFloat = 302
    static let backgroundColor = UIColor.clear
  }
  
  enum TitleLabel {
    static let top: CGFloat = 15
    static let left: CGFloat = 16
    static let textColor = UIColor.color(r: 62, g: 76, b: 75)
    static let font = UIFont.boldAppFont(of: 22)
    static let numberOfLines = 0
  }
  
  enum ShowMoreButton {
    static let top: CGFloat = 30
    static let left: CGFloat = 16
    static let height: CGFloat = 48
    static let bottom: CGFloat = 20
  }
}
