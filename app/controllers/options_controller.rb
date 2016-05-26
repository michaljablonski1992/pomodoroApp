class OptionsController < UIViewController

  def self.controller
    @controller ||= OptionsController.alloc.initWithNibName(nil, bundle:nil)
  end

  def viewDidLoad
    super

    self.title = "Options"
    self.view.backgroundColor = UIColor.whiteColor

    @containerView = UIView.alloc.initWithFrame([[0, 50], [self.view.frame.size.width, self.view.frame.size.height]])

    @label_short_break = UILabel.alloc.initWithFrame([[10, 38], [(self.view.frame.size.width  / 2) - 15, 40]])
    @label_short_break.text = "Short break time:"
    @label_short_break.sizeToFit
    @containerView.addSubview(@label_short_break)

    @input_field_short_break = UITextField.alloc.initWithFrame([[(self.view.frame.size.width  / 2), 35], [(self.view.frame.size.width  / 2) - 15, 30]])
    @input_field_short_break.text = App::Persistence['shortBreakTime'].to_s
    @input_field_short_break.textColor = UIColor.blackColor
    @input_field_short_break.backgroundColor = UIColor.whiteColor
    @input_field_short_break.setBorderStyle UITextBorderStyleRoundedRect

    @containerView.addSubview(@input_field_short_break)


    @label_long_break = UILabel.alloc.initWithFrame([[10, 78], [(self.view.frame.size.width  / 2) - 15, 40]])
    @label_long_break.text = "Long break time:"
    @label_long_break.sizeToFit
    @containerView.addSubview(@label_long_break)

    @input_field_long_break = UITextField.alloc.initWithFrame([[(self.view.frame.size.width  / 2), 75], [(self.view.frame.size.width  / 2) - 15, 30]])
    @input_field_long_break.text = App::Persistence['longBreakTime'].to_s
    @input_field_long_break.textColor = UIColor.blackColor
    @input_field_long_break.backgroundColor = UIColor.whiteColor
    @input_field_long_break.setBorderStyle UITextBorderStyleRoundedRect

    @containerView.addSubview(@input_field_long_break)

    @saveButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @saveButton.frame = [[70, 125], [(self.view.frame.size.width) - 140, 30]]
    @saveButton.backgroundColor = UIColor.cyanColor
    @saveButton.setTitle('Save', forState: UIControlStateNormal)
    @saveButton.addTarget(self,
                            action:'saveOptions',
                            forControlEvents:UIControlEventTouchUpInside)

    @containerView.addSubview(@saveButton)

    self.view.addSubview(@containerView)
  end


  def saveOptions
    errors = ""

    if @input_field_short_break.text.to_i > 0
      App::Persistence['shortBreakTime'] = @input_field_short_break.text
    else
      errors << "Short break time have to be positive integer and not blank. \n"
    end

    if @input_field_long_break.text.to_i > 0
      App::Persistence['longBreakTime'] = @input_field_long_break.text
    else
      errors << "Long break time have to be positive integer and not blank. \n"
    end

    if errors.empty?
      App.alert("Options saved!")
    else
      App.alert(errors)
    end
  end

end
