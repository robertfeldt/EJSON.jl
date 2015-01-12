using Dates

describe("EJSON specific types") do

describe("filtering ejson-specific keys") do

  test("that we can find the date key") do
    @check EJSON.filter_ejson_specific_keys({"\$date" => 0}) == ["\$date"]
  end

  test("that we can find the binary key") do
    @check EJSON.filter_ejson_specific_keys({"\$binary" => "c3VyZS4="}) == ["\$binary"]
  end

  test("that we can find multiple keys if present") do
    @check sort(EJSON.filter_ejson_specific_keys({"\$date" => 0, "\$binary" => "c3VyZS4="})) == sort(["\$date", "\$binary"])
  end

  test("that we find no keys if none present") do
    @check EJSON.filter_ejson_specific_keys({"date" => 0}) == []
  end

end

describe("recurse_and_translate") do

  test("that we don't touch dicts with no ejson specific data") do
    d1 = {:a => 1}
    @check EJSON.recurse_and_translate(d1, "\$date", (x) -> -42) == d1
    @check EJSON.recurse_and_translate(d1, "\$binary", (x) -> -42) == d1

    d2 = {:date => 1, :b => 2.3, :c => {:a => 10}}
    @check EJSON.recurse_and_translate(d2, "\$date", (x) -> -42) == d2
    @check EJSON.recurse_and_translate(d2, "\$binary", (x) -> -42) == d2
  end

end


describe("parse_ejson_date") do

  test("specific date examples") do
    @check EJSON.parse_ejson_date({"\$date" => 0}) == Dates.unix2datetime(0/1e3)
    @check EJSON.parse_ejson_date({"\$date" => 999}) == Dates.unix2datetime(999/1e3)
    @check EJSON.parse_ejson_date({"\$date" => 1000}) == Dates.unix2datetime(1.0)
  end

  @repeat test("that we can translate any date EJSON dict") do
    t = rand(0:int(1e10))
    @check EJSON.parse_ejson_date({"\$date" => t}) == Dates.unix2datetime(t/1e3)
  end

end

describe("Dates") do

  test("that it can parse the epoch itself directly") do
    dt = EJSON.parse("{\"\$date\": 0}")
    @check typeof(dt) == Dates.DateTime
  end

end # Dates

end # EJSON specific types