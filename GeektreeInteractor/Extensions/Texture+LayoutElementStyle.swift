import AsyncDisplayKit

extension ASLayoutElementStyle {
  
  @discardableResult
  func shrink(value: CGFloat = 1.0) -> Self {
    self.flexShrink = value
    return self
  }
  
  @discardableResult
  func grow(value: CGFloat = 1.0) -> Self {
    self.flexGrow = value
    return self
  }
  
  @discardableResult
  func nonShrink() -> Self {
    self.flexShrink = 0.0
    return self
  }
  
  @discardableResult
  func nonGrow() -> Self {
    self.flexGrow = 0.0
    return self
  }
  
  @discardableResult
  func width(_ value: CGFloat, unit: ASDimensionUnit = .points) -> Self {
    self.width = ASDimension.init(unit: unit, value: value)
    return self
  }
  
  @discardableResult
  func height(_ value: CGFloat, unit: ASDimensionUnit = .points) -> Self {
    self.height = ASDimension.init(unit: unit, value: value)
    return self
  }
  
  @discardableResult
  func maxWidth(_ value: CGFloat, unit: ASDimensionUnit = .points) -> Self {
    self.maxWidth = ASDimension.init(unit: unit, value: value)
    return self
  }
  
  @discardableResult
  func maxHeight(_ value: CGFloat, unit: ASDimensionUnit = .points) -> Self {
    self.maxHeight = ASDimension.init(unit: unit, value: value)
    return self
  }
  
  @discardableResult
  func minWidth(_ value: CGFloat, unit: ASDimensionUnit = .points) -> Self {
    self.minWidth = ASDimension.init(unit: unit, value: value)
    return self
  }
  
  @discardableResult
  func minHeight(_ value: CGFloat, unit: ASDimensionUnit = .points) -> Self {
    self.minHeight = ASDimension.init(unit: unit, value: value)
    return self
  }
  
  @discardableResult
  func size(_ value: CGSize) -> Self {
    self.preferredSize = value
    return self
  }
  
  @discardableResult
  func maxSize(_ value: CGSize) -> Self {
    self.maxSize = value
    return self
  }
  
  @discardableResult
  func minSize(_ value: CGSize) -> Self {
    self.minSize = value
    return self
  }
  
  @discardableResult
  func spacingAfter(_ value: CGFloat) -> Self {
    self.spacingAfter = value
    return self
  }
  
  @discardableResult
  func spacingBefore(_ value: CGFloat) -> Self {
    self.spacingBefore = value
    return self
  }
}
