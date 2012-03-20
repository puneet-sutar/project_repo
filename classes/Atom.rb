require "../modules/mod1.rb"
class Atom
  include Validations
  attr_reader :id
  attr_reader :name
  attr_reader :type
  attr_reader :input
  
  def initialize
    
  end
  def initialize(opname)
     create(opname) 
  end
  def create(opname)
    fin=File.open("../atomic/atom.info")
    atoms=fin.read.split(" ")
    if atoms.include?(opname)==false
      puts "invalid atom name : #{opname}"
      return -1
    end
    hash=XmlSimple.xml_in("../atomic/#{opname}.xml")
    @id=atoms.index(opname)
    @name=opname
    @type="operation"
  end
  def execute(input,dbh)
    prepare(input)
    puts @input
    case @name
      when "update"
        update(dbh)
      when "insert"
        insert(dbh) 
    end
        #@input=prepare(input)
  end
  def update(dbh)
    puts "update #{@input[0]}_updatable set #{@input[1]} = #{@input[2]} WHERE  #{@input[3]}"
    if @input[3]==nil
      sth = dbh.prepare("update #{@input[0]}_updatable set #{@input[1]} = #{@input[2]}") #non conditonal update
    else
      sth = dbh.prepare("update #{@input[0]}_updatable set #{@input[1]} = #{@input[2]} WHERE  #{@input[3]}") #conditional update    
    end
    puts sth.execute()
  end
  def select(dbh)
    puts "update #{@input[0]}_updatable set #{@input[1]} = #{@input[2]} WHERE  #{@input[3]}"
    if @input[3]==nil
      sth = dbh.prepare("update #{@input[0]}_updatable set #{@input[1]} = #{@input[2]}") #non conditonal update
    else
      sth = dbh.prepare("update #{@input[0]}_updatable set #{@input[1]} = #{@input[2]} WHERE  #{@input[3]}") #conditional update    
    end
    puts sth.execute()
  end
  def delete(dbh)
    values=[]
    values=@input
    value.delete_at(0)
    values=values.map{|i| i="\'"+i+"\'"}
    values=values.join(",")  
    sth = dbh.prepare("insert into #{@input[0]}_updatable values ( #{values} )") #non conditonal update
    puts sth.execute()
    puts "---------------",@input.class
  end
  def insert(dbh)
    values=[]
    values=@input
    value.delete_at(0)
    values=values.join(",")  
    sth = dbh.prepare("insert into #{@input[0]}_updatable values ( #{values} )") #non conditonal update
    puts sth.execute()
    puts "---------------",@input.class
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