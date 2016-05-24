# file app/app_delegate.rb
class AppDelegate

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    @navigationController = UINavigationController.alloc.init
    @window.rootViewController = @navigationController

    if App::Persistence['authToken'].nil?
      showWelcomeController
    else
      showTasksListController
    end

    @window.makeKeyAndVisible

    return true
  end

  def showWelcomeController
    @welcomeController = WelcomeController.alloc.init
    @navigationController.pushViewController(@welcomeController, animated:false)
  end

  def showTasksListController
    @tasksController = TasksListController.alloc.init
    @navigationController.pushViewController(@tasksController, animated:false)
  end

end
