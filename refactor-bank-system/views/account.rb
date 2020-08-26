module View
  class Account
    def initialize(previous_page:)
      @previous_page = previous_page
      @account_manager = Manager::AccountManager.new
      @loaded_account = nil
      @name_field = nil
      @login_field = nil
      @password_field = nil
      @age_field = nil
      @errors = []
    end

    def create
      puts @account_manager.file_path
      loop do
        name_input
        age_input
        login_input
        password_input
        break if @errors.empty?

        @errors.each do |e|
          puts e
        end
        @errors = []
      end
      @account_manager.create(name: @name_field, login: @login_field, password: @password_field, age: @age_field)
    end

    def load
      loop do
        return create_the_first_account if @account_manager.store_empty?

        puts 'Enter your login'
        login = gets.chomp
        puts 'Enter your password'
        password = gets.chomp

        @loaded_account = @account_manager.load(login: login, password: password)
        if @loaded_account
          break
        else
          puts 'There is no account with given credentials'
        end
      end
      @loaded_account
    end

    def create_the_first_account
      puts 'There is no active accounts, do you want to be the first?[y/n]'
      if gets.chomp == 'y'
        create
      else
        @previous_page.console
      end
    end

    def destroy_account(account:)
      puts 'Are you sure you want to destroy account?[y/n]'
      command = gets.chomp
      @account_manager.destroy(account: account) if command == 'y'
    end

    private

    def name_input
      puts 'Enter your name'
      @name_field = gets.chomp
      unless @name_field != '' && @name_field[0].upcase == @name_field[0]
        @errors.push('Your name must not be empty and starts with first upcase letter')
      end
    end

    def login_input
      puts 'Enter your login'
      @login_field = gets.chomp
      @errors.push('Login must present') if @login_field == ''

      @errors.push('Login must be longer then 4 symbols') if @login_field.length < 4

      @errors.push('Login must be shorter then 20 symbols') if @login_field.length > 20

      @errors.push('Such account is already exists') if @account_manager.exists?(@login_field)
    end

    def password_input
      puts 'Enter your password'
      @password_field = gets.chomp
      @errors.push('Password must present') if @password_field == ''

      @errors.push('Password must be longer then 6 symbols') if @password_field.length < 6

      @errors.push('Password must be shorter then 30 symbols') if @password_field.length > 30
    end

    def age_input
      puts 'Enter your age'
      @age_field = gets.chomp
      if @age_field.to_i.is_a?(Integer) && @age_field.to_i >= 23 && @age_field.to_i <= 90
        @age_field = @age_field.to_i
      else
        @errors.push('Your Age must be greeter then 23 and lower then 90')
      end
    end
  end
end
