require "rubygems"
require "xmlsimple"
require "dbi"
require "Operations.rb"
require "Rules.rb"
require "Atom.rb"
require "../modules/mod1.rb"
$MYSQL_USER="root"
$PASSWORD="123"
$DATABASE="project"
$IP="localhost"

class LegacySystem
  def initialize
    @global_rules=[]
  end  
  def response
    $request=XmlSimple.xml_in("../request.xml")
    $opname=$request['op_name'][0]
    $input=$request['input'][0]
    $object=XmlSimple.xml_in("../objects/objects.xml")
    @operation=Operation.new($opname)
begin
     # connect to the MySQL server
     dbh = DBI.connect("DBI:Mysql:#{$DATABASE}:#{$IP}",$MYSQL_USER, $PASSWORD)
     dbh['AutoCommit'] = false
     result=@operation.execute(dbh)
     dbh.commit if result==true
rescue DBI::DatabaseError => e
     dbh.rollback 
     puts "An error occurred"
     puts "Error code:    #{e.err}"
     puts "Error message: #{e.errstr}"
ensure
     # disconnect from server
     dbh['AutoCommit'] = true
     dbh.disconnect if dbh
end
    
  end
end
l=LegacySystem.new
l.response