=begin
	
- Los attr_accessor de una clase se definen o se crean en la clase Module
	
=end

module DataCleaner
  
  def DataCleaner.included( clazz ) 
     puts "This mod was included by #{clazz}"

     module_eval( "def attr_cleaner() puts 'algo'; end" )
  end


  def save() 
    puts " save method> object #{self}"
    puts self.attr_cleaner()
  end

end


class Foo 
      include DataCleaner

      attr_accessor :bar, name

      regexp_cleaner :bar, /a/

end



fb = Foo.new
fb.bar = "hello"
puts fb.bar  # >> hello
fb.save

