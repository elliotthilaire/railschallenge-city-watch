class ResponseReport
	def self.generate
	  [ 
	  	Emergency.where(full_response: true).count, 
	  	Emergency.count 
	  ]
	end
end
