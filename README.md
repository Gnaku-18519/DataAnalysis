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

