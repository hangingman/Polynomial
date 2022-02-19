# PolyRuby

Classes about polynomial, rational polynomial, hyper real(non-standard analyses).
Originally developed by K.Kodama(kdm@kobe-kosen.ac.jp).

## Overview

* This package is distributed freely in the sense of GNU General Public License(GPL). See http://www.gnu.org/copyleft/gpl.html.
* Polynomial-like classes:
    * Polynomial: 1-variable polynomial
    * PolynomialM: multi-variable polynomial
    * RationalPoly: 1-variable rational polynomial
    * RationalPolyM: multi-variable rational polynomial
* Coefficients:
    * Coefficients are Integer or Float by default. And Z/pZ (p:prime).
    * We can use Rational or Complex with require "rational" or require "complex".
    * Other field or ring is admitted if you define.
* Grobner bases:
    * For multi variable polynomials, it supports coefficients of
    * Integer, Z/pZ (p:prime), Rational, Float and Complex.
    * For 1-variable polynomials, it supports Integer coefficient and
    * Integer coefficients Laurent polynomials.
* Factorization:
    * It support factorization for 1-variable Integer and Rational coefficient.
* Hyper-Real (non-standard analyses) class:
    * HyperReal class supports non-standard analyses.
    * It supports infinity, infinitesimal, limit, derivatives, auto-diff.
* Extensions for Math functions:
    * MathExt module supports many functions for
    * HyperReal, Rational, Polynomial, RationalPoly, etc.
* Number theory:
    * Number module contains some function on number theory and algebra.
* Samples:
    * See samples scripts sample-*.rb.

***** THANKS *****
Many thanks to members of ruby-list mailing list for their advice.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'poly_ruby'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install poly_ruby

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hangingman/Polynomial .
