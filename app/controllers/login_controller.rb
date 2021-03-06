class LoginController < Formotion::FormController
  API_LOGIN_ENDPOINT = "https://pomodoro--app.herokuapp.com/api/v1/sessions.json"

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
          title: "Password",
          key: :password,
          placeholder: "required",
          type: :string,
          secure: true
        }],
      }, {
        rows: [{
          title: "Login",
          type: :submit,
        }]
      }]
    })
    form.on_submit do
      self.login
    end
    super.initWithForm(form)
  end

  def viewDidLoad
    super

    self.title = "Login"
  end

  def login
    headers = { 'Content-Type' => 'application/json' }
    data = BW::JSON.generate({ user: {
                                 email: form.render[:email],
                                 password: form.render[:password]
                                } })

    BW::HTTP.post(API_LOGIN_ENDPOINT, { headers: headers, payload: data } ) do |response|
      if response.status_description.nil?
        App.alert(response.error_message)
      else
        if response.ok?
          json = BW::JSON.parse(response.body.to_s)
          App::Persistence['authToken'] = json['data']['auth_token']
          App.alert(json['info'])
          @menuController = MainMenuController.alloc.init
          self.navigationController.pushViewController(@menuController, animated:false)
        elsif response.status_code.to_s =~ /40\d/
          App.alert("Login failed")
        else
          App.alert(response.to_s)
        end
      end
    end
  end
end
