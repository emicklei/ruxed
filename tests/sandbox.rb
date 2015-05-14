def with_do1
  yield(42)
end

with_do1 { |what| puts what }

def with_do2 &block
  block.call(42)
end

with_do2 { |what| puts what }
with_do2 do |what| puts what end

proc = proc { |what| puts what }
with_do2(&proc)
  