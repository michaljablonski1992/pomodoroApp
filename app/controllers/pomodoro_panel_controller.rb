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

    screen_width = self.view.frame.size.width
    screen_height = self.view.frame.size.height


    @containerView = UIView.alloc.initWithFrame([[0, 50], [screen_width, screen_height]])

    @shortBreakButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @shortBreakButton.frame = [[40, 45], [(screen_width  / 2) - 40, 30]]
    @shortBreakButton.setTitle('Short break', forState: UIControlStateNormal)
    @shortBreakButton.backgroundColor = UIColor.cyanColor
    @shortBreakButton.addTarget(self,
                              action:'shortBreak',
                              forControlEvents:UIControlEventTouchUpInside)

    @containerView.addSubview(@shortBreakButton)

    @longBreakButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @longBreakButton.frame = [[(screen_width  / 2) + 1, 45], [(screen_width  / 2) - 40, 30]]
    @longBreakButton.setTitle('Long break', forState: UIControlStateNormal)
    @longBreakButton.backgroundColor = UIColor.cyanColor
    @longBreakButton.addTarget(self,
                           action:'longBreak',
                           forControlEvents:UIControlEventTouchUpInside)

    @containerView.addSubview(@longBreakButton)


    @pomodoroButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @pomodoroButton.frame = [[40, 76], [(screen_width) - 79, 30]]
    @pomodoroButton.backgroundColor = UIColor.cyanColor
    @pomodoroButton.setTitle('Pomodoro', forState: UIControlStateNormal)
    @pomodoroButton.addTarget(self,
                              action:'pomodoro',
                              forControlEvents:UIControlEventTouchUpInside)

    @containerView.addSubview(@pomodoroButton)

    @timer_label = UILabel.alloc.initWithFrame([[(screen_width  / 2) - 65, 150], [(screen_width  / 2) - 15, 40]])
    @timer_label.font = UIFont.boldSystemFontOfSize(40)
    @timer_label.text = "00:00"
    @timer_label.sizeToFit
    @containerView.addSubview(@timer_label)

    @startButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @startButton.frame = [[(screen_width  / 3), 220], [(screen_width  / 4) + 15, 60]]
    @startButton.setTitle('Start', forState: UIControlStateNormal)
    @startButton.tintColor = UIColor.whiteColor
    @startButton.backgroundColor = UIColor.greenColor
    @startButton.addTarget(self,
                              action:'startTimer',
                              forControlEvents:UIControlEventTouchUpInside)

    @containerView.addSubview(@startButton)

    @gray_line = UIView.alloc.initWithFrame(CGRectMake(0, 300, screen_width, 320))
    @gray_line.backgroundColor = UIColor.lightGrayColor
    @containerView.addSubview(@gray_line)

    pomodoros_made_label = UILabel.alloc.initWithFrame([[(screen_width  / 4), 330], [(screen_width  / 4), 40]])
    pomodoros_made_label.font = UIFont.boldSystemFontOfSize(20)
    pomodoros_made_label.text = "Pomodoros made:"
    pomodoros_made_label.sizeToFit
    @containerView.addSubview(pomodoros_made_label)

    @pomodoros_made_count_label = UILabel.alloc.initWithFrame([[(screen_width  / 2) - 15, 370], [(screen_width  / 2) - 15, 40]])
    @pomodoros_made_count_label.font = UIFont.boldSystemFontOfSize(25)
    @pomodoros_made_count_label.text = "0"
    @pomodoros_made_count_label.sizeToFit
    @containerView.addSubview(@pomodoros_made_count_label)

    self.setPomodorsCountLabel

    @resetPomodorosButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @resetPomodorosButton.frame = [[(screen_width  / 3), 440], [(screen_width  / 4) + 15, 30]]
    @resetPomodorosButton.setTitle('RESET', forState: UIControlStateNormal)
    @resetPomodorosButton.tintColor = UIColor.whiteColor
    @resetPomodorosButton.backgroundColor = UIColor.grayColor
    @resetPomodorosButton.addTarget(self,
                              action:'resetPomodoros',
                              forControlEvents:UIControlEventTouchUpInside)

    @containerView.addSubview(@resetPomodorosButton)

    self.view.addSubview(@containerView)


  end

  def shortBreak
    mins = App::Persistence['shortBreakTime'].to_i
    @timer_label.text = "%02d:%02d" % [mins, 00]
    pomodoro_timer.setUpShortBreak
  end

  def longBreak
    mins = App::Persistence['longBreakTime'].to_i
    @timer_label.text = "%02d:%02d" % [mins, 00]
    pomodoro_timer.setUpLongBreak
  end

  def pomodoro
    mins = 25
    @timer_label.text = "%02d:%02d" % [mins, 00]
    pomodoro_timer.setUpPomodoro
  end

  def startTimer
    if pomodoro_timer.count <= 0
      App.alert("Set up timer.")
    elsif pomodoro_timer && pomodoro_timer.valid?
      pomodoro_timer.invalidate
    else
      start_new_pomodoro_timer
    end
  end

  def pomodoro_timer_did_start(pomodoro_timer)
    @startButton.backgroundColor = UIColor.redColor
    @startButton.setTitle("Stop")
    update_timer_label
  end

  def pomodoro_timer_did_invalidate(pomodoro_timer)
    @startButton.backgroundColor = UIColor.greenColor
    @startButton.setTitle("Start")
    update_timer_label
  end

  def pomodoro_timer_did_decrement(pomodoro_timer)
    update_timer_label
  end

  def pomodoro_timer_did_finish(pomodoro_timer)
    pomodoro_timer.invalidate
  end

  def resetPomodoros
    App.alert('resetujemy')
  end

  def setPomodorsCountLabel
    @pomodoros_made_count_label.text = "33"
  end

  private

  def start_new_pomodoro_timer
    pomodoro_timer.delegate = self
    pomodoro_timer.start
  end

  def update_timer_label
    mins = pomodoro_timer.count / 60
    secs = pomodoro_timer.count % 60
    @timer_label.text = "%02d:%02d" % [mins, secs]
  end

  def pomodoro_timer
    @pomodoro_timer ||= PomodoroTimer.new
  end
end
