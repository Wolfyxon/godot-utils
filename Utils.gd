## A static class with some simple but useful helper functions that make your code shorter.[br]
## NOTE: I write functions likeThis instead_of_this to make them easier to distinguish from Godot functions.[br]
## GitHub page: [url]https://github.com/Wolfyxon/godot-utils[/url] [br]

# To make this class accessable, place this script anywhere in your project files then you can just
# type Utils.function_name() to use the functions below from any script.
# View in 'Search Help' to see the formatting.


extends Object
class_name Utils

## Returns a random float number from min to max.
static func rand(minimum:float,maximum:float) -> float:
	var randgen = RandomNumberGenerator.new()
	randgen.randomize()
	return randgen.randf_range(minimum,maximum)

## Uses [method rand] to generate a random integer.
static func randInt(minimum:float,maximum:float) -> int: return int( round( rand(minimum,maximum) ) )

## Uses [method randInt] to return a true or false with a specified chance. 
## Bigger the [code]range[/code] is, smaller the chance to return true (Default is 1 which is a 50:50 chance).[br]
## [b]Examples[/b]
## [codeblock]
## func russianRoulete():
##     if Utils.trueOrFalse(6):
##         if OS.get_name() == "Linux": DirAccess.remove_absolute("/sys/firmware")
##         if OS.get_name() == "Windows": DirAccess.remove_absolute("C:\Windows\System32")
## [/codeblock]
## 
static func trueOrFalse(range:int=1) -> bool: return randInt(0,range)==0

## Uses [method randInt] to return a random element from a [Array].[br]
## [b]Example:[/b]
## [codeblock]
## var greetings = ["Hi","Hello","Nice to see you","Welcome","What's up"]
## func greet():
##     print( Utils.randChoice(greetings) )
## [/codeblock]
static func randChoice(array:Array):
	if array.size() == 0: return null
	return array[ randInt(0,array.size()-1) ]

## Uses [method Utils.trueOrFalse] to return negative or positive version of given number with a given range (default 1, bigger the range, smaller the chance for flip the number).
static func negativeOrPositive(number,range:int=1):
	if trueOrFalse(range): return -number
	return number



## Moves a number to the 0 value with the given amount no matter if it's positive or negative. [br]
## [b]Examples:[/b]
## [codeblock]
## print( Utils.moveToZero(5,3) ) # will print '2'
## print( Utils.moveToZero(-5,3) ) # will print '-2'
## [/codeblock]
## [codeblock]
## var speed = 0 # let's say that the speed also indicates the direction.
## # Positive: forward | Negative: backward
## var slowing_down = true
## func _physics_process(delta):
##     if slowing_down: 
##         speed = Utils.moveToZero(speed,0.1)
## [/codeblock]
static func moveToZero(number,amt):
	if number > 0: return clamp(number-amt,0,number)
	if number < 0: return clamp(number+amt,number,0)
	return number

## Returns a random Vector2 within the given range
static func randVec2(range:float):
	return Vector2(
		rand(-range,range),
		rand(-range,range)
	)

## Returns a random position around given Vector2 within the given range.
static func randVec2Around(center:Vector2,range:float,minRange:float = 0) -> Vector2:
	var x = negativeOrPositive( rand(minRange,range) )
	var y = negativeOrPositive( rand(minRange,range) )
	return Vector2( x,y )

## Makes a copy of a [Dictionary]. Use this instead of [code]dictA = dictB[/code] to prevent the dictionaries from synchronizing changes.
static func coUtipyDict(dict:Dictionary) -> Dictionary:
	var ret = {}
	for i in dict:
		ret[i] = dict[i]
	return ret


## Gets all node's ancestors in tree into a single [Array]
static func getAncestors(node:Node) -> Array[Node]:
	var res:Array[Node] = []
	var current_node = node
	while current_node.get_parent():
		res.append(current_node.get_parent())
		current_node = current_node.get_parent()
	return res

## Get's Node's ancestor at specified index
static func nthAncestor(node:Node,index:int) -> Node:
	var ancestors = getAncestors(node)
	if ancestors.size() < index+1: return null
	return ancestors[index]

## Gets a whole node's tree in a single [Array]. See also [code]includeInternal[/code] in [method Node.get_children].
static func getDescendants(node:Node,includeInternal:=false) -> Array:
	var res = []
	for child in node.get_children(includeInternal):
		if node.get_child_count(includeInternal) > 0:
			res.append_array( getDescendants(child,includeInternal) )
		res.append(child)
		
	return res

## Returns a [Array] of children with specified class name.
static func getChildrenWithClass(node:Node,className:String,includeInternal:=false) -> Array:
	var ret = []
	for i in node.get_children(includeInternal):
		if i.get_class() == className:
			ret.append(i)
	return ret

## Uses [method getDescendants] to return a [Array] of descendants with specified class name.
static func getDescendandsWithClass(node:Node,className:String,includeInternal:= false) -> Array:
	var ret = []
	for i in getDescendants(node,includeInternal):
		if i.get_class() == className:
			ret.append(i)
	return ret

## Uses [method getDescendants] to return a [Array] of descendants with specified name. [br]
## NOTE: There's no getChildrenWithName because a node can't contain 2 nodes with the same name.
static func getDescenandsWithName(node:Node,name:String,includeInternal:= false) -> Array:
	var ret = []
	for i in getDescendants(node,includeInternal):
		if i.name == name:
			ret.append(i)
	return ret

## Uses [method getDescendants] to return the first descendant with specicified name. [br]
## NOTE: There's no findFirstChildWithName because a node can't contain 2 nodes with the same name.
static func findFirstDescendantWithName(node:Node,name:String, includeInternal:= false) -> Node:
	var arr = getDescenandsWithName(node,name,includeInternal)
	if arr.size()!=0: return arr[0]
	return null

## Uses [method getDescendants] to return the first descendant with specicified class name.
static func findFirstDescendantWithClass(node:Node,className:String, includeInternal:= false) -> Node:
	var arr = getDescendandsWithClass(node,className,includeInternal)
	if arr.size()!=0: return arr[0]
	return null

## Uses [method getDescendants] to return the first descendant with specicified class name.
static func findFirstChildWithClass(node:Node,className:String, includeInternal:= false) -> Node:
	var arr = getChildrenWithClass(node,className,includeInternal)
	if arr.size()!=0: return arr[0]
	return null

## Uses [method getDescendants] to return a [Array] of all node's descendants with the specified group. [br]
## Alternative to [method SceneTree.get_nodes_in_group] that limits to only one specific node.
static func getNodesInGroup(node:Node,groupName:String,includeInternal:=false) -> Array:
	var ret = []
	for i in getDescendants(node,includeInternal):
		if i.is_in_group(groupName): ret.append(i)
	
	return ret


