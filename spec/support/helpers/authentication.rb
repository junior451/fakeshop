module Helpers
  module Authentication
    def login
      user = create(:user)

      if respond_to? :visit
        visit login_path

        fill_in 'Username', with: user.username
        fill_in 'Password', with: user.password

        click_button 'Login'
      else
        post login_path, params: { username: user.username, password: user.password }
      end

    end
  end
end