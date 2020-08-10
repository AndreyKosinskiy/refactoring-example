require_relative 'bootstrap.rb'

default_account = {
  name: 'Mars',
  login: 'Mars',
  password: '123123123',
  age: 34,
  card: []
}
account = Manager::AccountManager.new.create(**default_account)
account.add_card(type: 'usual')
