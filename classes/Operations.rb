#Errors returened 
# -1 opname not valid  -- from initialize
class Operation
  attr_reader :id
  attr_reader :name
  attr_reader :type
  attr_reader :process
  attr_reader :rules
  attr_reader :return
  def initialize
    
  end
  def initialize(opname)
     create(opname) 
  end
  def create(opname)
    fin=File.open("../operations/operations.info")
    operations=fin.read.split(" ")
    if operations.include?(opname)==false
      puts "invalid operation name : #{opname}"
      return -1
    end
    hash=XmlSimple.xml_in("../operations/#{opname}.xml")
    @id=operations.index(opname)
    @name=opname
    @type="operation"
    @process=hash['process'][0]['name']
    @rules=[]
    if(hash.key?("rules")==true)
      @rules=hash["rules"]
    end
    
    @return=hash['return']
  end
  def execute(dbh)
    @rules.each do |rule|
       result=Rule.new(rule).execute(dbh) if rule['trigger']=="before"
       if(result==false)
         puts "rule broken "
         dbh.rollback
         return false
       end
    end
    if(!@process.nil?) ##if starts
    @process.each do |process|
      if (process['type']=="operation")
        return false if Operation.new(process['content'].first).execute(dbh)==false
      elsif(process['type']=="atom")
        Atom.new(process['content'].first).execute(process['input'],dbh) 
      else
        puts "invalid operation type : #{process['type']}"  
      end
    end
    end   #if ends
    @rules.each do |rule|
       result=Rule.new(rule).execute(dbh) if rule['trigger']=="after"
       if(result==false)
         puts "rule broken "
         dbh.rollback
         return false
       end
    end
    if $opname==self.name
      output=[]
      
      response=File.open("response.xml","w")
      response.puts "<response.xml>"
      response.puts "<output>"
      @return.each do |i|
        input=i['value']
        rs=Atom.new("return")
        result=rs.execute(input,dbh)
        result.each do |key,value|
          response.puts "<#{key}>#{value}</#{key}>"
        end
      end
      response.puts "</output>"
      response.puts "</response.xml>"
      response.close
           
    end      
    return true  
  end
  
end
