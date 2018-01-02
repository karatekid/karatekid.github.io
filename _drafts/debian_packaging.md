---

layout: post
title: Debian Packaging
category: project

---

At work, I've been thinking about the idea of improving our Django deployment
for some time now. We have a slight issue with our current deployment strategy.
The versions of all of our dependencies are specified via puppet manifests.
What's worse is that we have default versions for most of these dependencies
that get propagated to all apps whenever they are updated. This leads to an
inherent difference between development and production. When developing we
specify our dependencies via a `requirements.txt` file, and try to keep our
puppet manifests up to date with that. We should probably just install from our
`requirements.txt` file directly.

General outline:
* whole `requirements.txt` pins everything, nice and reproducible but very
  annoying to update
* `pipenv` solves these problems
* End up with issues if you have multiple services. It would be nice to keep
  them isolated in separate virtualenvs. Not completely necessary for our use
case and if you have 2 services, only 1 really needs to be isolated.
* Other problem is that `puppet` is no longer aware of status of installed
  requirements, so you could end up in bad state that never gets fixed
* If you generated a build artifact you'd have a ground truth and super quick
  installations
  * - Development gets a little trickier. How do you make a new artifact from a
    dev-branch
  * + You can do all of your static asset compilation ahead of time
  * - Our current setting configuration probably wouldn't play well with this
