import AsyncDisplayKit

class SceneController: ASViewController<SceneView> {
  
  private var interactor: SceneInteractorLogic?
  public var router: (SceneRouterLogic & SceneDataPassing)?
  
  init() {
    super.init(node: .init())
    self.setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setup() {
    let interactor = SceneInteractor.init()
    let presenter = ScenePresenter.init()
    let router = SceneRouter.init()
    
    interactor.presenter = presenter
    interactor.worker = SceneWorker.init()
    
    presenter.view = self.node
    
    router.dataStore = interactor
    router.viewController = self
    
    self.interactor = interactor
    self.router = router
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.node.buttonNode.addTarget(
      self,
      action: #selector(didTapButton),
      forControlEvents: .touchUpInside
    )
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
  }
  
  @objc func didTapButton() {
    let request = SceneModel.Title.Request()
    self.interactor?.increaseTapCount(request: request)
  }
}
