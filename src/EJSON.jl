module EJSON
  using JSON
  using Dates

  function parse(str)
    res = JSON.parse(str)
    res = recurse_and_translate(res, "\$date", parse_ejson_date)
    res
  end

  function recurse_and_translate(dict, ejsonkey, translationFunc)
    if typeof(dict) == Dict
      if length(dict) == 1 && collect(keys(dict)) == [ejsonkey]
        return translationFunc(dict)
      else
        for k in keys(dict)
          dict[k] = recurse_and_translate(dict[k], ejsonkey, translationFunc)
        end
      end
    end
    return dict
  end

  function parse_ejson_date(dict)
    Dates.unix2datetime(dict["\$date"]/1e3)
  end

  function filter_ejson_specific_keys(dict)
    collect(filter((k) -> in(k, ["\$date", "\$binary"]), keys(dict)))
  end
end