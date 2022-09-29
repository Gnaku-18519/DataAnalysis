# Database
## ER Diagram
* Entity (eg. Product)
* Attribute (eg. price, name, category)
  * Domain: the atomic type of every attribute
* Entity Set should have more than one attributes or is the "many" in many-one or many-many relationships
<img width="300" alt="image" src="https://user-images.githubusercontent.com/84046974/192125834-88067859-e573-4b8a-bdd9-22702db1b5e6.png">

### Subclass = special case = fewer entities = more properties
<img width="211" alt="image" src="https://user-images.githubusercontent.com/84046974/192126121-e37ae113-ca89-428b-8bda-af4f14bcf36f.png">

* ER: entities have components in every subclass they belong
* Object-oriented: objects in one class only; subclasses inherit from superclasses

### Weak Entity Set
* definition: their key attributes come from other classes to which they are related
* description: "A loan entity can not be created for a customer if the customer doesn’t exist."
<img width="430" alt="image" src="https://user-images.githubusercontent.com/84046974/192127335-42baf7bf-7b63-4718-b632-68139cc25010.png">

### Design Principles
1. Be faithful
2. Avoid redundancy -- waste space and (more importantly) encourage inconsistency
3. KISS
## Relations
### Attributes of relationships is not necessary, but useful (especially in many-many relationships, as the attribute cannot be associated to only one entity)
### Binary
<img width="400" alt="image" src="https://user-images.githubusercontent.com/84046974/192125903-34a3fd89-037d-4a95-85e6-162defa9baca.png">

### Multiway
<img width="400" alt="image" src="https://user-images.githubusercontent.com/84046974/192125974-13cb5685-4f79-4b5a-935b-d310e726ee9e.png">

## Modeling Constraints
* Keys (**underline in ER**): social security number uniquely identifies a person
  * every entity must have a key
  * a key may contain multiple attributes
  * can be more keys for an entity set
  * only one primary key
* Single Value constraints (**at most one value** in a given role, **implied in many-one relationships**): a person can have only one father
* Referential Integrity constraints (**exactly one value** in a given role, non-null): if you work for a company, it must exist in the database
* Domain constraints: peoples’ ages are between 0 and 150
* General constraints: all others (at most 50 students enroll in a class)

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

# SQL (case-insensitive)
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
WHERE    x.name=y.buyer AND y.product=z.name AND z.category=“telephony”
```
* Explicit Tuple Variables
```sql
SELECT   b1.name, b2.name
FROM     Beers b1, Beers b2
WHERE    b1.manf = b2.manf AND b1.name < b2.name;
```
## Aggregation
* SUM, AVG, COUNT, MIN, and MAX can be applied to a column in a SELECT clause to produce that aggregation on the column
* COUNT(\*) counts the number of tuples
```sql
SELECT   AVG(price)
FROM     Sells
WHERE    beer = ‘Bud’;
```
## Group-By and Having
* "**for each** such bar" <=> ```GROUP BY bar```
* Difference between ```WHERE``` and ```HAVING```: ```WHERE``` condition happens before ```GROUP BY```, and ```HAVING``` happens after ```GROUP BY```
<img width="419" alt="image" src="https://user-images.githubusercontent.com/84046974/192130486-e2b996c4-b9c1-4071-bf11-c7a78841c9a0.png">

## More Details
* Rename: ```SELECT name AS beer```
* Expression: ```SELECT price * 7 AS priceInYuan```
* NULL value: ```x IS NULL```
  * Missing value
  * Inapplicable
  * When any value is compared with NULL, the truth value is **UNKNOWN**
    * A query only produces a tuple in the answer if its truth value for the WHERE clause is TRUE (not FALSE or UNKNOWN)
* Subquery
  * If a subquery is guaranteed to produce one tuple, then the subquery can be used as a value
<img width="365" alt="image" src="https://user-images.githubusercontent.com/84046974/192937520-e8e53094-8471-44cc-948d-c94ec1b9eaed.png">
* Boolean Operators
  * IN: ```<tuple> IN <relation>```, where ```<relation>``` is always a subquery
  * EXISTS: ```EXISTS( <relation> )``` is true if and only if ```<relation>``` is **not empty**
  * ANY:
    * ```x = ANY( <relation> )``` is true if x equals at least one tuple in the relation
    * ```x >= ANY( <relation> )``` is true if x is not smaller than all tuples in the relation
    * Note that each tuple can have one component only
  * ALL:
    * ```x <> ALL( <relation> )``` is true if and only if for every tuple t in the relation, x is not equal to t -> x is not a member of the relation
    * ```x >= ALL( <relation> )``` is true if there is no tuple larger than x in the relation
