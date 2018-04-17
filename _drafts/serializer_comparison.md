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
- [`django-rest-framework`][django-rest-framework]
- [`marshmallow`][marshmallow]
- [`schematics`][schematics]
- [`jsonschema`][pyjsonschema]
- [`cerberus`](https://github.com/pyeve/cerberus)
- [`colander`](https://docs.pylonsproject.org/projects/colander/en/latest/)
- [`schema`](https://github.com/keleshev/schema)
- [`valideer`](https://github.com/podio/valideer)
- [`voluptuous`](https://github.com/alecthomas/voluptuous)

I'm on the lookout for incompatible representations between representations, as
well as unsupported ones.

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

- Thanks to [awesome-python](https://github.com/vinta/awesome-python) for
  helping me find some interesting serialization frameworks.

[django-rest-framework]: http://www.django-rest-framework.org/ "Django Rest Framework"
[jsonschema]: http://json-schema.org/ "JSONSchema"
[marshmallow]: https://github.com/marshmallow-code/marshmallow "Marshmallow"
[protobuf]: https://developers.google.com/protocol-buffers/ "Protocol Buffers"
[pyjsonschema]: https://github.com/vinta/awesome-python "Python JSONSchema"
[schematics]: https://github.com/schematics/schematics "Schematics"
[thrift]: https://thrift.apache.org/ "Apache Thrift"
[xmlrpc]: https://docs.python.org/3/library/xmlrpc.html "XMLRPC"
