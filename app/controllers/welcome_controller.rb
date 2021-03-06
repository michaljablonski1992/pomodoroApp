class WelcomeController < UIViewController

  def self.controller
    @controller ||= WelcomeController.alloc.initWithNibName(nil, bundle:nil)
  end

  def viewDidLoad
    super

    self.title = "Welcome"
    self.view.backgroundColor = UIColor.whiteColor
    self.view.tintColor = UIColor.blackColor


    @containerView = UIView.alloc.initWithFrame([[0, 50], [self.view.frame.size.width, self.view.frame.size.height]])

    @welcomeTitleLabel = UILabel.alloc.initWithFrame([[10, 25], [self.view.frame.size.width - 20, 20]])
    @welcomeTitleLabel.font = UIFont.boldSystemFontOfSize(20)
    @welcomeTitleLabel.text = 'Welcome to the App!'

    @containerView.addSubview(@welcomeTitleLabel)

    @welcomeLabel = UILabel.alloc.initWithFrame([[10, 45], [self.view.frame.size.width - 20, 20]])
    @welcomeLabel.text = 'Please select an option to start using it!'

    @containerView.addSubview(@welcomeLabel)

    @registerButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @registerButton.frame = [[10, 95], [(self.view.frame.size.width  / 2) - 15, 30]]
    @registerButton.setTitle('Register', forState: UIControlStateNormal)
    @registerButton.backgroundColor = UIColor.cyanColor
    @registerButton.addTarget(self,
                              action:'register',
                              forControlEvents:UIControlEventTouchUpInside)

    @containerView.addSubview(@registerButton)

    @loginButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @loginButton.frame = [[(self.view.frame.size.width  / 2) + 5, 95], [(self.view.frame.size.width  / 2) - 15, 30]]
    @loginButton.setTitle('Login', forState: UIControlStateNormal)
    @loginButton.backgroundColor = UIColor.cyanColor
    @loginButton.addTarget(self,
                           action:'login',
                           forControlEvents:UIControlEventTouchUpInside)

    @containerView.addSubview(@loginButton)

    self.view.addSubview(@containerView)
  end

  def register
    @registerController = RegisterController.alloc.init
    self.navigationController.pushViewController(@registerController, animated:false)
  end

  def login
    @loginController = LoginController.alloc.init
    self.navigationController.pushViewController(@loginController, animated:false)
  end
end
