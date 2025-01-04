@tool
## A priority queue implemented with with a Min-Max Heap. This means that this is a double ended priority queue
class_name PriorityQueue extends Node

var heap: Array
var length: int = 0
## Should return 0 for equal, 1 for greater than, -1 for less than
var comparator: Callable

## Initialize or heapify takes in an array to use as its heap and inserts a null value at 0 to allow for 1 indexing
func initialize(array: Array, compare: Callable):
	length = array.size()
	array.insert(0, null)
	heap = array
	comparator = compare
	for i in range(int(floor(length / 2)), 0, -1):
		print(i)
		push_down(i)

func size() -> int:
	return length

func insert(item):
	length += 1
	heap.push_back(item)
	bubble_up(length)

func get_min():
	if size() == 0:
		return null
	return heap[1]

func delete_min():
	var item = heap[1]
	length -= 1
	
	if length == 0:
		return item
	
	heap[1] = heap.pop_back()
	push_down(1)
	
	return item

func get_max():
	if size() <= 1:
		return null
	if size() == 2:
		return heap[2]
	if comparator.call(heap[2], heap[3]) < 0:
		return heap[3]
	else:
		return heap[2]

func delete_max():
	var item
	length -= 1
	if comparator.call(heap[2], heap[3]) < 0:
		item = heap[3]
		heap[3] = heap.pop_back()
		push_down(3)
	else:
		item = heap[2]
		heap[2] = heap.pop_back()
		push_down(2)
	
	return item

func update_key(old_value, value):
	var index: int = 1
	while index <= length and comparator.call(heap[index], old_value) != 0:
		index += 1
	if index == heap.size():
		return
	heap[index] = heap[1]
	heap[1] = value
	push_down(1)

func push_down(index: int):
	if on_min_level(index):
		push_down_min(index)
	else:
		push_down_max(index)

func push_down_min(index: int):
	if has_children(index):
		var smallest_child: int = get_next_smallest(index)
		if is_grandchild(smallest_child, index):
			if comparator.call(heap[smallest_child], heap[index]) < 0:
				swap(smallest_child, index)
				
				if comparator.call(heap[smallest_child], heap[get_parent_index(smallest_child)]) > 0:
					swap(smallest_child, get_parent_index(smallest_child))
				push_down(smallest_child)
		elif comparator.call(heap[smallest_child], heap[index]) < 0:
			swap(smallest_child, index)

func push_down_max(index: int):
	if has_children(index):
		var largest_child: int = get_next_largest(index)
		if is_grandchild(largest_child, index):
			if comparator.call(heap[largest_child], heap[index]) > 0:
				swap(largest_child, index)
				
				if comparator.call(heap[largest_child], heap[get_parent_index(largest_child)]) < 0:
					swap(largest_child, get_parent_index(largest_child))
				push_down(largest_child)
		elif comparator.call(heap[largest_child], heap[index]) > 0:
			swap(largest_child, index)

func bubble_up(index: int):
	if index != 1:
		if on_min_level(index):
			if comparator.call(heap[index], heap[get_parent_index(index)]) > 0:
				swap(index, get_parent_index(index))
				bubble_up_max(get_parent_index(index))
			else:
				bubble_up_min(index)
		else:
			if comparator.call(heap[index], heap[get_parent_index(index)]) < 0:
				swap(index, get_parent_index(index))
				bubble_up_min(get_parent_index(index))
			else:
				bubble_up_max(index)

func bubble_up_min(index: int) -> void:
	if has_grandparent(index) and comparator.call(heap[index], heap[get_grandparent(index)]) < 0:
		swap(index, get_grandparent(index))
		bubble_up_min(get_grandparent(index))

func bubble_up_max(index: int) -> void:
	if has_grandparent(index) and comparator.call(heap[index], heap[get_grandparent(index)]) > 0:
		swap(index, get_grandparent(index))
		bubble_up_max(get_grandparent(index))

func swap(x: int, y: int) -> void:
	var temp = heap[y]
	heap[y] = heap[x]
	heap[x] = temp

func on_min_level(index: int) -> bool:
	return int(floor(log(index) / log(2))) % 2 == 0

func has_children(index: int):
	if index * 2 <= length:
		return true
	return false

func get_parent_index(index: int) -> int:
	return int(floor(index / 2))

func get_next_smallest(index: int) -> int:
	var min = heap[index * 2]
	var min_index = index * 2
	if 2 * index + 1 <= length:
		var child2 = heap[2 * index + 1]
		if comparator.call(min, child2) > 0:
			min = child2
			min_index = 2 * index + 1
	var child_index1 = 2 * index
	var child_index2 = 2 * index + 1
	var grandchild_index1 = 2 * child_index1
	var grandchild_index2 = 2 * child_index1 + 1
	var grandchild_index3 = 2 * child_index2
	var grandchild_index4 = 2 * child_index2 + 1
	if grandchild_index1 <= length:
		var grandchild = heap[grandchild_index1]
		if comparator.call(min, grandchild) > 0:
			min = grandchild
			min_index = grandchild_index1
	if grandchild_index2 <= length:
		var grandchild = heap[grandchild_index2]
		if comparator.call(min, grandchild) > 0:
			min = grandchild
			min_index = grandchild_index2
	if grandchild_index3 <= length:
		var grandchild = heap[grandchild_index3]
		if comparator.call(min, grandchild) > 0:
			min = grandchild
			min_index = grandchild_index3
	if grandchild_index4 <= length:
		var grandchild = heap[grandchild_index4]
		if comparator.call(min, grandchild) > 0:
			min = grandchild
			min_index = grandchild_index4
	
	return min_index

func get_next_largest(index: int) -> int:
	var max = heap[index * 2]
	var max_index = index * 2
	if 2 * index + 1 <= length:
		var child2 = heap[2 * index + 1]
		if comparator.call(max, child2) < 0:
			max = child2
			max_index = 2 * index + 1
	var child_index1 = 2 * index
	var child_index2 = 2 * index + 1
	var grandchild_index1 = 2 * child_index1
	var grandchild_index2 = 2 * child_index1 + 1
	var grandchild_index3 = 2 * child_index2
	var grandchild_index4 = 2 * child_index2 + 1
	if grandchild_index1 <= length:
		var grandchild = heap[grandchild_index1]
		if comparator.call(max, grandchild) < 0:
			max = grandchild
			max_index = grandchild_index1
	if grandchild_index2 <= length:
		var grandchild = heap[grandchild_index2]
		if comparator.call(max, grandchild) < 0:
			max = grandchild
			max_index = grandchild_index2
	if grandchild_index3 <= length:
		var grandchild = heap[grandchild_index3]
		if comparator.call(max, grandchild) < 0:
			max = grandchild
			max_index = grandchild_index3
	if grandchild_index4 <= length:
		var grandchild = heap[grandchild_index4]
		if comparator.call(max, grandchild) < 0:
			max = grandchild
			max_index = grandchild_index4
	
	return max_index

func is_grandchild(child: int, index: int) -> bool:
	return int(floor(child / 4)) == index

func has_grandparent(index: int) -> bool:
	return int(floor(index / 4)) >= 1

func get_grandparent(index: int) -> int:
	return int(floor(index / 4))


#func _ready():
	#var list = [8, 1, 5, 2, 7]
	#var queue = PriorityQueue.new()
	#queue.initialize(list, func (x, y): 
		#if x < y:
			#return -1
		#elif x > y:
			#return 1
		#else:
			#return 0)
	#print(queue.heap)
	#print(queue.get_min())
	#print(queue.delete_max())
	#print(queue.get_max())
	#print(queue.heap)
	#print(queue.insert(10))
	#print(queue.get_max())
	#print(queue.heap)
	#print(queue.insert(-10))
	#print(queue.get_min())
