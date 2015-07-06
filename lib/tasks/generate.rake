task :g do
  args = ''
  if ARGV.size > 1
    for i in 1..(ARGV.size - 1)
      args << " " << ARGV[i]
    end
  end
  ruby "./lib/generator.rb #{args}"
end