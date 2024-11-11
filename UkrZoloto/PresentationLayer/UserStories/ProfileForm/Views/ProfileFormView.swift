//
//  ProfileFormView.swift
//  UkrZoloto
//
//  Created by Mykola on 05.09.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import Foundation

class ProfileFormView: InitView {
  
  private let tableView = RoundedTableView()
  
  private let titleLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.SelfView.Title.lineHieght
    label.config
      .font(UIConstants.SelfView.Title.font)
      .textColor(UIConstants.SelfView.labelColor)
    
    return label
  }()
  
  private let subtitleLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.SelfView.Subtitle.lineHieght
    label.config
      .font(UIConstants.SelfView.Subtitle.font)
      .textColor(UIConstants.SelfView.labelColor)
    return label
  }()
  
  private let generalDiscountLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.SelfView.Enumeration.lineHeight
    label.config
      .font(UIConstants.SelfView.Enumeration.font)
      .textColor(UIConstants.SelfView.labelColor)
    return label
  }()
  
  private let birthdayDiscountLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.SelfView.Enumeration.lineHeight
    label.config
      .font(UIConstants.SelfView.Enumeration.font)
      .textColor(UIConstants.SelfView.labelColor)
    return label
  }()
  
  private let cashbackDiscountLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.SelfView.Enumeration.lineHeight
    label.config
      .font(UIConstants.SelfView.Enumeration.font)
      .textColor(UIConstants.SelfView.labelColor)
    return label
  }()
  
  private let specialPromoLabel: UILabel = {
    let label = LineHeightLabel()
    label.lineHeight = UIConstants.SelfView.Enumeration.lineHeight
    label.config
      .font(UIConstants.SelfView.Enumeration.font)
      .textColor(UIConstants.SelfView.labelColor)
    return label
  }()
    
  private var tableViewTopOffset: CGFloat = UIConstants.SelfView.TableView.defaultTopOffset
    
  override func initConfigure() {
    super.initConfigure()
    configureSelf()
  }
  
  // MARK: - Public methods
  
  func localize() {
    titleLabel.text = Localizator.standard.localizedString("Один шаг до скидок")
    subtitleLabel.text = Localizator.standard.localizedString("Заполните все поля и получите:")
    
    generalDiscountLabel.text = Localizator.standard.localizedString("Скидки 3%")
    birthdayDiscountLabel.text = Localizator.standard.localizedString("Скидка на День рождения 5%")
    cashbackDiscountLabel.text = Localizator.standard.localizedString("Кэшбэк 2%")
    specialPromoLabel.text = Localizator.standard.localizedString("Специальные предложения")
  }
  
  func getTableView() -> UITableView {
    return tableView
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
  
    handleScrollViewDidScroll(scrollView)
  }

  func scrollToTop() {
    
    guard tableViewTopOffset != UIConstants.SelfView.TableView.scrolledToTopOffset else { return }
    
    updateTableViewTopConstraint(newValue: UIConstants.SelfView.TableView.scrolledToTopOffset,
                                 animated: true)
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView) {
    handleTableViewTouchesEnded()
  }
}

// MARK: - Private methods
private extension ProfileFormView {
  
  func configureSelf() {
    backgroundColor = UIConstants.SelfView.backgroundColor
    setupLabels()
    setupStackView()
    setupTableView()
    localize()
  }
  
  func setupLabels() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
        .offset(UIConstants.SelfView.Title.leading)
      make.top.equalToSuperview()
        .offset(UIConstants.SelfView.Title.top)
    }
    
    addSubview(subtitleLabel)
    subtitleLabel.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
        .offset(UIConstants.SelfView.Subtitle.leading)
      make.top.equalTo(titleLabel.snp.bottom)
        .offset(UIConstants.SelfView.Subtitle.top)
    }
  }
  
  func setupStackView() {
    
    func constructHorizontalStackView(icon: UIImage, label: UILabel) -> UIStackView {
      
      let sView = UIStackView()
      sView.axis = .horizontal
      sView.spacing = UIConstants.SelfView.Enumeration.horizontalSpacing
      
      let imageView = UIImageView()
      imageView.image = icon
      imageView.contentMode = .scaleAspectFill
      imageView.snp.makeConstraints { make in
        make.height.equalTo(UIConstants.SelfView.Enumeration.iconSize.height)
        make.width.equalTo(UIConstants.SelfView.Enumeration.iconSize.width)
      }
      
      sView.addArrangedSubview(imageView)
      
      let container = UIView()
      container.addSubview(label)
      
      label.snp.makeConstraints { make in
        make.leading.equalToSuperview()
        make.trailing.equalToSuperview()
        make.centerY.equalToSuperview()
      }
      label.contentMode = .center
      
      sView.addArrangedSubview(container)
      
      return sView
    }
    
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = UIConstants.SelfView.Enumeration.verticalSpacing
  
    addSubview(stackView)
    
    stackView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
        .offset(UIConstants.SelfView.Title.leading)
      make.top.equalTo(subtitleLabel.snp.bottom)
        .offset(UIConstants.SelfView.Enumeration.top)
    }

    let generalDiscountIcon = #imageLiteral(resourceName: "general_discount_icon")
    let birthdayDiscountIcon = #imageLiteral(resourceName: "birthday_discount_icon")
    let cashbackDiscountIcon = #imageLiteral(resourceName: "cashback_discount_icon")
    let specialPromoIcon = #imageLiteral(resourceName: "special_promo_icon")
        
    stackView.addArrangedSubview(constructHorizontalStackView(icon: generalDiscountIcon,
                                                              label: generalDiscountLabel))
    stackView.addArrangedSubview(constructHorizontalStackView(icon: birthdayDiscountIcon,
                                                              label: birthdayDiscountLabel))
    stackView.addArrangedSubview(constructHorizontalStackView(icon: cashbackDiscountIcon,
                                                              label: cashbackDiscountLabel))
    stackView.addArrangedSubview(constructHorizontalStackView(icon: specialPromoIcon,
                                                              label: specialPromoLabel))
  }
  
  func setupTableView() {

    addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview().offset(8.0)
      make.top.equalToSuperview().offset(UIConstants.SelfView.TableView.defaultTopOffset)
    }
    
    tableView.backgroundColor = UIConstants.SelfView.TableView.backgroundColor
    tableView.contentInset = UIConstants.SelfView.TableView.inset
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 44
    tableView.clipsToBounds = true
    tableView.layer.cornerRadius = UIConstants.SelfView.TableView.cornerRadius
    
    registerCells()
  }
  
  func registerCells() {
    tableView.register(UnderlineTableViewCell.self)
    tableView.register(SpaceTableViewCell.self)
    tableView.register(CenteredEmptyButtonTableViewCell.self)
    tableView.register(RoundedButtonTableViewCell.self)
    tableView.register(GenderPickerTableViewCell.self)
    tableView.register(LockedDateTableViewCell.self)
  }
  
  func handleScrollViewDidScroll(_ scrollView: UIScrollView) {
    
    let minOffset = UIConstants.SelfView.TableView.scrolledToTopOffset
    let maxOffset = UIConstants.SelfView.TableView.defaultTopOffset
    
    let actualContentOffset = scrollView.contentOffset.y
    
    if actualContentOffset > 0 // scrolling up
        && tableViewTopOffset > minOffset {
      
      let newValue = tableViewTopOffset - actualContentOffset
      updateTableViewTopConstraint(newValue: newValue, animated: false)
      scrollView.contentOffset = .zero
      
    } else if actualContentOffset < 0 &&
                tableViewTopOffset < maxOffset {
      
      let newValue = tableViewTopOffset - actualContentOffset
      updateTableViewTopConstraint(newValue: newValue, animated: false)
      scrollView.contentOffset = .zero
    }
  }

  func handleTableViewTouchesEnded() {
    
    let minOffset = UIConstants.SelfView.TableView.scrolledToTopOffset
    let maxOffset = UIConstants.SelfView.TableView.defaultTopOffset
    
    guard tableViewTopOffset != minOffset || tableViewTopOffset != maxOffset else { return }

    let delta1 = tableViewTopOffset - minOffset
    let delta2 = maxOffset - tableViewTopOffset
    
    if delta1 < delta2 {
      updateTableViewTopConstraint(newValue: minOffset, animated: true)
    } else {
      updateTableViewTopConstraint(newValue: maxOffset, animated: true)
    }
  }
  
  func updateTableViewTopConstraint(newValue: CGFloat, animated: Bool) {
    
    let duration = animated ? 0.25 : 0.0
    
    UIView.animate(withDuration: duration) {
      
      self.tableView.snp.updateConstraints { make in
        make.top.equalToSuperview().offset(newValue)
      }
      self.layoutIfNeeded()
      self.tableViewTopOffset = newValue
    }
  }
}

private enum UIConstants {
  
  enum SelfView {
    static let backgroundColor = #colorLiteral(red: 0, green: 0.314, blue: 0.184, alpha: 1)
    static let labelColor = UIColor.white
    
    enum Title {
			static let font = UIFont.extraBoldAppFont(of: 24)
      static let lineHieght: CGFloat = 28.8
      static let top: CGFloat = 96.0
      static let leading: CGFloat = 23.0
    }
    
    enum Subtitle {
			static let font = UIFont.regularAppFont(of: 15)
      static let lineHieght: CGFloat = 16.3
      static let top: CGFloat = 12.0
      static let leading: CGFloat = 23.0
    }
    
    enum Enumeration {
			static let font = UIFont.regularAppFont(of: 12)
      static let lineHeight: CGFloat = 14.3
      static let top: CGFloat = 24.0
      static let verticalSpacing: CGFloat = 5.0
      static let horizontalSpacing: CGFloat = 5.0
      
      static let iconSize: CGSize = CGSize(width: 24.0, height: 24.0)
    }
    
    enum TableView {
      static let backgroundColor = UIColor.white
      static let inset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
      static let bottomInset: CGFloat = 0
      static let scrolledToTopOffset: CGFloat = 96.0
      static let cornerRadius: CGFloat = 8.0
      static let defaultTopOffset: CGFloat = 322.0
    }
  }  
}
