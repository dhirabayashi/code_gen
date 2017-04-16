def snake2camel(s)
    return s unless s.include?('_')

    array = s.split('_')
    array[0] + array[1..-1].map(&:capitalize).join
end

def delete_index(type)
    return type unless type.include?('[')

    type.split('[')[0] + '[]'
end

class String
    def upcase_first
        self[0].upcase + self[1..-1]
    end
end

def code_gen(app, hash)

structure = <<-EOS
public class %s {
%s
}
EOS

field = "    private %s %s;\n"
getter = <<-EOS
    public %s %s() {
        return %s;
    }
EOS
setter = <<-EOS
    public void set%s(%s %s) {
        this.%s = %s;
    }
EOS

    field_hash = {}
    hash.each do |k, v|
        field_hash[snake2camel(k)] = delete_index(v)
    end

    field_list = []
    accessor_list = []

    field_hash.each do |name, type|
        field_list << field % [type, name]
        prefix = type == 'boolean' ? 'is' : 'get'
        accessor_list << getter % [type, prefix + name.upcase_first, name]
        accessor_list << setter % [name.upcase_first, type, name, name, name]
    end

    members = field_list + accessor_list
    code = structure % [app, members.join("\n")]
    filename = "#{app}.java"
    [filename, code]
end
