# Database
## DBMS
### choose a database system VS simply store data in operating system files
* DBMS is good at
  * data independence and efficient access
  * reduced application development time
  * data integrity and security
  * data administration
  * concurrent access and crash recovery
* DBMS is bad at
  * too large that it has to be stored in secondary storage devices (eg. disks, tapes)
  * increased cost and overhead of purchasing and maintaining
### logical data independence
* users can be shielded from changes in the logical structure of the data, or changes in the choice of relations to be stored
* help to prevent data loss and corruption in the data processing chain 

## ER Diagram
* Entity (eg. Product)
  * Entity Set should have more than one attributes or is the "many" in many-one or many-many relationships
* Attribute (eg. price, name, category)
  * Domain: the atomic type of every attribute (eg. the domain of name could be a set of 20-character string)
* Key = a minimal set of attributes whose values uniquely identify an entity in the set

### Subclass = special case = fewer entities = more properties
<img width="211" alt="image" src="https://user-images.githubusercontent.com/84046974/192126121-e37ae113-ca89-428b-8bda-af4f14bcf36f.png">

* ER: entities have components in every subclass they belong
* Object-oriented: objects in one class only; subclasses inherit from superclasses

### Weak Entity Set
* definition: their key attributes come from other classes to which they are related
  * implies a one-to-many relationship (one owner could be associated with many weak entities)
* description: "A loan entity can not be created for a customer if the customer doesn’t exist."
<img width="430" alt="image" src="https://user-images.githubusercontent.com/84046974/192127335-42baf7bf-7b63-4718-b632-68139cc25010.png">

### Design Principles
1. Be faithful
2. Avoid redundancy -- waste space and (more importantly) encourage inconsistency
3. KISS

## Relational Model
### Attributes of Relationships
* Descriptive Attributes -- **not necessary, but useful (especially in many-many relationships, as the attribute cannot be associated to only one entity)**
  * used to record information about the **relationship**, rather than about any one of the participating entities
  * a relationship must be uniquely identified by the participating entities, without reference to the descriptive attributes
<img width="471" alt="image" src="https://user-images.githubusercontent.com/84046974/197372770-e991fd1e-4289-4dd5-817a-a2b60df403fb.png">

* Instance of Relationships
  * a "snapshot" of the relationship set at some instant in time
<img width="353" alt="image" src="https://user-images.githubusercontent.com/84046974/197372822-5f4131da-45bd-4d33-9c12-2e8ef16a8fec.png">

### Binary (arrow = uniquely determine)
<img width="400" alt="image" src="https://user-images.githubusercontent.com/84046974/192125903-34a3fd89-037d-4a95-85e6-162defa9baca.png">

### Multiway
<img width="428" alt="image" src="https://user-images.githubusercontent.com/84046974/197372948-3a0a094c-111f-434a-8625-b9b8a24dd60b.png">

## Modeling Constraints
* Keys (**underline in ER**): social security number uniquely identifies a person
  * every entity must have a key
  * a key may contain multiple attributes
  * can have more candidate keys for an entity set
  * at most one primary key
  * there could have **no primary key, but must have at least one candidate key** in a table
* Foreign Key constraint: each value inserted or updated in orders.customer_id must exactly match a value in customers.id, or be NULL.
  * if one of the relations is modified, the other must be checked, and perhaps modified, to keep the data consistent
  * enforce referential integrity
  * must match the primary key of the referenced relation
* Referential Integrity constraint: if you work for a company, it must exist in the database
  * **exactly one value** in a given role, **non-null**
* Single Value constraint: a person can have only one father
  * **at most one value** in a given role, **implied in many-one relationships**
* Domain constraint: peoples’ ages are between 0 and 150
* General constraint: (all others) at most 50 students enroll in a class
* Participation constraint: if every department entity has a manager entity
  * determine whether relationships must involve certain entities
* Overlap constraint: assume that certain employees participate in more than one work team
  * within is-a hierarchy, determine whether or not two subclasses can contain the same entity
* Covering constraint: if every Employee entity has to be within either HourlyEmployee or SalaryEmployee
  * within is-a hierarchy, determine where the entities in the subclasses collectively include all entities in the superclass

## Translation from ER Diagram to Relation Design
### Combine Relations
* It is OK to combine the relation for an entity-set E with the relation R for a many-one relationship from E to another entity set
  * Drinkers(name, addr) and Favorite(drinker, beer) combine to make Drinker1(name, addr, favoriteBeer)
  * Make sure to avoid redundancy
  * many-one relation can be merged
  * merging many-many is dangerous
### Handle Weak Entity Set
* Relation for a weak entity set must include attributes for its complete key (including those belonging to other entity sets), as well as its own, non-key attributes.
* A supporting (double-diamond) relationship is redundant and yields no relation.
<img width="436" alt="image" src="https://user-images.githubusercontent.com/84046974/192128271-0e43684d-d66a-48f1-bae5-dd66e10427de.png">

### Translate Subclass Entities
1. Object-oriented -- good for queries like “find the color of ales made by Pete’s” (just look in Ales relation)
    1. each entity belongs to exactly one class
    2. create a relation for each class, with all its attributes
2. ER style -- good for queries like “find all beers (including ales) made by Pete’s” (just look in Beers relation)
    1. create one relation for each subclass, with only the key attribute(s) and attributes attached to that subclass
    2. entity represented in all relations to whose subclass it belongs
3. Use nulls -- saves space unless there are lots of attributes that are usually null
    1. create one relation
    2. entities have null in attributes that don’t belong to them
<img width="474" alt="image" src="https://user-images.githubusercontent.com/84046974/192128526-fbfc4348-4356-4f5b-8f41-374f4d179138.png">

### Summary
* 1-1 relationship: Store <--> Best-Seller
  * Store(<ins>store_id</ins>, address)
  * Best-Seller(<ins>item_id</ins>, number_sold, **store_id**)
* 1-many relationship: Store <--- Beverage
  * Store(<ins>store_id</ins>, address)
  * Beverage(<ins>beverage_id</ins>, alcohol_percentage, **store_id**)
* many-many relationship: Beverage ---- Shelf
  * Beverage(<ins>beverage_id</ins>, alcohol_percentage)
  * Shelf(<ins>shelf_id</ins>, floor_number)
  * **Associate(<ins>beverage_id</ins>, <ins>shelf_id</ins>)**
* weak entity: Store (--- Drop-Off Box
  * Drop-Off Box(**<ins>store_id</ins> (foreign key)**, **<ins>box_id</ins>**, customer_name, timestamp)
* is-a hierarchy: Gatorade is a Beverage
  * Object-Oriented approach -- ***split the entities*** -> parent = entities with only the basic, child = entities with the basic + additional
    * Beverage(<ins>beverage_id</ins>, alcohol_percentage)
    * Gatorade(**<ins>beverage_id</ins>, alcohol_percentage**, flavor, color)
  * ER approach -- ***split the attributes*** -> parent = all entities with the basic, child = entities with the additional
    * Beverage(<ins>beverage_id</ins>, alcohol_percentage)
    * Gatorade(**<ins>beverage_id</ins>**, flavor, color)
  * Null approach -- ***one table takes all*** -> parent = all entities with the basic + additional / Null
    * **Beverage**(<ins>beverage_id</ins>, alcohol_percentage, flavor, color)

# SQL
## Define a Database Schema
```sql
CREATE TABLE Students (sid CHAR(20), name CHAR(30), login CHAR(20), age INTEGER, gpa REAL,
                       UNIQUE (name, age), CONSTRAINT StudentsKey PRIMARY KEY (sid))
-- sid is the primary key, and the combination of (name, age) is also a key

CREATE TABLE Enrolled (studid CHAR(20), cid CHAR(20), grade CHAR(10),
                       PRIMARY KEY (studid, cid),
                       FOREIGN KEY (studid) REFERENCES Students)

DROP TABLE Students;
```

## Query Template
```sql
SELECT    S            --pull out from each group the values requested in S; if any aggregation, then apply within the group
                       --may contain attributes a1, …, ak and/or any aggregates but NO OTHER ATTRIBUTES
FROM      R1, …, Rn    --enumerate all combinations of tuples from R1, …, Rn
WHERE     C1           --keep only combinations satisfying condition C1 (on the attributes in R1, …, Rn)
GROUP BY  a1, …, ak    --group them by a1, …, ak
HAVING    C2           --keep only groups satisfying condition C2 (on aggregate expressions)
```
## Select-From-Where Statements
* Case-INSENSITIVE
* Syntax
  * Not equal ```<>```
  * Pattern matching: ```s LIKE p```
* Multi-Relation Query
<img width="356" alt="image" src="https://user-images.githubusercontent.com/84046974/192130114-1baa801a-11e8-4807-b2ef-66068c3de52a.png">

* Disambiguating Attribute
```sql
SELECT   Person.name
FROM     Person x, Purchase y, Product z
WHERE    x.name = y.buyer AND y.product = z.name AND z.category = "telephony";
```
* Explicit Tuple Variables
```sql
SELECT   b1.name, b2.name
FROM     Beers b1, Beers b2
WHERE    b1.manf = b2.manf AND b1.name < b2.name;
```
## Aggregation
* SUM([DISTINCT]), AVG([DISTINCT]), COUNT([DISTINCT]), MIN, and MAX can be applied to a column in a SELECT clause to produce that aggregation on the column
* COUNT(\*) counts the number of tuples, **the only one doesn't ignore NULL**
```sql
SELECT   AVG(price)
FROM     Sells
WHERE    beer = 'Bud';
```
## Group-By and Having
* "**for each** such bar" <=> ```GROUP BY bar```
* Difference between ```WHERE``` and ```HAVING```: ```WHERE``` condition happens before ```GROUP BY```, and ```HAVING``` happens after ```GROUP BY```
```sql
SELECT department_name, AVG(jobs.max_salary) AS average_max_salary
FROM employees, jobs, departments
WHERE employees.job_id = jobs.job_id AND employees.department_id = departments.department_id
GROUP BY department_name
HAVING average_max_salary > 8000;
```
<img width="419" alt="image" src="https://user-images.githubusercontent.com/84046974/192130486-e2b996c4-b9c1-4071-bf11-c7a78841c9a0.png">

## Union, Intersect and Except
```sql
SELECT S.sname
FROM Sailors S, Reserves R, Boats B
WHERE S.sicl = R.sid AND R.bid = B.bid AND B.color = 'red'
UNION -- INTERSET or EXCEPT
SELECT S2.sname
FROM Sailors S2, Boats B2, Reserves H2
WHERE S2.sid = H2.sid AND R2.bid = B2.bicl AND B2.color = 'green';
```

## Subquery & Nested Queries
* If a subquery is guaranteed to produce one tuple, then the subquery can be used as a value
```sql
SELECT employee_id
FROM employees
WHERE NOT EXISTS (SELECT * 
                  FROM dependents 
                  WHERE employees.employee_id = dependents.employee_id);

SELECT S.sid
FROM Sailors S
WHERE S.rating >= ALL (SELECT S2.rating
                       FROM Sailors S2);
```
<img width="365" alt="image" src="https://user-images.githubusercontent.com/84046974/192937520-e8e53094-8471-44cc-948d-c94ec1b9eaed.png">

## Data Modification
```sql
INSERT INTO tableName (column1, column2, ...)
VALUES (value1, value2, ...);

INSERT INTO courses (id, title, category) 
VALUES (2, "Database", "CS");
```
```sql
UPDATE tableName
SET column1 = value1, column2 = value2, ...
WHERE filterColumn = filterValue;

UPDATE Department
SET DepartmentName = "Computer Science"
WHERE DepartmentID = 8;
```
```sql
DELETE FROM tableName
WHERE filterColumn = filterValue;

DELETE FROM Department
WHERE DepartmentID = 16;
```

## More Details
* Remove duplicates: ```SELECT DISTINCT select-list```
* Rename: ```SELECT name AS beer```
* Expression: ```SELECT price * 7 AS priceInYuan```
* NULL value: ```x IS NULL```
  * Missing value
  * Inapplicable
  * When any value is compared with NULL, the truth value is **UNKNOWN**
    * A query only produces a tuple in the answer if its truth value for the WHERE clause is TRUE (not FALSE or UNKNOWN)
* Boolean operators
  * IN: ```<tuple> IN <relation>```, where ```<relation>``` is always a subquery
  * EXISTS: ```EXISTS( <relation> )``` is true if and only if ```<relation>``` is **not empty**
  * ANY:
    * ```x = ANY( <relation> )``` is true if x equals at least one tuple in the relation
    * ```x >= ANY( <relation> )``` is true if x is not smaller than all tuples in the relation
    * Note that each tuple can have one component only
  * ALL:
    * ```x <> ALL( <relation> )``` is true if and only if for every tuple t in the relation, x is not equal to t -> x is not a member of the relation
    * ```x >= ALL( <relation> )``` is true if there is no tuple larger than x in the relation
* Use a table multiple times
```sql
SELECT e1.first_name, e2.first_name
FROM employees e1, employees e2
WHERE e1.department_id = e2.department_id AND e1.manager_id = e2.manager_id AND
      e1.salary > 10000 AND e2.salary > 10000 AND e1.salary >= e2.salary AND e1.last_name <> e2.last_name;
```

# Storage
## Typical Architecture
<img height="280" alt="image" src="https://user-images.githubusercontent.com/84046974/194734284-e5e23157-09f7-4ab5-b636-0bf4917989a3.png" align="left">
<img height="280" alt="image" src="https://user-images.githubusercontent.com/84046974/194734335-2b447eed-18a9-4917-baab-9eedba098ff7.png">

## Disk
* Secondary storage device of choice, *random access* vs. *sequential access*
  * sequential access is always faster than random
  * Tapes force a sequential access -- archive data not needed on a regular basis
* Data is stored and retrieved in units called *disk blocks* or *pages*
  * must be a multiple of sector size
  * the number of "multiple" is determined by software
  * the sector size is determined by hardware, and is fixed
* Time to access (read/write) a disk block = seek time + rotational delay + transfer time
  * seek time (moving arms to position disk head on track) - 1 to 20 ms
  * rotational delay (waiting for block to rotate under head) - 0 to 10 ms
  * transfer time (actually moving data to/from disk surface) - 1 ms per 4KB page
* Key to lower I/O cost: **reduce seek/rotation delays**
* Record ID (rid): a unique identifier for a particular record in a set of records
  * can identify the disk address of the page containing the record by rid
  * given a rid, number of I/O’s required to read a record = 1
### Disk VS Memory
* **Time to access a disk page is not constant**, it depends on the location of the data (accessing to some data might be much faster than to others)
* **Time to access memory is uniform** for most computer systems

## RAID - Redundant Arrays of Independent Disks
* Disk arrays that implement a combination of data striping and redundancy
* Data Striping: the data is segmented into equal-size partitions (striping units) distributed over multiple disks

## Disk Space Manager, Buffer Manager & Files and Access Methods Layer
* Disk Space Manager
  * the lowest layer of DBMS software manages space on disk
  * manage the available physical storage space of data for the DBMS
* Buffer Manager
  * read data from persistent storage into memory & write data from memory into persistent storage
* Files and Access Methods Layer
  * to process a page -- ask Buffer Manager to fetch and put it into memory if it is not in there already
  * to add space for new records -- ask disk space manager to allocate an additional disk page

## Buffer Management in a DBMS
* Necessity: to minimizate physical I/O for a given buffer size
* Track free blocks
  * maintain a list of free blocks
  * maintain a bitmap with one bit for each disk block, which indicates whether a block is in use or not
    * difficult to accomplish with linked list approach
* Request a page -- *valid, refbit, pinCnt, dirty*
  * not in pool -> choose a frame for replacement -> if that frame is **dirty**, write it to disk -> read requested page into chosen frame
  * **pin** the page (**pin count**: a page is a candidate for replacement iff pin count = 0) and return its address
    * buffer manager is responsible to pin a page
    * requestor of that page is responsible to tell the buffer manager to unpin a page
* Buffer Replacement Policy
  * big impact on the number of I/Os -- depending on the access pattern
  * sequential flooding = nasty situation caused by LRU + repeated sequential scans
    * number of buffer frames < number of pages in file -> each page request causes an I/O -> MRU much better in this situation
<img width="394" alt="image" src="https://user-images.githubusercontent.com/84046974/194734383-60ad1d18-bfad-48d9-be87-b30ad0b66196.png">

### Buffer Management in DBMS VS OS
* DBMS can **predict the order** in which pages will be accessed, or page reference patterns, much **more accurately** than is typical in OS
  * because most page references are generated by higher-level operations with a known pattern of page accesses
  * ability to predict reference patterns allows for a better choice of pages to replace
  * it also enables the use of a simple and very effective strategy called **prefetching of pages**
* DBMS has **more control over when a page is written to disk** than an OS typically provides
* DBMS can **explicitly force a page to disk** to ensure that the copy of the page on disk is updated with the copy in memory
* DBMS can **pin a page** to prevent it from replacement

## Heap Files (**Unordered**)
* Higher levels of DBMS operate on **records** and **file of records**
  * record == tuple
  * file of records == an implementation of storing tables == collection of pages, each containing a collection of records
* To support record level operations, we must:
  * keep track of the pages in a file
  * keep track of free space on pages
  * keep track of the records on a page

### Heap File Implementation
* Doubly Linked List of Pages
  * keep track of pages that have some free space
    * all pages be in this free list (always have some free space within)
    * to insert a new record, may need to scan several pages on the free list to find one with sufficient space
  * keep track of free space within a page
    * see Page Formats
* Directory of Pages
  * **much smaller than the linked list method**
  * each directory entry identifies a page (or a sequence of pages)
  * manage free space by
    * a bit per entry, indicating whether the corresponding page has any free space
    * a count per entry, indicating the amount of free space on the page
<img height="200" alt="image" src="https://user-images.githubusercontent.com/84046974/194734507-da1baeb6-1042-49f5-8fb9-94704e055c38.png" align="left">
<img height="200" alt="image" src="https://user-images.githubusercontent.com/84046974/194734511-eced98b6-83f0-486e-a2e5-3c2a1ff68380.png">

### Page Formats
* Fixed-Length
  * need to find the right amount of space
    * too small -- cannot insert
    * too big -- waste too much
  * alternative 1: store records in the first N slots
    * when a record is deleted, move the last record on the page into the vacated slot
    * empty slots appear together at the end of the page
    * locate the *i*th record on a page by a simple offset calculation
    * DO NOT WORK with external references to the record that is moved (because the rid contains the slot number, which is now changed)
  * alternative 2: using an array of bits, one per slot
    * when a record is deleted, its bit is turned off
    * empty slots are tracked by the bit
    * locate records on the page by scanning the bit array to find slots whose bit is on
* Variable-Length
  * ability to move records is important
    * when a record is inserted, must allocate just the right amount of space for it
    * when a record is deleted, must move records to fill the hole created by the deletion
    * ensure that all the free space on the page is contiguous
  * most flexible organization: maintain a directory of slots for each page, with a `<record offset, record length>` pair per slot
    * `record offset` is a 'pointer' to the record = offset in bytes from the start of the data area on the page to the start of the record
    * deletion is setting the record offset to -1 -- may not always be removed from the slot directory if the last slot persists
    * move records around by changing the offset ONLY
    * manage free space is to maintain a pointer indicating the start of the free space area (reclaim the space freed by records deleted earlier during insertion if needed)
<img height="200" alt="image" src="https://user-images.githubusercontent.com/84046974/194734519-1a7d6077-7e73-4102-94db-5e520eee29c0.png" align="left">
<img height="200" alt="image" src="https://user-images.githubusercontent.com/84046974/194734532-7798cdf9-6514-441d-b59d-fb829e2bc593.png">

### Record Formats
* System Catalogs: **catalogs are themselves stored as relations**, including the address of head (fixed) / each (variable) record + the length of each record
* Fixed-Length
  * stored consecutively
  * the address of a particular field can be calculated using information available in the system catalog
* Variable-Length
  * alternative 1: store fields consecutively, separated by delimiters
    * require a scan of the record to locate a desired field
  * alternative 2: reserve some space at the beginning of a record for use as an array of integer offsets
    * the *i*th integer in this array is the starting address of the *i*th field value **relative to the start of the record**
    * also store an offset to the end of the record to recognize where the last held ends
    * get direct access to any field
    * NULL value -- the value for a field is unavailable or inapplicable
      * the pointer to the end of the field is set to be the same as the pointer to the beginning of the field -- no space is used for representing NULL
  * modifying a field may cause it to grow, which requires shifting all subsequent fields
  * modified record may no longer fit into the space remaining on its page -- need to be moved to another page
  * record may grow so large that it no longer fits on any one page -- need to break a record into smaller records and link them together
<img height="200" alt="image" src="https://user-images.githubusercontent.com/84046974/196968765-fe9908d3-32bf-4c75-84c1-cb392d1ecf19.png" align="left">
<img height="200" alt="image" src="https://user-images.githubusercontent.com/84046974/196968945-01b7321a-2cf1-485c-ba90-77eca9142420.png">

## File Organization
* Sorted files on an attribute or a combination of attributes (called *search keys* or *keys*)
* B+ Tree
  * insert / delete at log<sub>F</sub>N cost
    * keep tree height-balanced
    * F = fanout, N = number of leaf pages
  * minimum 50% occupancy (**except for root**)
    * each node contains d <= m <= 2d entries
    * d = the order of the tree
  * IN PRACTICE
    * typical order = 100
    * typical fill-factor = 67%
    * average fanout = 133
  * insertion = split + copy up (with a suitable separator key -- **continue to appear in the leaf**) / push up (the separator -- only appear once) + (maybe) grow height
  * deletion = redistribute + borrow from sibling (toss) = merge + delete parent entry (pull down) + (maybe) decrease height
  * graphical illustration: https://www.cs.princeton.edu/courses/archive/fall08/cos597A/Notes/BplusInsertDelete.pdf
* Indexing
  * primary & secondary
    * primary index = primary key -- guaranteed not to contain duplicates
    * unique index = candidate key
    * in general, a secondary index contains duplicates
  * clustered & non-clustered
    * clustered index == the table of tuples sorted by the primary key == at most one for each table
    * non-clustered index == indices of a book == directly go to that page by using index of that book
    * clustered is faster and requires less memory for operations (in the case below, clustered needs to read in twice -- **1234** and **5678**, while non-clustered needs to read in six times -- 57**1**4, 8**3**6**2**, **5**71**4**, 83**6**2, 5**7**14, **8**362)
<img height="280" alt="image" src="https://user-images.githubusercontent.com/84046974/197590065-2c089ec6-9933-4a4c-bbb2-8e82b44de560.png" align="left">
<img height="280" alt="image" src="https://user-images.githubusercontent.com/84046974/197584189-a8d854bf-7164-4ff5-868f-7f147865bf4b.png">
