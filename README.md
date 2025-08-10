# 📜 Python List Operations

This project demonstrates **basic Python list operations** in a clear, step-by-step manner.  
It’s perfect for beginners who want to understand how lists work in Python.

---

## ✨ Features
- ✅ Create an empty list
- ✅ Append elements
- ✅ Insert at a specific index
- ✅ Extend with another list
- ✅ Remove the last element
- ✅ Sort in ascending order
- ✅ Find the index of a specific value

---

## 🖥 Code Example
```python
# 1. Create an empty list
my_list = []

# 2. Append values
my_list.append(10)
my_list.append(20)
my_list.append(30)
my_list.append(40)

# 3. Insert value at index 1
my_list.insert(1, 15)

# 4. Extend with another list
my_list.extend([50, 60, 70])

# 5. Remove the last element
removed = my_list.pop()

# 6. Sort in ascending order
my_list.sort()

# 7. Find index of value 30
index_of_30 = my_list.index(30)
🚀 How to Run
Save the code in a file, e.g., list_operations.py

Open a terminal and run:

bash
Copy
Edit
python list_operations.py
📌 Example Output
pgsql
Copy
Edit
After appending 10,20,30,40 -> [10, 20, 30, 40]
After inserting 15 at index 1 -> [10, 15, 20, 30, 40]
After extending with [50,60,70] -> [10, 15, 20, 30, 40, 50, 60, 70]
Removed last element (was) -> 70
After removing last -> [10, 15, 20, 30, 40, 50, 60]
After sorting ascending -> [10, 15, 20, 30, 40, 50, 60]
Index of value 30 is -> 3
📚 Learning Notes
append() → Adds a single item to the list

insert(index, value) → Inserts at a specific position

extend([list]) → Adds multiple items from another list

pop() → Removes and returns the last item

sort() → Arranges list items in ascending order

index(value) → Returns the position of a value
