Puppet::Functions.create_function(:'pax::repo_helpers::yumrepo_params') do
  dispatch :yumrepo_params do
    param 'Hash', :input_params
  end

  # In addition to the parameters to the underlying yumrepo resource,
  #  * enable_baseurl
  #  * enable_mirrorlist
  # may also be specified. Remove these, and if they are present and false,
  # set their corresponding yumrepo parameter to 'absent'.  
  def :yumrepo_params(input_params)
    output_params = {}
    input_params.each |key, value| do
      case key
      when "enable_baseurl"
      when "enable_mirrorlist"
        next
      when "baseurl"
        if input_params.has_key?('enable_baseurl') && input_params['enable_baseurl'] == false
          output_params[key] = 'absent'
        else
          output_params[key] = value
        end
      when "mirrorlist"
        if input_params.has_key?('enable_mirrorlist') && input_params['enable_mirrorlist'] == false
          output_params[key] = 'absent'
        else
          output_params[key] = value
        end
      else
        output_params[key] = value
      end
    end
    output_params
  end
end
