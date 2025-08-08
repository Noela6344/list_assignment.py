
# 1 Create an empty list called my_list
my_list = []

#  Append 10, 20, 30, 40
my_list.append(10)
my_list.append(20)
my_list.append(30)
my_list.append(40)
print("After appending 10,20,30,40 ->", my_list)

#  Insert value 15 at the second position (index 1)
my_list.insert(1, 15)
print("After inserting 15 at index 1 ->", my_list)

#  Extend my_list with [50, 60, 70]
my_list.extend([50, 60, 70])
print("After extending with [50,60,70] ->", my_list)

#  Remove the last element
removed = my_list.pop()
print("Removed last element (was) ->", removed)
print("After removing last ->", my_list)

# Sort my_list in ascending order
my_list.sort()
print("After sorting ascending ->", my_list)

#  Find and print the index of the value 30
index_of_30 = my_list.index(30)
print("Index of value 30 is ->", index_of_30)