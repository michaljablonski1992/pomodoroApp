class PomodoroPanelController < UIViewController

  def self.controller
    @controller ||= PomodoroPanelController.alloc.initWithNibName(nil, bundle:nil)
  end

  def viewDidLoad
    super

    self.title = "Pomodoro Panel"
    self.view.backgroundColor = UIColor.whiteColor

    @containerView = UIView.alloc.initWithFrame([[0, 50], [self.view.frame.size.width, self.view.frame.size.height]])

    @shortBreakButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @shortBreakButton.frame = [[40, 45], [(self.view.frame.size.width  / 2) - 40, 30]]
    @shortBreakButton.setTitle('Short break', forState: UIControlStateNormal)
    @shortBreakButton.backgroundColor = UIColor.cyanColor
    @shortBreakButton.addTarget(self,
                              action:'shortBreak',
                              forControlEvents:UIControlEventTouchUpInside)

    @containerView.addSubview(@shortBreakButton)

    @longBreakButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @longBreakButton.frame = [[(self.view.frame.size.width  / 2) + 1, 45], [(self.view.frame.size.width  / 2) - 40, 30]]
    @longBreakButton.setTitle('Long break', forState: UIControlStateNormal)
    @longBreakButton.backgroundColor = UIColor.cyanColor
    @longBreakButton.addTarget(self,
                           action:'longBreak',
                           forControlEvents:UIControlEventTouchUpInside)

    @containerView.addSubview(@longBreakButton)


    @pomodoroButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @pomodoroButton.frame = [[40, 76], [(self.view.frame.size.width) - 79, 30]]
    @pomodoroButton.backgroundColor = UIColor.cyanColor
    @pomodoroButton.setTitle('Pomodoro', forState: UIControlStateNormal)
    @pomodoroButton.addTarget(self,
                              action:'pomodoro',
                              forControlEvents:UIControlEventTouchUpInside)

    @containerView.addSubview(@pomodoroButton)


    self.view.addSubview(@containerView)

  end

  def shortBreak
    App.alert("shortu")
  end

  def longBreak
    App.alert("longu")
  end

  def pomodoro
    App.alert("pomodoro")
  end
end
