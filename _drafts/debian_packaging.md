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
  * \- Development gets a little trickier. How do you make a new artifact from a
    dev-branch
  * \+ You can do all of your static asset compilation ahead of time
  * \- Our current setting configuration probably wouldn't play well with this



## Neat Scripts

Building a package from source
```bash
apt-get source foo
cd foo-0.0.1
sudo apt-get build-dep foo
debuild -i -us -uc -b
# or dpkg-buildpackage
# Show the contents
dpkg -c ../foo.0.0.1.deb
```


## `dh`

Runs specific set of commands. Pass `--no-act` and `--verbose` to `dh` in
debian/rules.


![Packaging Workflow]({{site.baseurl}}/images/packaging/workflow.png "Packaging Workflow")

## Debian package contents

Inside of `ar` directory

```
some_pkg.deb
├── debian-binary  - Version of deb file format
├── control.tar.gz - Control md5sums [pre|post](rm|inst), triggers, shlibs
└── data.tar.gz    - Data files of the package
```


## `debian/` Directory Layout

Main files
```
debian
├── control
├── rules
├── copyright
└── changelog
```

Extra files
```
debian
├─ compat
├─ watch
├─ dh_install* targets (*.dirs, *.manpages, *.docs)
├─ Maintainer Scripts ([post|pre](inst|rm))
├─ Patches/
└── source
    └── format
```

### changelog

#### Version Breakdown

1.2.1.1-5
* 1.2.1.1 Upstream Version
* 5 Debian revision

Use `dch`. `dch -i` creates new release.

Gets installed into /usr/share/doc/<package>/changelog.Debian.gz

### control

Package metadata

### rules

Makefile

Required targets:
* `build`, `build-arch`, `build-indep` (config and compilation)
* `binary`, `binary-arch`, binary-indep` (builds binary packages)
* `clean` (cleans up the source directory)

`debhelper` helps take care of commonalities. Here is an example
[`debhelper` Makefile](https://gist.github.com/michael-christen/82b831c66abda13fa6f53b085604efa6).

#### Debhelper add-ons

* `cdbs` - help with common functionality
* `dh` - even better and easier to customize http://joeyh.name/talks/debhelper/debhelper-slides.pdf


USE `dh`!

### Installing and testing

`debi` - uses changes to know what to instal
`debc` - lists content from changes
`debdiff` - changes to compare or `.dsc`
`lintian` - to check
`dput` - uploads

Manage debian archive with `reprepo` or `aptly`
* https://wiki.debian.org/HowToSetupADebianRepository

## Tools

* `dch` - Can help manage `changelog`
* `debuild -us -uc` - builds the package
  * Or `dpkg-buildpackage`
* `dpkg -i` - installs it
* `dpkg-source`
* `dh_make` - __debianizes__ the package for you.
* `pbuilder` - helps isolate build environment for reproducible and safe builds.
  * https://wiki.ubuntu.com/PbuilderHowto
  * Alternatives: (`schroot`, `sbuild`). Tricky, https://help.ubuntu.com/community/SbuildLVMHowto.
* `lintian` - checks packages
* `piuparts` - checks .deb packages
* `debhelper`

## Open Questions

- [ ] How does git-buildpackage fit in?


## Resources

### Official Debian

* [Packaging Tutorial](https://www.debian.org/doc/manuals/packaging-tutorial/packaging-tutorial.en.pdf)
* [Packaging](https://wiki.debian.org/Packaging)
* [Guide for Debian Maintainers](https://www.debian.org/doc/manuals/debmake-doc/index.en.html)
  * Recommended by [Debian New Maintainer's Guide](https://www.debian.org/doc/manuals/maint-guide/index.en.html)
* [Quick Reference](https://www.debian.org/doc/user-manuals#quick-reference)
* [Debian Package Management](https://www.debian.org/doc/manuals/debian-reference/ch02.en.html)
* [Intro to Debian Packaging](https://wiki.debian.org/Packaging/Intro?action=show&redirect=IntroDebianPackaging)
* [How to Package for Debian](https://wiki.debian.org/HowToPackageForDebian)
* [Single Binary Package Building](http://tldp.org/HOWTO/html_single/Debian-Binary-Package-Building-HOWTO/)
* [Debian Developer's Reference](https://www.debian.org/doc/manuals/developers-reference/)
  * [Best Packaging Practices](https://www.debian.org/doc/manuals/developers-reference/best-pkging-practices.html)
* [Debian Policy][]
* [Debian Developers' Corner](https://www.debian.org/devel/)
* [Django Packaging Draft](https://wiki.debian.org/DjangoPackagingDraft)

### Articles

#### Maintainer Scripts

* [Maintainer Scripts](https://people.debian.org/~srivasta/MaintainerScripts.html)


## Native Python Packages

### Python References:

* [Python Policy](https://www.debian.org/doc/packaging-manuals/python-policy/)
* [Python Library Style Guide](https://wiki.debian.org/Python/LibraryStyleGuide)

### Articles about python deployment

* [Recipe for Django Deployment](https://brejoc.com/cup-recipe-for-django-python-deployment-or-how-to-make-your-admin-happy/)
* [Nylas Deployment](https://www.nylas.com/blog/packaging-deploying-python/)

### Tools for Creating Native Packages of Python Applications

* [dh-virtualenv](https://github.com/spotify/dh-virtualenv)
  * [make-deb](https://github.com/nylas/make-deb) creates `debian/` folder from setup.py
  * [stdeb](https://pypi.python.org/pypi/stdeb/0.8.5) is an alternative
* [fpm](https://github.com/jordansissel/fpm)
  * [Graphite-api example](https://github.com/brutasse/graphite-api)

<!-- References -->

[Debian Policy]: https://www.debian.org/doc/debian-policy/ "Debian Policy"
