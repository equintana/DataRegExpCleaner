require_relative 'data_regexp_cleaner'

class User < DataRegExpCleaner
   attr_accessor :id, :name

  regexp_cleaner :id, /[a-zA-Z]/
  regexp_cleaner :name, /r/
end

u = User.new
u.id = 11295218
u.name = "Erlinis Lascarro"
u.save

u2 = User.new
u2.id = 333
u2.name = "Maria Plata"
u2.save

u3 = User.get(222)
puts  "name u3: #{u3.name}" if u3

u3.name = "Pedro"
u3.update
# u3.update