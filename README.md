# Advent of code 2016
Advent of code 2016 solutions.

By kannix68 @ github dot com.

## Advent of code info and friends

Advent of code 2016 is at <http://adventofcode.com/>.
Thanks Eric Wastl and company!

## Input data

Input data given for my AOC login is saved in a text file
`day[DD]_data.txt`.
Note the problem data is individual for each participating coder (user athenticated),
but the data files checked in here can be used for verification and sample (test) data.

## Solutions

Solutions are saved to `day[DD]_[a|b].[prog-lang-extension]`, if the language allows.
For languages with strict naming conventions, such as java, this may differ.

Most solutions are straight-forward, plain, non-elegant,
non-optimized (with respect to code- or program-size, speed or memory consumption),
ad-hoc/brute force solutions.

### Days Calendar
Info for solutions in this repository:

* Day 8: Java 8,
    using gradle 3.2 build system
* Day 7: Kotlin 1.0
* Day 6: Clojure 1.8
* Day 5: Crystal 0.20.1 and Ruby 2.3
* Day 4: Ruby 2.3
* Day 3: Python 2.7
* Day 2: Python 2.7
* Day 1: Perl 5.8.4 +

## Programming language specifica

### perl
Perl means a perl 5 standard distribution,
tested using perl v5.18.2 on Mac OS X.

### python
Python means a python 2.7 standard distribution,
tested using python 2.7.12 in a homebrew environment on Mac OS X.

### ruby
Ruby means a ruby 2.3 standard distribution (MRI),
tested using ruby v2.3.3 in a rvm environment on Mac OS X.

A `Gemfile` for bundler is suppied, so you can use

    bundle install  # generate Gemfile.lock GemSet
    bundle exec day04_a.rb  # execute script 

to execute in a Bundler-Environment with specified ruby Version an gems.

### crystal
Crystal means Crystal 0.20.1.
Ruby-like language, but typed and compiled, see <https://crystal-lang.org>.

### clojure
Clojure means clojure 1.8 in a Mac OS X java JRE environment.

### kotlin
Kotlin means `kotlinc` compiler in a Mac OS X java environment.
"Kotlin Compiler version 1.0.5-2".

### java
Java means JDK Version 1.8.0_45 on Mac OS X.

Build system is gradle v.3.2.1; targeting a java application jar.
