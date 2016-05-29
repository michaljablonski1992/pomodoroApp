# file app/app_delegate.rb
class AppDelegate

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    @navigationController = UINavigationController.alloc.init
    @window.rootViewController = @navigationController
    setDefaultOptions

    if App::Persistence['authToken'].nil?
      showWelcomeController
    else
      showMainMenuController
    end

    @window.makeKeyAndVisible

    return true
  end

  def showWelcomeController
    @welcomeController = WelcomeController.alloc.init
    @navigationController.pushViewController(@welcomeController, animated:false)
  end

  def showMainMenuController
    @menuController = MainMenuController.alloc.init
    @navigationController.pushViewController(@menuController, animated:false)
  end


  def logout
    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Token token=\"#{App::Persistence['authToken']}\""
    }

    BW::HTTP.delete("https://pomodoro--app.herokuapp.com/api/v1/sessions.json", { headers: headers }) do |response|
      App::Persistence['authToken'] = nil
      showWelcomeController
    end
  end

  def setDefaultOptions
    App::Persistence['shortBreakTime'] = "5" if App::Persistence['shortBreakTime'].nil?
    App::Persistence['longBreakTime'] = "15" if App::Persistence['longBreakTime'].nil?
    App::Persistence['pomodorosMade'] = 0 if App::Persistence['pomodorosMade'].nil?
  end

end
