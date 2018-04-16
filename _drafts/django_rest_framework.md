---

layout: post
title: Django Rest Framework
category: project

---

> Django is Python's killer app and DRF is Django's killer app.

Django Rest Framework, DRF, is a framework that can be used to easily create
API endpoints in your django application. If you'd like to learn more about it,
I'd highly reccomend checking out the [documentation][docs] and the
[tutorial][tutorial].

This post simply records what I thought of DRF, and makes note of anything I
thought was particularly interesting or worth writing down so that I could look
back later.


# High Level Architecture

DRF does a great job of separating its modules, and as a result has a great
architecture. The components are:
- Content Negotiation: `Parser` and `Renderer`
- Authentication and Denial of Service: `Authentication`, `Permission`, `Throttle`
- View
- Serializer

The diagram below describes how they interact when processing a request.
Eventually, the `View` uses the deserialized object to perform some kind of
operation, typically that can involve retrieving or updating some
`django.Model`'s state, but it could also be used to start a `celery` task or
anything else.

{% include figure.html url='/assets/img/drf/architecture.png' caption='Life of a Request' %}

The [tutorial][tutorial] takes a neat stance, starting with a `Serializer`, and
using it in a normal `Django` `View`. The rest of the tutorial flushes out the
various other aspects of DRF. I found this tutorial format very helpful since
it built on pre-existing knowledge of Django instead of just throwing the
developer into the deepend. If they had wanted to, they could have started out
the tutorial with an `APIView`, and not even used a `Serializer`.

These `APIView`s extend `django.View` with some great functionalities. They add
content negotiation via `parsers` and `renderers` which deal with the provided
and expected content-types respectively. The View also handles the
authentication, permissions, and throttling behavior. Note that the diagram
above doesn't show how these are part of the view. I thought it was clearer to
simply explain their implementation here.  It provides a common `Request`
object to users of the view that provides an abstraction away from the original
content type. Users return `rest_framework.Response`s, these use a `Renderer`
to generate `rendered_content` which is then finally returned to the client.

`APIView` is implemented as a subclass of `django.View`, it overrides the
`dispatch` method to insert all of its behavior:
- version management
- content negotiation
- `Request` generation from `HttpRequest`
- authentication, permissions, throttling
- calling the correct `method`
- custom exception handling
- massage the final response

The `APIView` is further extended by a `GenericAPIView` which provides an
interface with `Django` models through the `.queryset` attribute and
`Serializers` with the `.serializer_class` attribute. It also manages some
extra functionality around `Filter`s and `Pagination`.

Several `Mixin`s are present that provide common functionality, ie)
- `list`
- `create`

The more common combinations of `Mixin`s have already been created, ie)
`RetrieveUpdateDestroyAPIView` and `ListCreateAPIView`.

Instead of separating views, you can group them into a `ViewSet`, all this is
is a way to consolidate similar `View` setup into one class. The way it works
is by exposing an `as_view` class method which binds http methods to actions on
the `View`. Thus, allowing us to basically have multiple views in one. This can
be easily added to url configuration with the help of a `Router`, which
automatically determine the url configuration of the viewset.

A lot of the magic bits of DRF revolve around the automatic introspection of
models, with the `ModelSerializer`.

The `Serializer` uses a `MetaClass` to setup the fields provided by viewing the
`attrs` variable on each class it's applied to. Attributes from the `Meta`
class are merely retrieved by getting the attribute from the 'Meta' attribute.
`to_internal_value` and `to_representation` are defined to provide conversion.
The `ModelSerializer` is a fun ride, but at its core uses a mapping of `Model`
`Field`s to `drf.Field`s to arrive at a serializer.

A future post could go more in depth into:
- Specifics of serialization and `Model` introspection
- Analogies with Django Forms
- Comparison to other `Serialization` frameworks

[docs]: http://www.django-rest-framework.org/ "Django Rest Framework Docs"
[tutorial]: http://www.django-rest-framework.org/tutorial/quickstart/ "Django Rest Framework Tutorial"
