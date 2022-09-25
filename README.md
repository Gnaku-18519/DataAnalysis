# Database
## ER Diagram
* Entity (eg. Product)
* Attribute (eg. price, name, category)
<img width="300" alt="image" src="https://user-images.githubusercontent.com/84046974/192125834-88067859-e573-4b8a-bdd9-22702db1b5e6.png">

### Subclass = special case = fewer entities = more properties
<img width="211" alt="image" src="https://user-images.githubusercontent.com/84046974/192126121-e37ae113-ca89-428b-8bda-af4f14bcf36f.png">

* ER: entities have components in every subclass they belong
* Object-oriented: objects in one class only; subclasses inherit from superclasses
## Relations
### Attributes of relationships is not necessary, but useful (especially in many-to-many relationships, as the attribute cannot be associated to only one entity)
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
* Single-value constraints: a person can have only one father
* Referential integrity constraints: if you work for a company, it must exist in the database
* Domain constraints: peoples’ ages are between 0 and 150
* General constraints: all others (at most 50 students enroll in a class)
