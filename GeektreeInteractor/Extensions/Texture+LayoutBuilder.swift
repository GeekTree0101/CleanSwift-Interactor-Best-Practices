import AsyncDisplayKit

public protocol ASLayoutBuilderType {
  
  func make() -> [ASLayoutElement?]
}

extension ASLayoutBuilderType {
  
  func styled(_ styleBlock: (ASLayoutElementStyle) -> Void) -> ASLayoutSpec {
    return ASWrapperLayoutSpec.init(layoutElements: self.make().compactMap({ $0 })).styled(styleBlock)
  }
  
  func buildLayout() -> ASLayoutSpec {
    return ASWrapperLayoutSpec.init(layoutElements: self.make().compactMap({ $0 }))
  }
}

@_functionBuilder public struct ASLayoutSpecBuilder {
  
  public static func buildBlock() -> EmptyLayout {
    EmptyLayout()
  }
  
  public static func buildBlock<Content>(_ content: Content) -> Content where Content : ASLayoutBuilderType {
    content
  }
  
  public static func buildBlock(_ content: ASLayoutBuilderType?...) -> MultiLayout {
    MultiLayout(content)
  }
  
  public static func buildIf<Content>(_ content: Content?) -> Content? where Content : ASLayoutBuilderType  {
    content
  }
  
  public static func buildEither<TrueContent, FalseContent>(first: TrueContent) -> ConditionalLayout<TrueContent, FalseContent> {
    .init(trueContent: first)
  }
  
  public static func buildEither<TrueContent, FalseContent>(second: FalseContent) -> ConditionalLayout<TrueContent, FalseContent> {
    .init(falseContent: second)
  }
}

extension ASDisplayNode : ASLayoutBuilderType {
  public func make() -> [ASLayoutElement?] {
    [self]
  }
}

extension ASLayoutSpec : ASLayoutBuilderType {
  public func make() -> [ASLayoutElement?] {
    [self]
  }
}

public struct ConditionalLayout<TrueContent, FalseContent> : ASLayoutBuilderType where TrueContent : ASLayoutBuilderType, FalseContent : ASLayoutBuilderType {
  
  let content: [ASLayoutElement]
  
  init(trueContent: TrueContent) {
    self.content = trueContent.make().compactMap({ $0 })
  }
  
  init(falseContent: FalseContent) {
    self.content = falseContent.make().compactMap({ $0 })
  }
  
  public func make() -> [ASLayoutElement?] {
    content
  }
}

public final class LayoutSpec<Content> : ASWrapperLayoutSpec where Content : ASLayoutBuilderType {
  
  public init(@ASLayoutSpecBuilder _ content: () -> Content) {
    super.init(layoutElements: content().make().compactMap({ $0 }))
  }
}

public struct MultiLayout : ASLayoutBuilderType {
  
  public let elements: [ASLayoutBuilderType?]
  
  init(_ elements: [ASLayoutBuilderType?]) {
    self.elements = elements
  }
  
  public func make() -> [ASLayoutElement?] {
    elements.compactMap { $0 }.flatMap { $0.make() }
  }
}

public struct EmptyLayout : ASLayoutBuilderType {
  
  public func make() -> [ASLayoutElement?] {
    [ASLayoutSpec()]
  }
}

public struct VStackLayout<Content> : ASLayoutBuilderType where Content : ASLayoutBuilderType {
  
  public let spacing: CGFloat
  public let justifyContent: ASStackLayoutJustifyContent
  public let alignItems: ASStackLayoutAlignItems
  public let childlen: Content
  
  public init(
    spacing: CGFloat = 0,
    justifyContent: ASStackLayoutJustifyContent = .start,
    alignItems: ASStackLayoutAlignItems = .start,
    @ASLayoutSpecBuilder content: () -> Content
  ) {
    
    self.spacing = spacing
    self.justifyContent = justifyContent
    self.alignItems = alignItems
    self.childlen = content()
    
  }
  
  public func make() -> [ASLayoutElement?] {
    [
      ASStackLayoutSpec(
        direction: .vertical,
        spacing: spacing,
        justifyContent: justifyContent,
        alignItems: alignItems,
        children: childlen.make().compactMap({ $0 })
      )
    ]
  }
}

public struct HStackLayout<Content> : ASLayoutBuilderType where Content : ASLayoutBuilderType {
  
  public let spacing: CGFloat
  public let justifyContent: ASStackLayoutJustifyContent
  public let alignItems: ASStackLayoutAlignItems
  public let childlen: Content
  
  public init(
    spacing: CGFloat = 0,
    justifyContent: ASStackLayoutJustifyContent = .start,
    alignItems: ASStackLayoutAlignItems = .start,
    @ASLayoutSpecBuilder content: () -> Content
  ) {
    
    self.spacing = spacing
    self.justifyContent = justifyContent
    self.alignItems = alignItems
    self.childlen = content()
    
  }
  
  public func make() -> [ASLayoutElement?] {
    [
      ASStackLayoutSpec(
        direction: .horizontal,
        spacing: spacing,
        justifyContent: justifyContent,
        alignItems: alignItems,
        children: childlen.make().compactMap({ $0 })
      )
    ]
  }
  
}

public struct ZStackLayout<Content> : ASLayoutBuilderType where Content : ASLayoutBuilderType {
  
  public let childlen: Content
  
  public init(
    @ASLayoutSpecBuilder content: () -> Content
  ) {
    self.childlen = content()
  }
  
  public func make() -> [ASLayoutElement?] {
    [
      ASWrapperLayoutSpec(layoutElements: childlen.make().compactMap({ $0 }))
    ]
  }
}


public struct InsetLayout<Content> : ASLayoutBuilderType where Content : ASLayoutBuilderType {
  
  public let content: Content
  public let insets: UIEdgeInsets
  
  public init(insets: UIEdgeInsets, content: () -> Content) {
    self.content = content()
    self.insets = insets
  }
  
  public func make() -> [ASLayoutElement?] {
    content.make().compactMap({ $0 }).map { ASInsetLayoutSpec(insets: insets, child: $0) }
  }
}

public struct OverlayLayout<OverlayContnt, Content> : ASLayoutBuilderType where OverlayContnt : ASLayoutBuilderType, Content : ASLayoutBuilderType {
  
  public let content: Content
  public let overlay: OverlayContnt
  
  public init(content: () -> Content, overlay: () -> OverlayContnt) {
    self.content = content()
    self.overlay = overlay()
  }
  
  public func make() -> [ASLayoutElement?] {
    [
      ASOverlayLayoutSpec(
        child: content.make().compactMap({ $0 }).first ?? ASLayoutSpec(),
        overlay: overlay.make().compactMap({ $0 }).first ?? ASLayoutSpec()
      )
    ]
  }
  
}

public struct BackgroundLayout<BackgroundContnt, Content> : ASLayoutBuilderType where BackgroundContnt : ASLayoutBuilderType, Content : ASLayoutBuilderType {
  
  public let content: Content
  public let background: BackgroundContnt
  
  public init(content: () -> Content, overlay: () -> BackgroundContnt) {
    self.content = content()
    self.background = overlay()
  }
  
  public func make() -> [ASLayoutElement?] {
    [
      ASBackgroundLayoutSpec(
        child: content.make().compactMap({ $0 }).first ?? ASLayoutSpec(),
        background: background.make().compactMap({ $0 }).first ?? ASLayoutSpec()
      )
    ]
  }
  
}

public struct AspectRatioLayout<Content> : ASLayoutBuilderType where Content : ASLayoutBuilderType {
  
  public let content: Content
  public let ratio: CGFloat
  
  public init(ratio: CGFloat, content: () -> Content) {
    self.ratio = ratio
    self.content = content()
  }
  
  public init(ratio: CGSize, content: () -> Content) {
    self.ratio = ratio.height / ratio.width
    self.content = content()
  }
  
  public func make() -> [ASLayoutElement?] {
    [
      ASRatioLayoutSpec(
        ratio: ratio,
        child: content.make().compactMap({ $0 }).first ?? ASLayoutSpec()
      )
    ]
  }
  
}

public struct CenterLayout<Content> : ASLayoutBuilderType where Content : ASLayoutBuilderType {
  
  public let content: Content
  public let centeringOptions: ASCenterLayoutSpecCenteringOptions
  public let sizingOptions: ASCenterLayoutSpecSizingOptions
  
  public init(centeringOptions: ASCenterLayoutSpecCenteringOptions,
              sizingOptions: ASCenterLayoutSpecSizingOptions,
              _ content: () -> Content) {
    self.centeringOptions = centeringOptions
    self.sizingOptions = sizingOptions
    self.content = content()
  }
  
  public func make() -> [ASLayoutElement?] {
    [
      ASCenterLayoutSpec.init(
        centeringOptions: self.centeringOptions,
        sizingOptions: self.sizingOptions,
        child: self.content.make().compactMap({ $0 }).first ?? ASLayoutSpec()
      )
    ]
  }
}

public struct HSpacerLayout : ASLayoutBuilderType {
  
  public let minLength: CGFloat
    
  public init(minLength: CGFloat = 0) {
    self.minLength = minLength
  }
    
  public func make() -> [ASLayoutElement?] {
    [
      {
        let spec = ASLayoutSpec()
        spec.style.flexGrow = 1
        spec.style.minWidth = .init(unit: .points, value: minLength)
        return spec
      }()
    ]
  }
}

public struct VSpacerLayout : ASLayoutBuilderType {
  
  public let minLength: CGFloat
  
  public init(minLength: CGFloat = 0) {
    self.minLength = minLength
  }
  
  public func make() -> [ASLayoutElement?] {
    [
      {
        let spec = ASLayoutSpec()
        spec.style.flexGrow = 1
        spec.style.minHeight = .init(unit: .points, value: minLength)
        return spec
      }()
    ]
  }
}
