require_relative 'data_regexp_cleaner'

class Account < DataRegExpCleaner
   attr_accessor  :id, :name, :address, :balance

  regexp_cleaner :id, /[a-zA-Z]/
  regexp_cleaner :name, /[0-9]/
  regexp_cleaner :address, /#/
  regexp_cleaner :balance, /\./
  
end

a = Account.new
a.name = "Mr MooCow 34"
a.address = "212 Main St."
a.balance = 3_000_000
a.save
