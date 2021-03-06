class RegisterController < Formotion::FormController
  API_REGISTER_ENDPOINT = "https://pomodoro--app.herokuapp.com/api/v1/registrations.json"

  def init
    form = Formotion::Form.new({
      sections: [{
        rows: [{
          title: "Email",
          key: :email,
          placeholder: "me@mail.com",
          type: :email,
          auto_correction: :no,
          auto_capitalization: :none
        }, {
          title: "Username",
          key: :name,
          placeholder: "choose a name",
          type: :string,
          auto_correction: :no,
          auto_capitalization: :none
        }, {
          title: "Password",
          key: :password,
          placeholder: "required",
          type: :string,
          secure: true
        }, {
          title: "Confirm Password",
          key: :password_confirmation,
          placeholder: "required",
          type: :string,
          secure: true
        }],
      }, {
        title: "Your email address will always remain private.\nBy clicking Register you are indicating that you have read and agreed to the terms of service",
        rows: [{
          title: "Register",
          type: :submit,
        }]
      }]
    })
    form.on_submit do
      self.register
    end
    super.initWithForm(form)
  end

  def viewDidLoad
    super

    self.title = "Register"
  end

  def register
    headers = { 'Content-Type' => 'application/json' }
    data = BW::JSON.generate({ user: {
                                 email: form.render[:email],
                                 name: form.render[:name],
                                 password: form.render[:password],
                                 password_confirmation: form.render[:password_confirmation]
                                } })

    if form.render[:email].empty? || form.render[:name].empty? || form.render[:password].empty? || form.render[:password_confirmation].empty?
      App.alert("Please complete all the fields")
    else
      if form.render[:password] != form.render[:password_confirmation]
        App.alert("Your password doesn't match confirmation, check again")
      else
        BW::HTTP.post(API_REGISTER_ENDPOINT, { headers: headers , payload: data } ) do |response|
          if response.status_description.nil?
            App.alert(response.error_message)
          else
            if response.ok?
              json = BW::JSON.parse(response.body.to_s)
              App::Persistence['authToken'] = json['data']['auth_token']
              @menuController = MainMenuController.alloc.init
              self.navigationController.pushViewController(@menuController, animated:false)
            elsif response.status_code.to_s =~ /40\d/
              App.alert("Registration failed")
            else
              json = BW::JSON.parse(response.body.to_s)
              error = ""
              json['info'].each do |k, v|
                error << "#{k.capitalize}: #{v.first}. \n"
              end
              App.alert(error)
            end
          end
        end
      end
    end
  end
end
