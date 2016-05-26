class PomodoroPanelController < UIViewController

  attr_accessor :pomodoro_timer

  def self.controller
    @controller ||= PomodoroPanelController.alloc.initWithNibName(nil, bundle:nil)
  end

  def viewDidLoad
    super

    self.title = "Pomodoro Panel"
    self.view.backgroundColor = UIColor.whiteColor
    self.view.tintColor = UIColor.blackColor


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

    @timer_label = UILabel.alloc.initWithFrame([[(self.view.frame.size.width  / 2) - 65, 150], [(self.view.frame.size.width  / 2) - 15, 40]])
    @timer_label.font = UIFont.boldSystemFontOfSize(40)
    @timer_label.text = "00:00"
    @timer_label.sizeToFit
    @containerView.addSubview(@timer_label)

    @startButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @startButton.frame = [[40, 220], [(self.view.frame.size.width  / 3) - 30, 30]]
    @startButton.setTitle('Start', forState: UIControlStateNormal)
    @startButton.tintColor = UIColor.whiteColor
    @startButton.backgroundColor = UIColor.greenColor
    @startButton.addTarget(self,
                              action:'startTimer',
                              forControlEvents:UIControlEventTouchUpInside)

    @containerView.addSubview(@startButton)

    @stopButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @stopButton.frame = [[139, 220], [(self.view.frame.size.width  / 3) - 30, 30]]
    @stopButton.setTitle('Stop', forState: UIControlStateNormal)
    @stopButton.tintColor = UIColor.whiteColor
    @stopButton.backgroundColor = UIColor.redColor
    @stopButton.addTarget(self,
                           action:'stopTimer',
                           forControlEvents:UIControlEventTouchUpInside)

    @containerView.addSubview(@stopButton)


    @resetButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @resetButton.frame = [[237, 220], [(self.view.frame.size.width  / 3) - 30, 30]]
    @resetButton.backgroundColor = UIColor.lightGrayColor
    @resetButton.tintColor = UIColor.whiteColor
    @resetButton.setTitle('Reset', forState: UIControlStateNormal)
    @resetButton.addTarget(self,
                              action:'resetTimer',
                              forControlEvents:UIControlEventTouchUpInside)

    @containerView.addSubview(@resetButton)

    self.view.addSubview(@containerView)

  end

  def shortBreak
    mins = App::Persistence['shortBreakTime'].to_i
    @timer_label.text = "%02d:%02d" % [mins, 00]
  end

  def longBreak
    mins = App::Persistence['longBreakTime'].to_i
    @timer_label.text = "%02d:%02d" % [mins, 00]
  end

  def pomodoro
    mins = 25
    @timer_label.text = "%02d:%02d" % [mins, 00]
  end

  def timer
    @timer ||= PomodoroTimer.new
  end

  def startTimer
    App.alert('start')
  end

  def stopTimer
    App.alert('stop')
  end

  def resetTimer
    App.alert('reset')
  end
end
