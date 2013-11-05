require 'csv'
class DataRegExpCleaner

  CLEANER_METHOD_SUFFIX = "_regexp_cleaner"
  DATA_DIRECTORY = "data"
  @@all_fields = Hash.new{ |hash,key| hash[key] = [] }

  def initialize( args )
    args.each do |key,value|
      self.instance_variable_set("@#{key}", value) unless value.nil?
    end
  end
 
  def self.regexp_cleaner(field_name, regexp)
    @@all_fields[:"#{self}"].push(field_name)

    send(:define_method, "#{field_name}#{CLEANER_METHOD_SUFFIX}"){ | value |
      if regexp.match(value.to_s)  
        field_value_cleaned = value.to_s.gsub( regexp , "")  
        send( "#{field_name}=", field_value_cleaned)  
      end
    }
  end 

  def self.get( id )
    instance = find_in_file( id )
  end

  def save
    fields = @@all_fields[:"#{self.class}"]
    clean_fields( fields )
    save_in_file 
  end

  def update
    fields = @@all_fields[:"#{self.class}"]
    clean_fields( fields )
    update_in_file
  end
  
  def destroy
    delete_from_file
  end

  private
  def clean_fields( fields )
    fields.each do |field_name|
      send("#{field_name}#{CLEANER_METHOD_SUFFIX}", send("#{field_name}"))
    end
  end

  def extract_data
    fields = @@all_fields[:"#{self.class}"]
    data = []
     fields.each do |field_name|
        data << send("#{field_name}")
      end
    data
  end

  def self.parse_instance( data )
    instance_info = {}
    fields = @@all_fields[:"#{self.to_s}"]
    
    fields.each_with_index do |field_name, index|
      instance_info[field_name] = data[index]
    end   
    instance_info
  end

  def self.find_in_file( id )
    file_name = "#{DATA_DIRECTORY}/#{self.to_s}.csv"
    instance = nil
    if File.exist?( file_name )
      CSV.open( file_name , "r" ) do |row|
        if (row.first.to_s == id.to_s )
            instance = self.new( self.parse_instance( row ) )
        end
      end
    end
    return instance
  end

  def save_in_file
    file_name = "#{DATA_DIRECTORY}/#{self.class.name}.csv"
    data = extract_data 
    if !self.class.get( data.first )
      CSV.open( file_name , "w") do |csv|
        csv << data 
      end
      puts " #{self}  ...saved "
    end
  end

  def update_in_file
    file_name = "#{DATA_DIRECTORY}/#{self.class.name}.csv"
    current_lines = CSV.readlines(file_name)

    CSV.open( file_name , "w" ) do |csv|
      current_lines.each do | item |
        csv_data = item
        if ( item.first == self.id.to_s )
          csv_data = extract_data
          puts " #{self}  ...updated "
        end
        csv << csv_data
      end
    end
  end

  def delete_from_file
    file_name = "#{DATA_DIRECTORY}/#{self.class.name}.csv"
    current_lines = CSV.readlines(file_name)

    CSV.open( file_name , "w" ) do |csv|      
      current_lines.each do | item |
        if ( item.first == self.id.to_s )
          puts " #{self}  ...deleted "
        else
           csv << item
        end
      end
    end
  end


end




