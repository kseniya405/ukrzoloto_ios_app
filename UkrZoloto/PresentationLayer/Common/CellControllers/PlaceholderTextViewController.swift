//
//  PlaceholderTextViewController.swift
//  UkrZoloto
//
//  Created by Andrey Koshkin on 28.02.2021.
//  Copyright © 2021 Brander. All rights reserved.
//

import AUIKit

protocol PlaceholderTextViewDidChangeDelegate: AnyObject {
  func textDidChange(in controller: PlaceholderTextViewController)
}

class PlaceholderTextViewController: AUIDefaultViewController, AUITextViewControllerDidChangeTextObserver {
  
  // MARK: - View
  
  var placeholderTextView: CommentView? {
    get { return view as? CommentView }
    set { view = newValue }
  }
  
  // MARK: - Delegates
  
  weak var textDidChangeDelegate: PlaceholderTextViewDidChangeDelegate?
  
  // MARK: - Controllers
  
  private let textViewController: LimitTextViewController
  
  // MARK: - Passed data
  
  var placeholder: String? {
    didSet {
      placeholderTextView?.topPlaceholderLabel.text = placeholder
      placeholderTextView?.textView.placeholder = placeholder
    }
  }
  
  var text: String? {
    get { return textViewController.text }
    set { textViewController.text = newValue }
  }
  
  var maxCharacters: Int {
    didSet { textViewController.maxCharacters = maxCharacters }
  }
  
  var isCollapsed: Bool = true
  
  var keyboardType: UIKeyboardType = .default {
    didSet { textViewController.keyboardType = keyboardType }
  }
  
  var autocorrectionType: UITextAutocorrectionType = .default {
    didSet { textViewController.autocorrectionType = autocorrectionType }
  }
  
  var autocapitalizationType: UITextAutocapitalizationType = .none {
    didSet { textViewController.autocapitalizationType = autocapitalizationType }
  }
  
  var isScrollEnabled: Bool {
    get { return textViewController.isScrollEnabled }
    set { textViewController.isScrollEnabled = newValue }
  }
  
  // MARK: - View life cycle
  init(maxCharacters: Int) {
    self.maxCharacters = maxCharacters
    textViewController = LimitTextViewController(maxCharacters: maxCharacters)
  }
  
  override func setupView() {
    super.setupView()
    textViewController.addDidChangeTextObserver(self)
    textViewController.textView = placeholderTextView?.textView
    placeholderTextView?.textView.placeholder = placeholder
    updatePlaceholderLabelAppearence()
    updateCollapsedState()
    placeholderTextView?.button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
  }
  
  override func unsetupView() {
    super.unsetupView()
    textViewController.textView = nil
    textViewController.removeDidChangeTextObserver(self)
    placeholderTextView?.button.removeTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
  }
  
  // MARK: - AUITextViewControllerDidChangeTextDelegate
  
  func textViewControllerDidChangeText(_ controller: AUITextViewController) {
    updatePlaceholderLabelAppearence()
    if let placeholderTextView = placeholderTextView {
      let numberOfLines = placeholderTextView.getTextViewNumberOfLines()
      if numberOfLines <= 5 {
        controller.isScrollEnabled = false
        if numberOfLines == 0 {
          placeholderTextView.changeTextViewHeight(lines: 1)
        } else {
          placeholderTextView.changeTextViewHeight(lines: numberOfLines)
        }
      } else {
        controller.isScrollEnabled = true
      }
    }
    textDidChangeDelegate?.textDidChange(in: self)
  }
  
  private func updatePlaceholderLabelAppearence() {
    placeholderTextView?.topPlaceholderLabel.isHidden = textViewController.text.isNilOrEmpty
    if textViewController.text.isNilOrEmpty {
      textViewController.isScrollEnabled = false
    } else {
      textViewController.isScrollEnabled = true
    }
  }
  
  private func updateCollapsedState() {
    placeholderTextView?.bottomLineView.isHidden = isCollapsed
    placeholderTextView?.textView.isHidden = isCollapsed
    let image = isCollapsed ? UIConstants.Button.addImage : UIConstants.Button.removeImage
    placeholderTextView?.button.setImage(image, for: .normal)
    let title = Localizator.standard.localizedString("Комментарий к заказу")
    placeholderTextView?.button.setTitle(title, for: .normal)
  }
  
  @objc
  private func buttonTapped() {
    isCollapsed.toggle()
    if isCollapsed {
      _ = placeholderTextView?.textView.resignFirstResponder()
    }
    updateCollapsedState()
  }
}

// MARK: - UI constants
private enum UIConstants {
  enum Button {
    static let addImage = #imageLiteral(resourceName: "addComment")
    static let removeImage = #imageLiteral(resourceName: "controlsClearField")
  }
}
