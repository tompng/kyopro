require 'open3'
file = ARGV[0]
testcase = ARGV[1]
raise 'ARGV[1] should be filename' unless File.exist? file
data = File.read(file)
samples = data.split(/# ?INPUT ?/).drop(1)
testcases = samples.each.with_index(1).to_h do |sample, num|
  name, io = sample.split(/\n/, 2)
  [name.empty? ? num.to_s : name, io.split(/# ?OUTPUT[^\n]*\n/, 2)]
end

testcases = testcases.slice testcase if testcase

testcases.each do |name, (input, output)|
  puts "CASE #{name}"
  o, e = Open3.capture3('RUBY_THREAD_VM_STACK_SIZE=16000000 ruby', file, stdin_data: input)
  puts "\e[31m#{e}\e[m" unless e.empty?
  if o.strip == output.strip
    puts "\e[32mOK\e[m"
  else
    puts "\e[31mERR\e[m"
    puts o
  end
  puts
end
