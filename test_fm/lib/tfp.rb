class Tfp

  def Tfp.load file_name
    _dir_current = File.dirname(file_name)

    _result_buffer = ""

    File.read(file_name).each_line{|_current_line|
      if _current_line.start_with? "#include"
        inc_name = _current_line[8, _current_line.length].strip
        _result_buffer << "\n" << load( File.join(_dir_current, inc_name) ) << "\n"
      else
        _result_buffer << _current_line
      end
    }
    _result_buffer
  end

  def Tfp.load_with_script file_name
    _dir_current = File.dirname(file_name)

    _result_buffer = ""
    _script_tmp = nil

    File.read(file_name).each_line{|_current_line|
      if _script_tmp != nil
        if _current_line.strip == "#}"
          _result_script = eval( _script_tmp )
          _result_buffer << _result_script if _result_script.is_a?(String)
          _script_tmp = nil
        else
          _script_tmp << _current_line
        end

        next
      end

      if _current_line.start_with? "#include"
        inc_name = _current_line[8, _current_line.length].strip
        _result_buffer << load( File.join(_dir_current, inc_name) )
      elsif _current_line.start_with? "#\{"
        _script_tmp = _current_line[2, _current_line.length]
      else
        _result_buffer << "#{_current_line.gsub(/\n/,'')}"
        #_result_buffer << " # #{file_name}:#{line_n}"
        _result_buffer << "\n"
      end
    }
#    puts _result_buffer
    _result_buffer
  end

end
