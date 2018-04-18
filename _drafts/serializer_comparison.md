---
layout: post
title: Serializer Comparison
category: project
---

One of the issues I have with python is its __dynamic typing__. Don't get me
wrong, it's a great language but I've had too many runtime issues show up that
should have easily been caught with a static type checker. Other people have
had similar problems and have developed a tool to introduce optional type
checking to python, [mypy](http://mypy-lang.org/).

This concept of types extends past the python language. When interacting with
external services you need to have a well-defined way of sending ~~structured~~
data.

# Lists of Protocols/Configuration

RPC:
- [`protobuf`][protobuf]
- [`thrift`][thrift]
- [`xmlrpc`][xmlrpc]

Serialization in Python:
- [`jsonschema`][pyjsonschema]
- [`django` Forms](https://docs.djangoproject.com/en/2.0/ref/forms/)
- [`django-rest-framework`][django-rest-framework]
- [`schematics`][schematics]
- [`marshmallow`][marshmallow]
- [`cerberus`](https://github.com/pyeve/cerberus)
- [`colander`](https://docs.pylonsproject.org/projects/colander/en/latest/)
- [`schema`](https://github.com/keleshev/schema)
- [`valideer`](https://github.com/podio/valideer)
- [`validr`](https://github.com/guyskk/validr)
- [`voluptuous`](https://github.com/alecthomas/voluptuous)

Others:
- [`GraphQL`](http://graphql.org/learn/schema/)
- [XML Schema Definition](https://en.wikipedia.org/wiki/XML_Schema_(W3C\))
- [XML Document Type Definition](https://www.xmlfiles.com/dtd/)
- [`html schema`](http://schema.org)

I'm on the lookout for incompatible representations between representations, as
well as unsupported ones.

## Scoreboard

|Attributes           |`jsonschema`|`Django.Form`|
|---------------------|------------|-------------|
|Normalize            |            | Y(clean)    |
|Error Message Change |            | Y           |
|Heterogenous         |            | Y(Combo)    |
|Relationships        |            | Y           |

## JSONSchema

Platform independent schema specification. Found [here][jsonschema], with some
great documentation
[here](https://spacetelescope.github.io/understanding-json-schema/).

### Types:
- string
  - `minLength`
  - `maxLength`
  - `pattern`
  - `format`: (date-time, email, hostname, ipv4, ipv6, uri)
- integer & number
  - `multipleOf`
  - `minimum`
  - `exclusiveMinimum`
  - `maximum`
  - `exclusiveMaximum`
- object
  - `properties`
  - `additionalProperties`
  - `required`
  - `minProperties`
  - `maxProperties`
  - `dependencies` (when requirement of one fields depends on another)
  - `patternProperties`
- array
  - `items`
  - `additionalItems`
  - `minItems`
  - `maxItems`
  - `uniqueness`
- boolean
- null

### Generic Keywords:
- `title`
- `description`
- `default`
- `enum`

### Control Keywords:
- `allOf`
- `anyOf`
- `oneOf`
- `not`

- `$schema`: Specifies schema version
- `definitions`: A collection of schemas that can be `$ref`d later
- `$ref`: Reference definitions ie) `#/definitions/address`
  - Can be used to extend schemas with `allOf`
- `id`

## Django.Form

Forms are composed of
[Fields](https://docs.djangoproject.com/en/2.0/ref/forms/fields/).
Fields are represented in the UI as
[widgets](https://docs.djangoproject.com/en/2.0/ref/forms/widgets/).

Form operation:
- `.is_valid()` to populate `.cleaned_data`
  - `.cleaned_data` is a dictionary to the python types of the data that was
    passed in
- `.non_field_errors` and `.<name_of_field>.errors` are useful

- `.is_bound` specifies whether it has data
- `.clean()` does inter-field validation
- `.is_valid()`
- `.errrors`

How do forms get rendered into html templates? A: Widgets.

### Fields

- `.clean(val)` returns the cleaned value or raises a `ValidationError`
  - `.to_python()`
  - `.validate()`
  - `.run_validators()`

Core arguments:
- `required`
- `label`
- `label_suffix`
- `initial` (only for display)
- `widget`
- `help_text`
- `error_messages`: dictionary of overriden error messages
- `validators`
- `disabled` (basically read-only)

Validates and cleans data (normalizes).

`FormSet` allows many forms to show up at once.

Do forms support nesting? A: kind of with `ForeignKey`, etc.

Media can be bound to widgets.

Types:
- bool
- char
  - `max_length`, `min_length`, `strip`, `empty_value`
- choice
  - `choices`, can be a callable or a list of 2-tuples
- TypedChoice, sub-class of choice
  - `coerce`, `empty_value`
- Date
  - `input_formats`
- DateTime
  - `input_formats`
- Decimal
  - `min_value`, `max_value`, `max_digits`, `decimal_places`
- Duration
- Email
  - `min/max_length`
- File
  - `max_length`, `allow_empty_file`
- FilePathField
  - etc
- Float
- Image
- int
- genericIP
- MultipleChoice/Typed
- NullBoolean
- Regex
- Slug
- URL
- UUID

- Combo
- MultiValue (Maybe kind of nesting?)
- SplitDateTime
- ModelChoiceField
- ModelMultipleChoiceField

## Schematics


## Field Attributes

### DRF

# Serializers

Note: I should be able to use this mostly cut/paste for a blog entry.

This file will keep most of the notes on the attributes of the various
serializers, and make note of the similarities, differences, etc.

## Which Serializers are we looking at?

- Django Rest Framework
- Schematics
- Marshmallow

## How does each one work?

### Django Rest Framework

### Schematics

### Marshmallow

Schemas are serialized (aka `dump`ed) to a native representation. `dumps`
returns a `json` string.

Native dictionaries are `load`ed into a `schema`, the output is another
dictionary with native datatypes, ie) datetimes. In order for `load` to return
an `Object`, a `@post_load` decorator needs to be placed on the schema's class.
`many` should be set to true when instantiating the schema to operate on a list
of items.


Is a `Schema` just a field?

`load` raises a `ValidationError`.

#### Schema

`Meta`:
- `fields` that are used
- `additional`
- `ordered`, keeps order in output

#### Field

Options:
- `required`
- `error_messages`: A dictionary, key is what was errored to what should be
  said.
- Attribute names serialization/deserialization keys:
  - `attribute`
  - `data_key`
- Read/Write:
  - `load_only`
  - `dump_only`
- `many`: For a list


Defines:
- `_serialize(self, value, attr, obj)`
- `_deserialize`

Can be a method.

Types:
- `Nested`: Takes in a `Schema`
  - `only`: Specify nested fields
  - Can pass in `self` to nest itself

## Given ^, what makes each unique?

### Django Rest Framework

### Schematics

### Marshmallow

## What do all of these serializers have in common?

All serializers have these in common: ...


# Acknowledgements

- Thanks to [awesome-python](https://awesome-python.com/) for helping me find
  some interesting serialization frameworks.

# Other Resources
- [Comparison of GraphQL, JSONSchema, JSON-LD](https://react-etc.net/entry/graphql-json-ld-and-json-schema-formats-explained)
- [Hackernews Thread](https://news.ycombinator.com/item?id=15629253)
- [Comparison of Serialization Formats](https://www.sitepoint.com/data-serialization-comparison-json-yaml-bson-messagepack/)

[django-rest-framework]: http://www.django-rest-framework.org/ "Django Rest Framework"
[jsonschema]: http://json-schema.org/ "JSONSchema"
[marshmallow]: https://github.com/marshmallow-code/marshmallow "Marshmallow"
[protobuf]: https://developers.google.com/protocol-buffers/ "Protocol Buffers"
[pyjsonschema]: https://github.com/Julian/jsonschema "Python JSONSchema"
[schematics]: https://github.com/schematics/schematics "Schematics"
[thrift]: https://thrift.apache.org/ "Apache Thrift"
[xmlrpc]: https://docs.python.org/3/library/xmlrpc.html "XMLRPC"
