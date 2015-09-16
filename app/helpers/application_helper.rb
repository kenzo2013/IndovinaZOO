module ApplicationHelper

	def flash_display
		response = ""
		flash.each do |key, value|
			response = response + content_tag(:div, value, id: "flash_#{key}")
		end
		flash.discard
		response		
	end
end
