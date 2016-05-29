class PomodoroPanelController < UIViewController
  API_POMODOROS_COUNT_ENDPOINT = "https://pomodoro--app.herokuapp.com/api/v1/pomodoros_made.json"


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

    prepare_timer
  end

  def pomodoro_timer
    @pomodoro_timer ||= PomodoroTimer.new
  end

  def prepare_timer
    pomodoros_made = App::Persistence['pomodorosMade']
    pomodoro_timer.pomodoros_made = pomodoros_made
    setPomodorosMadeLabel
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
    if pomodoro_timer.pomodoro?
      pomodoro_timer.pomodoros_made += 1
      updatePomodoros(pomodoro_timer.pomodoros_made)
      App::Persistence['pomodorosMade'] = pomodoro_timer.pomodoros_made
      setPomodorosMadeLabel
      App.alert("It's end of the pomodoro. Take a break.")
    else
      App.alert("It's end of the break. Pomodoro time!")
    end
    pomodoro_timer.invalidate
  end

  def setPomodorosMadeLabel
    @pomodoros_made_count_label.text = App::Persistence['pomodorosMade'].to_s
  end

  def resetPomodoros
    updatePomodoros(0)
    App::Persistence['pomodorosMade'] = 0
    setPomodorosMadeLabel
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

  def updatePomodoros(count)
    headers = { 'Content-Type' => 'application/json' }
    data = BW::JSON.generate({ user: {
                                 auth_token: App::Persistence['authToken']
                               },
                                pomodoros_made: {
                                  count: count
                                  } })

    BW::HTTP.put(API_POMODOROS_COUNT_ENDPOINT, { headers: headers, payload: data } ) do |response|
      if response.status_description.nil?
        App.alert(response.error_message)
      else
        if response.ok?
          #App::Persistence['pomodorosMade'] = count
        elsif response.status_code.to_s =~ /40\d/
          App.alert("Update failed")
        else
          App.alert(response.to_s)
        end
      end
    end
  end

  def getPomodorosMade
    headers = { 'Content-Type' => 'application/json' }
    data = { auth_token: App::Persistence['authToken'] }

    BW::HTTP.get(API_POMODOROS_COUNT_ENDPOINT, { headers: headers, payload: data } ) do |response|
      if response.status_description.nil?
        App.alert(response.error_message)
      else
        if response.ok?
          json = BW::JSON.parse(response.body.to_s)
          @pomodoros_made = json['data']['count']
          App::Persistence['pomodorosMade'] = @pomodoros_made
        elsif response.status_code.to_s =~ /40\d/
          App.alert("Get failed!")
        else
          App.alert(response.to_s)
        end
      end
    end
  end

end
