# HTMLDiff

[![Build Status](https://travis-ci.org/karnov/htmldiff.svg?branch=master)](https://travis-ci.org/karnov/htmldiff)

## Installation

```ruby
gem "htmldiff"
```

## Examples

```ruby
class Stuff

  class << self
    include HTMLDiff
  end

  # or extend HTMLDiff ?

end
```

```ruby
Stuff.diff('a word is here', 'a nother word is there')
```

```
# => 'a<ins class=\"diffins\"> nother</ins> word is <del class=\"diffmod\">here</del><ins class=\"diffmod\">there</ins>'
```

Checkout the crappy specs for good examples. 
