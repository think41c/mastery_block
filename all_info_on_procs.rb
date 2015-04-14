# Blocks, Procs (PROCedure - eg. instructions to do something), and Lambdas are all examples of "closures". 
# Blocks are chunks of code that can't be stored as a variable - blocks are method syntax, are't objects, can't stand alone.
# Blocks are a rare execption in ruby where the common idea is 'everything is an object' (b/c blocks aren't objects)
# Blocks are just syntax of a method call. You can wrap a block into an object, when this happens it's called a Proc/Lambda.
# Blocks that are empty are "", NOT nil.
# A built in Ruby class called "Proc" holds these blocks that are turned into objects.
# Procs/Lambdas are blocks that have been 'confined' into a variable or object and can be passed/used like an object. 

################# Side note ########
# The & operator can also be supplemented with the "gem install ampex" which allows a &X syntax to use the & shortcut in more 
# situations such as - "alpha\nbeta\ngamma\n".lines.map(&X.strip.upcase)"  will print every word in uppercase.
# Many people don't tend to like the &X though. This usage of the & is different than the & that converts blocks to procs!
####################################
# Side notes: 
# In older Ruby versions there was a keyword 'proc' that behaved differently than 'Proc.new', but they are now alaised. 
# Therefore the 'proc' keyword won't be discussed. 
# Speed wise, blocks are faster than lambdas. 
# The assignment of a method to a variable executes that method. Ruby reads from right to left. 
####################################

# Lambdas:                                            Procs: 
# used with blocks                                    used with blocks
# are anonymous functions (no need for a name)        Not anonymous 
# don't need a name                                   do need a name
# behave like methods:                                Behave like blocks:
# return the last expression in the block             ???
# check for matching number of arguments              Don't check for same numbers of arguments 
# Name assignment allowed                             Name assignment required
# "Return" runs code right after 'return'             "Return" runs code in the next line after 'return'
# Object ID shows a Proc class w/ "Lambda"            Object ID shows a Proc class w/o "Lambda"


############### EVERYTHING WITH A CALL IN IT 

def feeding_procs(suitcase)  # doesn't need the & preceding suitcase. It's already a Proc.
      puts suitcase   # <#Proc ... >
      suitcase.call   # "YEHAW!"  The lambda just came in via 'suitcase' toting it's block with it that can be called at any time.
end
 
feeding_procs(lambda {puts "YEHAW!"})

#### Understanding the methods .call and .yield.  #############
# The .call is a Method method (Eg. a type of method held in the class of Method)
# If a block just invokes .call after it, the block will run. If .call has a parameter like .call(5), then the 5 will pass to the
# block via the ||'s. Call is always invoked by a closure (proc/block/lambda). It doens't matter if the .call is attached to a 
# method/variable, as long as that method returns a block, or the variable is a Proc/Lambda. 

# Confirming thoughts: If you see a .call parameter, the block invoking it should be have ||'s to receive it. 
# If it's a lambda, the parameters of the call must match the vars passed into the block. 
# Eg lambda {|x,y| x+y}.call(4,3)   VS  Proc.new { puts "hi" }.call("A parameter lost into the void")
# Eg lambda {|x  | x  }.call(4,3) <-- Error, wrong number of Arguments 2 for 1.
# The parameter for .call can NOT have a space after it. Incorrect -> {}.call (4)  

# There are 94 methods in the Methods total (proof: p Method.methods.count). 
# Other notable methods in the class Method are: .to_proc , .inspect , .eql? 
# Every Object has a method called .method. 

def chamillionaire
  puts "They been callin' me."
end

m = method(:chamillionaire)   # method is a special word here. It can't be changed. It takes a symbol or a string as a parameter.
m.call      # They been callin' me

c = 12.method("chamillionaire")
c.call      # They been callin' me

a = 12.method(:+) 
p a.call(3)    # 15
p a.call(20)   # 32

b = 12.method("+") 
p b.call(4)    # 16

#############

def yao(x) 
  x 
end

d = method("yao")   # This string of "yao" is really just being converted into a symbol I think and calling the method 'yao'
p d.call(6)         # 6. This works, but wtf?!

#############

say = "Hello"
method_object = say.method(:length) 
p method_object.call #=> 5

class Sayit
  def hi 
    puts "wazzup" 
  end 
end
say = Sayit.new
say.method(:hi).call    # wazzup

##### Procs/Lambdas preserve variable state

def whatever
  z = 0 
  Proc.new { z += 1 }  
  # lambda { z += 1 }  would run identically to the Proc.new in this example.
end

a = whatever   # This whatever will be different from other variables assigned to 'whatever'
p a.call # 1
p a.call # 2

b = whatever   
p b.call  # 1. 
p a.call  # 3. It remembers where 'a' left off, which was 2, and adds another. 

p whatever.call # 1
p whatever.call # 1 - This will stay one forever, since each time it has no way to store it's new value.

########## Example of a block being fed a block

lambda { |&block| block.call }.call { 1 }

##########

########## EXAMPLES OF ALREADY EXPLAINED CONCEPTS #######################

b = lambda { "Hi" }
puts lambda { "Hi" }.call # Hi. Equivalent to line below.
puts b.call               # Hi. Just goes to the var 'b' and will .call the block to be run. 

##########

wat = lambda do |x|   # The 'x' is getting the param given by the .call method. 
  if x == "cat"
    "Kietteh"
  else
    "Not kitteh" 
  end
end
puts wat.call("cat")     # Kietteh. .call takes "cat", gives to 'wat', a lambda that wants 1 var for |x|, then x = "cat"
puts wat.call("meowz!")  # Not Kitteh

##########

doit = lambda { |x| x+1 }
p doit.call(5)   # 6. The .call requires a block to be assoicated with doit, which it is. It then passes in the '5' arg to the 'x' 

##########

cows = lambda { 10 } 
# p cows.call(10)      # Error. Wrong number of args, (1 for 0)
p cows.call            # 10. 0 args for call passed into a lambda block w/ 0 args needed. 

##########

rats = lambda { |x, y| x + y }
# p rats.call(5,4,3) # Wrong number of args - 3 for 2.
p rats.call(5,4)   # 9 

########## Lambdas always return the last expression in a block.

b = lambda do
  5
  6
end
p b.call

##########

def gen_times(factor)
    Proc.new { |n| n*factor }    # Would work identically if I subbed "Proc.new" w/ "lambda"
end

p gen_times(3).call(12)                         #=> 36
p gen_times(5).call(5)                          #=> 25
p gen_times(3).call(gen_times(5).call(4))       #=> 60

#####################




















################## THE & 

class Array
  def iterate!(&code)          # The & casts 'code' .to_proc
# def iterate!(code)           # There's no &, meaning code better be coming in as a proc already.   
    self.each_with_index do |n, i|
      self[i] = code.call(n)
    end
  end
end

array = [1, 2, 3, 4]

array.iterate! do |n|              # No Proc.new needed, the iterate! method will cast it to a proc. 
# array.iterate!(Proc.new do |x|   # This would be the case if I didn't have (&code) in the method definition. 
  n ** 2
end #)

p array


######### Blocks take arguments ####################
# The behavior of .call here is not anything new. It still passes parameters into the block, and .call itself simply invokes
# the block itself. The ONLY difference here is that instead of seeing a Proc.new{} or lambda {} or just a plain block {} 
# passed into .call we're simply seeing the &, which means "Whomever called this method should have a block attached to it, 
# but I know blocks can't just be passed around and named, so I'm using the & to mean .to_proc on whatever name is coming in."

def gimme_moar_numbahz(&block)
  p block.class             # Proc 
  p block                   # #<Proc:0x007fa6bd15fc00@/Users/tony/mastery-notes/mastery_blocks_ampex.rb:63>
  p Proc.new {}             # #<Proc:0x007fa6bd15fc00@/Users/tony/mastery-notes/mastery_blocks_ampex.rb:123>
  p lambda {}               # #<Proc:0x007fa6bd15fc00@/Users/tony/mastery-notes/mastery_blocks_ampex.rb:63 (lambda)>
  block.call(10)            # Same as seen before - when .call has a parameter, it gets passed to the block via the |x|
  block.call(100)           # This says, give me the proc named block and run it's block contents and pass in 100 via |x|
end
blocks_can_see_me = 5       # Remember blocks can see their environment/scope around them. 
gimme_moar_numbahz { |x| puts x + 1 + blocks_can_see_me }

######### 

def get_block(&block) # Only ONE block can be passed into an arg list like here - to add more you need procs (discuss later)
  block.call       # CATS
  yield            # CATS - Yield basically does the same thing as call in this case. Yield can't handle params like .call.
  block            # Does nothing here, but in case a .call method calls get_block, the last line will be this block. 
  # puts "hi"      # This would cause the block.call below to error b/c the last line isn't the block it wants for .call. 
end

block1 = get_block { puts 'CATS' }
puts block1.class # Proc 
block1.call       # CATS - When you .call a method that takes in a block, the LAST line must be that block to be returned for .call.

#########

def get_blox(&hi)
  hi
end

blok1 = get_blox{ p "cell block 1"} # This line runs, but DOESN'T execute the block yet. It's just passed to &blox in get_blox.
blok1.call      # "cell block 1" is now displayed when you .call the method it runs the block. 

######### Symbols and methods can turn into blocks by being casted with the &, like in the common .inject method below
# When you use & (ampersand) in front of the last variable in a method call, that means what's passed shouldn't be treated
# like a regular object, but instead treat it like more code, which will be a block (termed as a 'proc')
# Since a symbol isn't a proc, you can convert it to one with the .to_proc method.
# The & operator will "cast" any operator to a block. Works on procs, methods, symbols. 

values  = [1,2,3,4]
p total = values.inject(0) { |sum, element| sum + element }  # 10
p total = values.inject(0,&:+)  # This line is the equivalent of the one above. 

######### Another example

p [1,2].map { |x| x.to_s }  # Here's a normal line converting everything in the array to a String.
p [1,2].map(&:to_s) # Here's the same line. Notice this is a PARAMETER for .map, as opposed to a block. So ()'s are used. Not {}.

# Using the & operator on Enums reduces temp vars (no 'x' needed) and also puncutation (no need for the |x| and x. part of the block)

#########

# The & operator just calls .to_proc 
# 2 other equivalent ways fo doing the exact thing:

yao = :to_s.to_proc          # The method you want (.to_s), which is also a symbol, just then invokes .to_proc on itself. 
yao = (:to_s).to_proc        # Equivalent to above, just has worthless ()'s
p [1,2].map(&yao)            # You can put in a var (like yao)
p [1,2].map(&:to_s.to_proc)  # Without the var. 
p [1,2].map(&:to_s)          # [1,2] - Without the var. 

# You can only have one block passed into a method's parameters. 

def get_blox(&blox) 
  p "here"         
  p blox           
end

blok1 = get_blox { p "Cell block 1" } # runs the get_blox method, prints "here" and "#<Proc:######>" 
blok1.call         # "Cell block 1" is now displayed when you .call the method it runs the block. But then 
                   # ignores everything else inside of the get_blox method.



















################# YIELD ##################

def a(&x)
  yield
end

def b
  p "b"
end

a { puts "hi" }

##################### .yield works very similarly ################
def ant(numb)
  yield(numb)
end

puts ant(1) { |x| x + 1 } # 2. If the keyword 'yield' is in the called method, the caller (eg, ant(1)) better have a block
                          # associated with it else there will be an error. Yield basically can be reprhased to,
                          # "Go to the block from wherever I was called from and run it. I can also give a parameter for the 
                          # block if there's a spot to pass in a parameter, like a |x|. "

def bug(x)
  yield(x+2)                          
end
p bug(2) {|x| x+10} # 14. the (2) parameter goes to the arg (x), then yield calls the block with (2+2) being passed to |x|
                    # which leads to 4 + 10 = 14. 
# p bug(2) # No block given when it hits yield will have an Error: no block given (yield)

# Avoiding the 'yield' keyword if there's no block from the calling method. 
def pot(y)
  if block_given?
    yield(y)
  else
    "No block"
  end
end
p pot(6) { |x| x + 63 }   # 69
p pot(5) # No Block (and also, no error)

########### As a method is called, it remembers who called it (to know who to give the result to), and if whomever called
# it doesn't have a block, and the method has a yield that executes, it will return an error. 

## Example of rewriting the Array class to handle an incoming block.
class Array
  
  def accumulate
    new_array = []
    each do |x|
    new_array << yield(x)
    end
    new_array
  end
end

p ["hello", "world"].accumulate(&:upcase)
p [1, 2, 3].accumulate { |x| x * x } 

########### Blocks can be passed around ##############
def block1(&block)  # The block that called this method gets put into &block
  block2(&block)    # Just call another method and pass that block to it. 
end

def block2(&block)  # A new method, same ol block. Same ol process of &block being the original block from the calling method.
  yield ( 1 )       # The equivalent of the line below it. Both pass "1" as an arg to the block. yield only used inside a method.
  block.call(1, 2)     # The block { |n| puts "got #{n}..."} is the 'block', that's now called, with the arg 1 and 2  to go 
                       # into |n| and |y|
end

block1 { |n ,y | puts "Got #{n} #{y}" }  # Got 1 2 

                                       # Methods take a block whether you specify it in the method params or not! 
def keywords_with_blocks(&blocks)      # Am I going to be .calling the proc while inside the method? Then add (&blocks), if not
                                       # leave it off. 
  if block_given?                      # Looks to see if there was a block on the invokation of the method, does NOT look at params.
    blocks.call                        # I can .call the block from the invoking method - "Block was called"
    yield                              # Block was called - Goes back to the invoking method and runs the block. 
    puts "*"                           # * Yield isn't "return", it yields to the block and still keeps running the rest of the method.
  else
    puts "No block given!"
  end
end

keywords_with_blocks                   # No block given! 
keywords_with_blocks { puts "Block was called" }

# Arity - the number of methods that are counted in a method, like when you see "Wrong number of Arguments 1 for 2")
# Blocks are never counted as a number of argument to take. A method can take in a block without expecting it in the param. 
# A method can take in a block with expecting it (eg. def meth(&whatever)) 
def d(arg1, arg2, &block)
end
puts method(:d).arity   # 2 - arg1, arg2 are counted, &block is not. 
p method(:puts).to_proc # #<Proc (lambda)>























################ PROC and CALL 
################## 
#
# Steps in creating a Proc. 
# 1) Have a method that accepts a block. eg. get_block(&block).
#    The method isn't the proc, nor does it create it, but the (&block) IS the newly created/casted Block. So if you return that 
#    in the method, then that will be a Proc. If a Proc has been .call(ed) from outside the method. The &block must be the last line 
#    returned, so the .call method can have that block to .call. 
# 2) Are you calling the block from inside or outside the method? To get the results of that block, you're likely using .call. 
#    If you're calling the block from outside the method, the block's contents are run/displayed/returned as long as it's the last
#    line of the method. You can call a block anywhere inside the method that has the block coming in as a (&param) - it doesn't 
#    have to be the last line. 

# You can even put expressions inside the ||'s to be passed in. 
o = Proc.new { |msg = 'inside the regular Proc'|  puts msg }
o.call
l = lambda { |msg = 'inside the regular lambda'|  puts msg }
l.call

# Lambdas also need to have a block attached to them:
a = lambda {}
# a = lambda   # Error: Tried to create Proc object w/o a block. 
p lambda {}   # #<Proc:0x007f82c38afa28@ ...(file path) (file name) (current line number) (lambda)>


#######################################################################################
# Quiz #########################
# Q: Where does the parameter of .call feed into (eg. Where's 12 go in -> gen_times(3).call(12)   ) ? 
# a) The parameter of the method gen_times(3) (eg. 'factor')
# b) The parameter of the block in the method (eg. |n| )
#
# A: B - The parameter of 'call' always finds it's way into being passed into a block.
################################


# Procs are ways to essentially have functions in Ruby, called a Functor - an object called like a function. 
# Procs are closures (eg. ways of grouping code). Procs are objects, blocks aren't. 

procky = Proc.new { |x| puts x*2 } 
["One ","Two "].each(&procky)   # One One Two Two 

psst = Proc.new { puts "If you're feeling Procy, then leap!" }  # psst is an instance of the Proc class. 
psst.call # "If you...leap!" - .call executes the block body of psst
p psst    # <Proc:hex / path / filename / line> 


##############################################
# To pass multiple blocks into a method is easy. Just turn them into procs first (above we let the method turn it
# into a proc for us). 
def multi(procy1, procy2, procy3)
  procy1.call          # Notice .call method inside the method as opposed to outside. The .call method can be 'anywhere'
  procy2.call
  procy3.call
end

a = Proc.new { p "Big" }
b = Proc.new { p "Black" }
c = Proc.new { p "Proc!" }
multi(a, b, c)
























 
### METHOD, BINDINGS, EXTRA
# Extra 
a = [1, 2]
p a 
lambda { |a| p a }.call([1, 2])

a, b = [1, 2]
p a, b
lambda { |a, b| p a, b }.call([1, 2], [1,2])



###############################
# You can't understand blocks until you understand the different bindings they have. A {} block is not the same as a do end block.
# A {} block will "bind" or feed into the last method invoking it (eg. the one directly it's left). So with:
# puts "123456789".upcase.count{} the {} will bind to .count and not 'puts'. 

puts "123456789".upcase.each_char.count { |x| x }      # 9 - The block binds to .count, but is forced to evaluate everything.
puts "123456789".upcase.each_char.count do end         # 9 - The block binds to "puts" and evaluates the whole line.
puts "123456789".upcase.each_char.count {}             # 0 - The block binds to .count before count has even 'seen' anything.

########### 2 methods using different block bindings ##############################
def a(*)   # See below on why you need a * (or any variable for that matter) for 'a', but not 'b'
  p "a: #{block_given?}"   # block_given? is a built in Ruby method
end

def b
  p "b: #{block_given?}"   
end

a b { } # b: true, a: false. It shows 'b: true' first since expressions are evaluated from right to left. 
        # This gives an empty block, but still a block. With {}'s the block is attached to the object invoking it. 
        # In this case it's 'b', it calls the method and returns 'true'. However, 'a' doesn't have the block binded to it.
        # Therefore, 'a' returns 'false.'


a b do end # b:false, a:true. Another empty block, but a block nonetheless.
           # The do/end block binds to the initial object in the expression ('a'). Therefore 'b' returns false. 
####################################################################################################################################
#
# The reason why you need a * is because of the way parameters are fed into 'a' method.
# These things rewritten for clarity and are equivalent - NOT different: 
# a b {}       - rewritten - a(b{}) , you can see that 'a' is feeding in a parameter to its method. 
# a b do end   - rewritten - (a(b)) do end
# a (b do end) - rewritten, this is different and behaves differently as if it was like 'a b{}'










# The yield keyword will look at whatever line called the method to start with, find the block, and run it.

def car_signs
  puts "normal stuff"    
  yield  # Go find what called "car_signs" and execute the block attached to it! 
  puts "car_signs never needed a parameter of a block like (&blokz), yield will find the block though"
  yield  
end
car_signs { puts "This gets run when yield comes looking for it" }

# Quiz: 
# Q: You see in a method body there's a "yield" in it. What do you immediately know about the rest of the program: 
# a) There was a block attached to the line of code that called that method, 100% of the time. 
# b) In the method declaration, there is NO parameter that represents a block, ie. you'd never see "def a(&blocky)" 
# c) There could be a block attached to the line that called the method, but it's not required.
#
# A: a. There MUST be a block of code in the line that calls a method with 'yield' in it. You'll get a LocalJumpError otherwise.
#    You can still accept in parameters of a block (eg. def a (&blocky) ) without an error. 


#######################################################
# 1) Example of Procs not caring about arguments, but Lambdas bitching and moaning
#
# Explicit Procs don't care about matching up the right number of arguments: 
jump = Proc.new { |x| p x }   # This proc takes in 1 argument, the |x| 
jump.call("Cat")              # Cat 
jump.call                     # nil 
jump.call(1, "Cow", 9)        # 1

puts "**** End of var/class/meths for explicit procs ****"
##################################################################################
#### Another example of explicit procs not caring about number of arguments  #####
#
bbp = Proc.new { |x, y, z| puts "#{x} #{y} #{z}" }  # This one can handle 3 arguments, the |x|, |y|, |z|
bbp.call("one arg,", "two,", "three argz")          # one arg, two, three argz
bbp.call("just_one")   # just_one
bbp.call(1,2,3,4,5,6)  # 1 2 3 

puts "**** End of var/class/meths for explicit procs ****"
##################################################################################
#### Implicit procs (eg. what looks to just be a block here) don't care about number of arguments.
#
def argz(&block)              # If you checked the .class of block, it'd be a Proc. 
  block.call()                # nil, nil. nil. argz is called, x and y are both nil.
  block.call(:a)              # :a , nil. nil. Here the x has an arg, but :b is still nil. 
  block.call(:a, :b)          # :a, :b, nil
  block.call(:a, :b, :c)      # :a, :b, :c
  block.call(:a, :b, :c, :d)  # The :d just gets lost in space. No param ever checks for it. But it's no problem.
end
argz do |x, y, z, g|          # Not a loop! Runs 'argz' once! Put as few/many params in the ||'s. Doesn't matter.  
  p "Args: #{x.inspect}, #{y.inspect}, #{z.inspect}"  # I used .inspect to show the 'nil' as opposed to just blankness.
end
#
puts "**** End of var/class/meths for Implicit procs ****"
###################################################################################

#####################################################################################################
# 3) Example of handling return differently. 
####################################### PROC EXAMPLE 1 ##############################################
def proc_returnz
  proc = Proc.new { return }  # Just an assignment - Hasn't executed yet, not until the next line.
  proc.call
  puts "Hello"   # This never runs, when the previous line ran, it saw 'return' and went back.
end
p proc_returnz  # nil 

###################################### LAMBDA EXAMPLE 1 ##############################################
def lamby_returnz
  lam = lambda { return }  # Just an assignment - Hasn't executed yet, not until the next line.
  lam.call
  puts "YAO!"       # Runs this line, even after seeing "return" 
  puts "GOGO!"      # Runs this too...
end
lamby_returnz  # YAO! GOGO!

######################################  PROC EXAMPLE 2  ###############################################
def retpro
    ret = Proc.new { return "sun" }   # Here a proc will only look at "sun" to be evaluated/returned
    ret.call
    puts "A line never seen." 
end  
puts retpro   # "sun" NOTE the puts on the last line of the method and puts here. 
puts "--- End of retpro ---"
########################################################################################################

######################################  LAMBDA EXAMPLE 2  ##############################################
def return_example
    lam = lambda { return "blinded" }   # Here a lambda will evaluate "blinded", but won't print it unless you puts it IN the {} (eg.
    # lam = lambda { return puts "blinded" }   # This would print out "blinded" 
    lam.call
    puts "A love letter finally seen." 
end  
return_example   # A love letter finally seen. 

puts "--- End of return_example --- \n\n"
########################################################################################################

####################################### LAMBDA AND PROC EXAMPLE 3 ######################################
def proc_return
  Proc.new { return :from_block }.call  # Evlated and returned (inside the return block)
  :from_method                          # Never seen.
end

def lambda_return
  lambda { return :from_lambda }.call   # Evaluated 
  :from_method                          # Returned 
end

puts proc_return     # Procs return inside the block - "from_block"
puts lambda_return   # Lambdas return outside the block in the method - "from method"
########################################################################################################


###############################################################################################
# 4) Example of objects being different, but still both being Procs.
a = Proc.new { }
b = lambda { }
p a   # #<Proc:.....blocks_lamba_deeper.rb:27>
p b   # #<Proc:.....blocks_lamba_deeper.rb:28 (lambda)>
###############################################################################################



#### Understanding the .call method, blocks, &, and procs.  ###################################################################
#
# Blocks - you can invoke them with the .call method. Passing arguments to a block can be done by passing them to .call. 
# 
class M
  def numb(&blokz)  # Def the method numb (& I'd like a block)   (The & means it doesn't want a 'normal' parameter!)
    blokz.call("123") 
    blokz.call(456)
  end
end
m_inst = M.new
m_inst.numb do |x| 
  p "A numb: #{x}" # Outputs "A numb: 123"  and  "A numb: 456"
end
#
# m_inst.numb do |x|   does the following: Calls numb, ignores it's parameter, invokes .call with the parameter "123",
# assigns 123 to 'blokz', looks for blokz and finds it's supposed to be a &blokz, says "Go back to where you came from and
# put in "123" in anything that's looking for this to be a result like |x|, x turns to 123 and "A numb: 123" spits out. 
# (In a do block like where we are at this point, is usually something that's LOOPING, and its NOT here. It's simply a block) 
# The program is still in the numb method and executes the next line, blokz.call(456), .call looks for a block, blokz tells
# it where, the & preceding the block confirms its the right block, the 456 tells it what goes into that block, the invoker 
# of the method (m_inst) is held in memory while all this is happening so it knows to go back to m_inst and look for a block 
# there holding the value '123' to give it where it wants it, which is |x| which gets interpolated in the string and 
# "A numb: 456" splats on the screen. TAH-DAH!
#

# Quiz: 
#
# Which of the following will *not* result in an error for calling the .numb method? 
# a) m_inst.numb ( "Feed me!" )
# b) m_inst.numb [ "Feed me!" ]
# c) m_inst.numb { |x| "Feed me" }
# d) m_inst.numb { "Feed me!" }
#
# Answer. D.
#
# Q: If you executed the following: m_inst.numb ("Am I blocky enough?")      What would you get:
# a) No error, but nothing would display.
# b) No error, and "Am I blocky enough123" would display.
# c) Error, Wrong number of Arguments (1 for 0)
# d) Error, Wrong number of Arguments (0 for 1)
#
# A: C. The parameter that numb wants isn't a regular parameter, it wants a block, which is actually a proc,a (P)assed a(R)ound bl(OC)k
#    Putting the ("Am I blocky...") is just a standard parameter, which numb doesn't know what to do with, so it says it's getting
#    the wrong number of arguments. I'm sending 1, it's expecting 0. Note that Ruby doesn't consider the block/proc to be a true
#    "Argument" in the standard sense of the word! 
#
# Q: Is there any significance to the word after the & is placed inside the parameter? 
# 
# A: No. It can be anything. The & just means you're wanting a block.
#
# Q: If in the numb method you added the line - "puts blokz.class", what would it output? 
# a) Nil 
# b) Proc
# c) Block
# d) Lambda
#
# B: Proc.
#
# Q: When a new/random method takes in a &block as a parameter, what can you IMMEDIATELY ascertain looking at the method line ONLY?
# 
# a) The method can be called as if it was an Emunerable            eg. numb.each { "Going through all the blocks!" }
# b) You MUST give that method a block/proc when you call it        eg. numb      { "You're a bum, Blocky!" }  
# c) You must NOT give that method a block/proc when you call it    eg. numb      
# d) It depends. 
#
# A: D - If inside the method there's a ".call" method, then that line will look to the proc/"parameter"/block that was supposed
#        to be fed to it when the method was invoked to begin with. eg. There should be a line like:
#        m_inst.numb { "Blocky VIII - Geriatric Rematch" }   somewhere when the method was called. Now if inside the method, there
#        was never a ".call" then essentially that (&blocky) parameter is never called and therefore, never geneates an error if
#        you just called the method with something like:    m_inst.numb       and nothing else. 
#
#
# Q: You look at a friends screen and see: m_inst.numb { puts "I'm a PROCtologist! " } . Which of the following is NOT true?
# a) Your friend is a moron.
# b) It will print "I'm a PROCtologist! 123" and "I'm a PROCtologist! 456"
# c) Your friend is a dipshit. 
# d) It will print "I'm a PROCtologist" twice
#
# B - There's no point in having a line in the numb method that uses a parameter (eg. blokz.call(123)) that never gets fed back 
# to the invoking method. So not having an |x| anywhere in the block when it's called doesn't make much sense at all.
#
############################ End of use of this class/vars/etc #####################################################################