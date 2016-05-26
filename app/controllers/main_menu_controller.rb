class MainMenuController < UIViewController

  def self.controller
    @controller ||= MainMenuController.alloc.initWithNibName(nil, bundle:nil)
  end

  def viewDidLoad
    super

    self.title = "Main menu"
    self.view.backgroundColor = UIColor.whiteColor
    self.view.tintColor = UIColor.blackColor


    @containerView = UIView.alloc.initWithFrame([[0, 50], [self.view.frame.size.width, self.view.frame.size.height]])

    logoutButton = UIBarButtonItem.alloc.initWithTitle("Logout",
                                                       style:UIBarButtonItemStylePlain,
                                                       target:self,
                                                       action:'logout')
    self.navigationItem.leftBarButtonItem = logoutButton

    refreshButton = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemRefresh,
                                                                      target:self,
                                                                      action:'refresh')
    self.navigationItem.rightBarButtonItem = refreshButton

    @showPomodoroPanelButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @showPomodoroPanelButton.frame = [[40, 25], [(self.view.frame.size.width) - 80, 30]]
    @showPomodoroPanelButton.backgroundColor = UIColor.cyanColor
    @showPomodoroPanelButton.setTitle('POMODORO TIME!', forState: UIControlStateNormal)
    @showPomodoroPanelButton.addTarget(self,
                              action:'showPomodoroPanel',
                              forControlEvents:UIControlEventTouchUpInside)

    @containerView.addSubview(@showPomodoroPanelButton)

    @showOptionsButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @showOptionsButton.frame = [[40, 65], [(self.view.frame.size.width) - 80, 30]]
    @showOptionsButton.backgroundColor = UIColor.cyanColor

    @showOptionsButton.setTitle('Options', forState: UIControlStateNormal)
    @showOptionsButton.addTarget(self,
                              action:'showOptions',
                              forControlEvents:UIControlEventTouchUpInside)

    @containerView.addSubview(@showOptionsButton)

    self.view.addSubview(@containerView)
  end

  def refresh
  end

  def logout
    UIApplication.sharedApplication.delegate.logout
  end

  def showPomodoroPanel
    @pomodoroPanelController = PomodoroPanelController.alloc.init
    self.navigationController.pushViewController(@pomodoroPanelController, animated:false)
  end

  def showOptions
    @showOptionsController = OptionsController.alloc.init
    self.navigationController.pushViewController(@showOptionsController, animated:false)
  end
end
