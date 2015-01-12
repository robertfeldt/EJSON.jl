# Based on runtests.jl from JSON.jl package on Github:
#  https://github.com/JuliaLang/JSON.jl/blob/master/test/runtests.jl
#

using JSON
using Compat

include(joinpath(dirname(@__FILE__),"json_samples.jl"))

describe("JSON examples from http://json.org/example.html") do

test("c") do
    j = EJSON.parse(c)
    @check j != nothing
    @check typeof(j["widget"]["image"]["hOffset"]) == Int
    @check j["widget"]["image"]["hOffset"] == 250
    @check typeof(j["widget"]["text"]["size"]) == Float64
    @check j["widget"]["text"]["size"] == 36.5
end

test("e") do
    j = EJSON.parse(e)
    @check j != nothing
    @check typeof(j) == Dict{AbstractString, Any}
    @check length(j) == 1
    @check typeof(j["menu"]) == Dict{AbstractString, Any}
    @check length(j["menu"]) == 2
    @check j["menu"]["header"] == "SVG\tViewerα"
    @check isa(j["menu"]["items"], Array)
    @check length(j["menu"]["items"]) == 22
    @check j["menu"]["items"][3] == nothing
    @check j["menu"]["items"][2]["id"] == "OpenNew"
    @check j["menu"]["items"][2]["label"] == "Open New"
end

test("flickr") do
    k = EJSON.parse(flickr)
    @check k != nothing
    @check k["totalItems"] == 222
    @check k["items"][1]["description"][12] == '\"'
end


test("unicode") do
    u = EJSON.parse(unicode)
    @check u != nothing
    @check u["অলিম্পিকস"]["রেকর্ড"][2]["Marathon"] == "জনি হেইস"
end

## -------
#
#finished_async_tests = RemoteRef()
#
#@async begin
#    s = listen(7777)
#    s = accept(s)
#
#    s.line_buffered = false
#    start_reading(s)
#
#    @check JSON.parse(s) != nothing  # a
#    @check JSON.parse(s) != nothing  # b
#    validate_c(s)                     # c
#    @check JSON.parse(s) != nothing  # d
#    validate_e(s)                     # e
#    @check JSON.parse(s) != nothing  # gmaps
#    @check JSON.parse(s) != nothing  # colors1
#    @check JSON.parse(s) != nothing  # colors2
#    @check JSON.parse(s) != nothing  # colors3
#    @check JSON.parse(s) != nothing  # twitter
#    @check JSON.parse(s) != nothing  # facebook
#    validate_flickr(s)                # flickr
#    @check JSON.parse(s) != nothing  # youtube
#    @check JSON.parse(s) != nothing  # iphone
#    @check JSON.parse(s) != nothing  # customer
#    @check JSON.parse(s) != nothing  # product
#    @check JSON.parse(s) != nothing  # interop
#    validate_unicode(s)               # unicode
#    @check JSON.parse(s) != nothing  # issue5
#    @check JSON.parse(s) != nothing  # dollars
#    @check JSON.parse(s) != nothing  # brackets
#
#    put!(finished_async_tests, nothing)
#end
#
#w = connect("localhost", 7777)
#
#@check JSON.parse(a) != nothing
#write(w, a)
#
#@check JSON.parse(b) != nothing
#write(w, b)
#
#validate_c(c)
#write(w, c)
#
#@check JSON.parse(d) != nothing
#write(w, d)
#
#validate_e(e)
#write(w, e)
#
#@check JSON.parse(gmaps) != nothing
#write(w, gmaps)
#
#@check JSON.parse(colors1) != nothing
#write(w, colors1)
#
#@check JSON.parse(colors2) != nothing
#write(w, colors2)
#
#@check JSON.parse(colors3) != nothing
#write(w, colors3)
#
#@check JSON.parse(twitter) != nothing
#write(w, twitter)
#
#@check JSON.parse(facebook) != nothing
#write(w, facebook)
#
#validate_flickr(flickr)
#write(w, flickr)
#
#@check JSON.parse(youtube) != nothing
#write(w, youtube)
#
#@check JSON.parse(iphone) != nothing
#write(w, iphone)
#
#@check JSON.parse(customer) != nothing
#write(w, customer)
#
#@check JSON.parse(product) != nothing
#write(w, product)
#
#@check JSON.parse(interop) != nothing
#write(w, interop)
#
#validate_unicode(unicode)
#write(w, unicode)
#
#
##Issue 5 on Github
#issue5 = "[\"A\",\"B\",\"C\\n\"]"
#JSON.parse(issue5)
#write(w, issue5)
#
## $ escaping issue
#dollars = ["all of the \$s", "µniçø∂\$"]
#json_dollars = json(dollars)
#@check JSON.parse(json_dollars) != nothing
#write(w, json_dollars)
#
## unmatched brackets
#brackets = @compat Dict("foo"=>"ba}r", "be}e]p"=>"boo{p")
#json_brackets = json(brackets)
#@check JSON.parse(json_brackets) != nothing
#write(w, json_dollars)
#
#fetch(finished_async_tests)
#
#zeros = @compat Dict("\0"=>"\0")
#json_zeros = json(zeros)
#@check contains(json_zeros,"\\u0000")
#@check !contains(json_zeros,"\\0")
#@check JSON.parse(json_zeros) == zeros
#
##Uncomment while doing timing tests
##@time for i=1:100 ; JSON.parse(d) ; end
#
#
## Printing an empty array or Dict shouldn't cause a BoundsError
#@check json(ASCIIString[]) == "[]"
#@check json(Dict()) == "{}"
#
##test for issue 26
#obj = JSON.parse("{\"a\":2e10}")
#@test(obj["a"] == 2e10)
#
##test for issue 21
#a=JSON.parse(test21)
#@check isa(a, Array{Any})
#@check length(a) == 2
##Multidimensional arrays
#@check json([0 1; 2 0]) == "[[0,2],[1,0]]"
#
#
## ::Nothing values should be encoded as null
#testDict = @compat Dict("a" => nothing)
#nothingJson = JSON.json(testDict)
#nothingDict = JSON.parse(nothingJson)
#@check testDict == nothingDict
#
#
## test for issue #57
#obj = JSON.parse("{\"\U0001d712\":\"\\ud835\\udf12\"}")
#@test(obj["𝜒"] == "𝜒")
#
## test for single values
#@check JSON.parse("true") == true
#@check JSON.parse("null") == nothing
#@check JSON.parse("\"hello\"") == "hello"
#@check JSON.parse("\"a\"") == "a"
#@check JSON.parse("1") == 1
#@check JSON.parse("1.5") == 1.5
#
## test parsefile
#tmppath, io = mktemp()
#write(io, facebook)
#close(io)
#@unix_only @check haskey(JSON.parsefile(tmppath), "data")
## don't use mmap on Windows, to avoid ERROR: unlink: operation not permitted (EPERM)
#@windows_only @check haskey(JSON.parsefile(tmppath; use_mmap=false), "data")
#rm(tmppath)
#
## check indented json has same final value as non indented
#
#fb = JSON.parse(facebook)
#fbjson1 = json(fb, 2)
#fbjson2 = json(fb)
#@check JSON.parse(fbjson1) == JSON.parse(fbjson2)
#
#ev = JSON.parse(e)
#ejson1 = json(ev, 2)
#ejson2 = json(ev)
#@check JSON.parse(ejson1) == JSON.parse(ejson2)
#
## test symbols are treated as strings
#symtest = @compat Dict(:symbolarray => [:apple, :pear], :symbolsingleton => :hello)
#@check (JSON.json(symtest) == "{\"symbolarray\":[\"apple\",\"pear\"],\"symbolsingleton\":\"hello\"}"
#         || JSON.json(symtest) == "{\"symbolsingleton\":\"hello\",\"symbolarray\":[\"apple\",\"pear\"]}")
#

end
