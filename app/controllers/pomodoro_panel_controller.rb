class PomodoroPanelController < UIViewController

  def self.controller
    @controller ||= PomodoroPanelController.alloc.initWithNibName(nil, bundle:nil)
  end

  def viewDidLoad
    super

    self.title = "Pomodoro Panel"
    self.view.backgroundColor = UIColor.whiteColor
  end
end
