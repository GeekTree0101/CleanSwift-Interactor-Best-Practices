import AsyncDisplayKit

protocol SceneDisplayLogic: class {
  
  func displayIncreaseTapCount(viewModel: SceneModel.Title.ViewModel)
}

final class SceneView: ASDisplayNode {
  
  enum Const {
    static let titleAttributes: [NSAttributedString.Key: Any] =
      [.font: UIFont.boldSystemFont(ofSize: 18.0)]
  }
  
  public let titleNode: ASTextNode2 = {
    let node = ASTextNode2()
    node.maximumNumberOfLines = 1
    return node
  }()
  
  public let buttonNode: ASButtonNode = {
    let node = ASButtonNode()
    node.setTitle("Tap", with: .systemFont(ofSize: 15.0), with: .blue, for: .normal)
    node.borderColor = UIColor.blue.cgColor
    node.borderWidth = 1.0
    node.contentEdgeInsets = .init(top: 8.0, left: 15.0, bottom: 8.0, right: 15.0)
    node.cornerRadius = 8.0
    return node
  }()
  
  override init() {
    super.init()
    self.automaticallyManagesSubnodes = true
    self.automaticallyRelayoutOnSafeAreaChanges = true
    self.backgroundColor = .white
  }
  
  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    return InsetLayout(insets: .init(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)) {
      VStackLayout(spacing: 8.0, justifyContent: .center, alignItems: .center) {
        titleNode.styled({ $0.shrink().nonGrow() })
        buttonNode
      }
    }
    .buildLayout()
  }
}

extension SceneView: SceneDisplayLogic {
  
  func displayIncreaseTapCount(viewModel: SceneModel.Title.ViewModel) {
    self.titleNode.attributedText = .init(
      string: viewModel.displayTitle,
      attributes: Const.titleAttributes
    )
    self.setNeedsLayout()
  }
}
