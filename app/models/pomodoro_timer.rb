class PomodoroTimer
  attr_accessor :count
  attr_accessor :ns_timer
  attr_accessor :pomodoros_made
  attr_accessor :pomodoro_set_up
  attr_reader :delegate

  def initialize
    self.count = 0
    self.pomodoro_set_up = false
  end

  def setUpPomodoro
    minutes = 25
    @count = minutes * 60
    self.pomodoro_set_up = true
  end

  def setUpShortBreak
    minutes = App::Persistence['shortBreakTime'].to_i
    @count = minutes * 60
    self.pomodoro_set_up = false
  end

  def setUpLongBreak
    minutes = App::Persistence['longBreakTime'].to_i
    @count = minutes * 60
    self.pomodoro_set_up = false
  end

  def delegate=(object)
    @delegate = WeakRef.new(object)
  end

  def start
    invalidate if ns_timer
    self.ns_timer = NSTimer.timerWithTimeInterval(1, target: self,
      selector: 'decrement', userInfo: nil, repeats: true)
    NSRunLoop.currentRunLoop.addTimer(ns_timer,
      forMode: NSDefaultRunLoopMode)
    delegate.pomodoro_timer_did_start(self) if delegate
  end

  def valid?
    ns_timer && ns_timer.valid?
  end

  def invalidate
    ns_timer.invalidate
    delegate.pomodoro_timer_did_invalidate(self) if delegate
  end

  def pomodoro?
    self.pomodoro_set_up == true
  end

  private

  def decrement
    self.count -= 1
    return if delegate.nil?
    if count > 0
      delegate.pomodoro_timer_did_decrement(self)
    else
      delegate.pomodoro_timer_did_finish(self)
    end
  end

end
