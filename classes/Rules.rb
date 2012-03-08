require "../modules/mod1.rb"
class Rule
  include Validations
  attr_reader :name
  attr_reader :error
  attr_reader :input
  attr_reader :on_input
  attr_reader :trigger
  def initialize(rule)
    @name=rule['name']
    @error=rule['error']
    @input=rule['input']
    @on_input=rule['on_input']
    @trigger=rule['trigger']
  end
  def execute(dbh)
    prepare(@input)
    puts @input.join(":")
    
  end
  def prepare(input)
    str=input.split(":")
    object={}
    table=str[0]
    $object['object'].each do |obj|
      if(obj['name'][0]['value']==table)
        object=obj
      end
    end
    if object=={}
      puts "error: Table Does Not Exist"
    end
    index=1
    while index<str.length
      rhs_split=str[index].split(" ")
      i=0
      while i<rhs_split.length
        if rhs_split[i][0]==35  ##ascii value of #=35
          temp=rhs_split[i].split("#")[1]
          rhs_split[i]=$input[temp]
        elsif is_i?(rhs_split[i])
          puts ""       
        else
          flag=false
          object["attr"].each do |attr|
            if(attr["content"]==rhs_split[i])
              flag=true
            end
          end
          if flag==false
            puts "invalid while creating operation"
          end  
        end
        i=i+1
      end
      str[index]=rhs_split.join(" ");
      index=index+1;
    end
    @input=str
  end
end
