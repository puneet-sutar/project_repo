module Rules
  def exist?(input,dbh)
      sth = dbh.prepare("select * from #{input[0]} where #{input[1]}")
      sth.execute()
      if sth.none? == true
         return false 
      end
      return true
  end  
  def lessthen?(input,dbh)
      sth = dbh.prepare("select * from #{input[0]} where #{input[3]} and #{input[1]} < #{input[2]}")
      sth.execute()
      if sth.none? == false
         return true 
      end
      puts false
      return false         
  end
  def greaterthen?(input,dbh)
      sth = dbh.prepare("select * from #{input[0]} where #{input[3]} and #{input[1]} > #{input[2]}") 
      sth.execute()
      if sth.none? == false
          puts true
         return true 
      end
      puts false
      return false
  end
  def on_input_greaterthen?(input)
      if input[0] > input[1]
          puts true
         return true 
      end
      puts false
      return false
  end
  def equal?(input,dbh)
    sth = dbh.prepare("select * from #{input[0]} where #{input[3]} and #{input[1]} = #{input[2]}") 
    sth.execute()
    if sth.none? == false
        return true
    end
    return false
  end
 
  def not_equal?(input,dbh)
    sth = dbh.prepare("select * from #{input[0]} where #{input[3]} and #{input[1]} < #{input[2]}") 
    sth.execute()
    if sth.none? == false
        return true 
    end
    return false
  end
end
=begin include Rules
begin
     # connect to the MySQL server
     dbh = DBI.connect("DBI:Mysql:project:localhost","root", "123")
greaterthen?(["Account","id=111232345","id","1000"],dbh)     
  rescue DBI::DatabaseError => e
     puts "An error occurred"
     puts "Error code:    #{e.err}"
     puts "Error message: #{e.errstr}"
  ensure
     # disconnect from server
     dbh.disconnect if dbh
  end
=end