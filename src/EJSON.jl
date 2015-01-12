module EJSON
  using JSON

  function parse(str)
    JSON.parse(str)
  end
end