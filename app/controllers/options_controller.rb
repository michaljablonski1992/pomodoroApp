class OptionsController < UIViewController

  def self.controller
    @controller ||= OptionsController.alloc.initWithNibName(nil, bundle:nil)
  end

  def viewDidLoad
    super

    self.title = "Options"
    self.view.backgroundColor = UIColor.whiteColor
  end
end
