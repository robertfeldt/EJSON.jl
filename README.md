# EJSON.jl
### Parsing and printing EJSON (Extended JSON) in pure Julia.

[![Build Status](https://travis-ci.org/robertfeldt/EJSON.jl.svg)](https://travis-ci.org/robertfeldt/EJSON.jl)
[![Coverage Status](https://img.shields.io/coveralls/robertfeldt/EJSON.jl.svg)](https://coveralls.io/r/robertfeldt/EJSON.jl)

**Installation**: `julia> Pkg.clone("https://github.com/robertfeldt/EJSON.jl")`

## Basic Usage

```julia
import EJSON

s = "{\"a_number\" : 5.0, \"an_array\" : [\"string\", 9], \"a_date\": {\"$date\": 1358205756553}}"
j = EJSON.parse(s)
#  Dict{String,Any} with 3 entries:
#    "an_array" => {"string",9}
#    "a_number" => 5.0
#    "a_date"   => 2013-01-14T23:22:36.553

# EJSON.json - Julia data structures to a string
EJSON.json([2,3])
#  "[2,3]"
EJSON.json(j)
#  "{\"an_array\":[\"string\",9],\"a_number\":5.0,\"a_date\": {\"$date\": 1358205756553}}"
```

## Documentation

```julia
EJSON.print(io::IO, s::String)
EJSON.print(io::IO, s::Union(Integer, FloatingPoint))
EJSON.print(io::IO, n::Nothing)
EJSON.print(io::IO, b::Bool)
EJSON.print(io::IO, a::Associative)
EJSON.print(io::IO, v::AbstractVector)
EJSON.print{T, N}(io::IO, v::Array{T, N})
```

Writes a compact (no extra whitespace or identation) JSON representation
to the supplied IO.

```julia
ejson(a::Any)
```

Returns a compact JSON representation as a String.

```julia
EJSON.parse(s::String; ordered=false)
EJSON.parse(io::IO; ordered=false)
EJSON.parsefile(filename::String; ordered=false, use_mmap=true)
```

Parses a EJSON String or IO stream into a nested Array or Dict.
