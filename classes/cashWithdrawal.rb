require 'Qt4'
require "main.rb"
require "../modules/prompts.rb"
require "rubygems"
require "xmlsimple"
    class Debit < Qt::Widget
      include Prompt
      slots "check()"
      slots "done()"
      @count=1
      def initialize(parent=nil)
        super()
        window.resize(621, 403)
    @label = Qt::Label.new(window)
    @label.objectName = "label"
    @label.text = "Account id"
    @label.geometry = Qt::Rect.new(40, 80, 91, 31)
    @lineEdit = Qt::LineEdit.new(window)
    @lineEdit.objectName = "lineEdit"

    @lineEdit.geometry = Qt::Rect.new(190, 80, 161, 31)
    @label_2 = Qt::Label.new(window)
    @label_2.objectName = "label_2"
    @label_2.geometry = Qt::Rect.new(40, 140, 67, 17)
    @label_2.text = "Amount"
    @lineEdit_2 = Qt::LineEdit.new(window)
    @lineEdit_2.objectName = "lineEdit_2"
    @lineEdit_2.geometry = Qt::Rect.new(190, 130, 161, 31)
    @pushButton = Qt::PushButton.new(window)
    @pushButton.objectName = "pushButton"
    @pushButton.geometry = Qt::Rect.new(50, 300, 98, 27)
    @pushButton.text = "check"

    @pushButton_2 = Qt::PushButton.new(window)
    @pushButton_2.objectName = "pushButton_2"
    @pushButton_2.geometry = Qt::Rect.new(200, 300, 98, 27)
    @pushButton_2.text = "done"
    @label_3 = Qt::Label.new(window)
    @label_3.objectName = "label_3"
    @label_3.geometry = Qt::Rect.new(40, 190, 67, 17)
    @label_3.text = "Balance"

    @lineEdit_3 = Qt::LineEdit.new(window)
    @lineEdit_3.objectName = "lineEdit_3"
    @lineEdit_3.geometry = Qt::Rect.new(190, 180, 161, 31)
    @label_3.hide
    @lineEdit_3.hide
    
    @label_4 = Qt::Label.new(window)
    @label_4.objectName = "label_3"
    @label_4.geometry = Qt::Rect.new(40, 240, 67, 17)
    @label_4.text = "Name"

    @lineEdit_4 = Qt::LineEdit.new(window)
    @lineEdit_4.objectName = "lineEdit_3"
    @lineEdit_4.geometry = Qt::Rect.new(190, 240, 161, 31)
    @label_4.hide
    @lineEdit_4.hide
    connect(@pushButton,SIGNAL("clicked()"),self,SLOT("check()"))
    connect(@pushButton_2,SIGNAL("clicked()"),self,SLOT("done()"))
      end
      def check()
         request=File.open("../request.xml","w")
         request.puts"<request.xml>"
         request.puts"<trans_id>#{@count}</trans_id>"
         request.puts"<op_id>1</op_id>"
         request.puts"<op_name>check</op_name>"
         request.puts "<input>"
         request.puts "<id>#{@lineEdit.text}</id>"
         request.puts "</input>" 
         request.puts"</request.xml>"
         request.close
         ls=LegacySystem.new
         result=ls.response
         hash=XmlSimple.xml_in("response.xml")
         @lineEdit_3.text=hash['output'][0]['bal'][0]
         @label_3.show
         @lineEdit_3.show
         @lineEdit_4.text=hash['output'][0]['name'][0]
         @label_4.show
         @lineEdit_4.show
        
      end
      def done
        request=File.open("../request.xml","w")
        request.puts"<request.xml>"
        request.puts"<trans_id>#{@count}</trans_id>"
         request.puts"<op_id>1</op_id>"
         request.puts"<op_name>Debit</op_name>"
         request.puts "<input>"
         request.puts "<id>#{@lineEdit.text}</id>"
         request.puts "<amt>#{@lineEdit_2.text}</amt>"
         request.puts "</input>" 
         request.puts"</request.xml>"
         request.close
         ls=LegacySystem.new
         ls.response
         hash=XmlSimple.xml_in("response.xml")
         @lineEdit_3.text=hash['output'][0]['bal'][0]
         @label_3.show
         @lineEdit_3.show
         @lineEdit_4.text=hash['output'][0]['name'][0]
         @label_4.show
         @lineEdit_4.show
          ok("confirmation","balance successfully updated!!!!!!")
      end
 end
app = Qt::Application.new(ARGV)

widget = Debit.new()
widget.show()

app.exec()
#puts 'hello'

