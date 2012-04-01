module Prompt
	def ok_cancel(head,str)
    	decision =Qt::MessageBox::question self, head,str, Qt::MessageBox::Ok, Qt::MessageBox::Cancel
    	case decision
        when Qt::MessageBox::Ok
            return true
        when Qt::MessageBox::Cancel
            return false
    	end
  end
  def ok(head,str)
   	decision =Qt::MessageBox::information self, head,str, Qt::MessageBox::Ok
   	case decision
       when Qt::MessageBox::Ok
           return true
      end
	 end
	def input()
	  puts hello
	 end
end

