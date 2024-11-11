//
//  CompilationLayout.swift
//  UkrZoloto
//
//  Created by Andrew Koshkin on 7/15/19.
//  Copyright © 2019 Brander. All rights reserved.
//

import UIKit

class CompilationLayout: UICollectionViewFlowLayout {
  
  // Кешуємо атрибути для оптимізації
  private var cachedAttributes: [UICollectionViewLayoutAttributes] = []
  private var lastBounds: CGRect = .zero
  
  override func targetContentOffset(
    forProposedContentOffset proposedContentOffset: CGPoint,
    withScrollingVelocity velocity: CGPoint
  ) -> CGPoint {
    guard let collectionView = collectionView,
          !collectionView.isPagingEnabled else {
      return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
    }
    
    // Кешуємо часто використовувані значення
    let midSide = collectionView.bounds.width / 2
    let proposedContentOffsetCenterOrigin = proposedContentOffset.x + midSide
    
    // Якщо розміри змінилися, кешуємо атрибути
    let attributes: [UICollectionViewLayoutAttributes]
    if collectionView.bounds == lastBounds {
      attributes = cachedAttributes
    } else {
      attributes = layoutAttributesForElements(in: collectionView.bounds) ?? []
      cachedAttributes = attributes
      lastBounds = collectionView.bounds
    }
    
    // Знаходимо найближчий елемент до запропонованого offset
    let closest = attributes.min(by: {
      abs($0.center.x - proposedContentOffsetCenterOrigin) <
        abs($1.center.x - proposedContentOffsetCenterOrigin)
    }) ?? UICollectionViewLayoutAttributes()
    
    let targetContentOffset = CGPoint(
      x: floor(closest.center.x - midSide),
      y: proposedContentOffset.y
    )
    
    // Анімація прокручування в залежності від швидкості
    if velocity.x != 0,
       (proposedContentOffset.x - targetContentOffset.x) * velocity.x > 0 {
      
      let animationDuration = min(0.3, max(0.1, abs(velocity.x) * 0.5))  // Динамічна тривалість анімації на основі швидкості
      CATransaction.begin()
      CATransaction.setAnimationDuration(animationDuration)
      
      collectionView.setContentOffset(collectionView.contentOffset, animated: false)
      collectionView.setContentOffset(targetContentOffset, animated: true)
      
      CATransaction.commit()
      
      return collectionView.contentOffset
    }
    
    return targetContentOffset
  }
  
  // Очищаємо кеш при зміні розміру
  override func invalidateLayout() {
    super.invalidateLayout()
    cachedAttributes.removeAll()
    lastBounds = .zero
  }
  
  // Оптимізуємо обчислення атрибутів
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    guard let attributes = super.layoutAttributesForElements(in: rect) else {
      return nil
    }
    
    // Копіюємо атрибути для уникнення проблем з повторним використанням
    return attributes.map { $0.copy() as! UICollectionViewLayoutAttributes }
  }
  
  // Очищаємо ресурси
  deinit {
    cachedAttributes.removeAll()
  }
}
