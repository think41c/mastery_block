values = [1,2,3,4]
p total = values.inject(0) { |sum, element| sum + element }  # 10
p total = values.inject(0,&:+)  # This line is the equivalent of the one above. 
