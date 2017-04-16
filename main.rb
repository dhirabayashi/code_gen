file = ARGV[0]
target = ARGV[1]

unless file and target then
    $stderr.puts 'error : invalid parameter'
    exit
end

app = nil
fields = {}
File.foreach(file) do |line|
    next if line.start_with?('#')
    app = line.split[1] if line.start_with?('M')
    
    if line.start_with?('F') then
        dummy, name, type = line.split.map(&:chomp)
        fields[name] = type
    end

    break if line.start_with?('E')
end

require "./template/#{target}.rb"

filename, code = code_gen(app, fields)

File.open("out/#{filename}", 'w') do |file|
    file.print(code)
end
