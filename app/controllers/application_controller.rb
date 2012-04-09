class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :valid_browser?, :except => :error

  # аргументи є об'єкти з якими робота ведеться як з масивами 
  # дійсна версія виглядає як "firefox 3.6+" or "firefox 3.6"
  def check_in(test_version, legal_version)
    # щось  порожнє
    return false if (test_version.nil?) || (legal_version.nil?)
    # імена відрізняються 
    return false if (test_version[1] != legal_version[1])
    # порівняння версій 
    test_version_num = 10*test_version[2].to_i + test_version[3].to_i
    legal_version_num = 10*legal_version[2].to_i + legal_version[3].to_i
    return true if (legal_version[4].blank?) && (test_version_num == legal_version_num)
    return true if (legal_version[4] == "+") && (test_version_num >= legal_version_num)
    return false
  end
  # Перевірка чи користувацький браузер є валідний 
  # Робиться припущення що є глобальна змінна BROWSERS, яка містить список імен браузерів та їх версій 
  # BROWSER = <browser set 1> ; <browser set 2> ; ...
  # де <browser set> = <browser name> < browser versions>
  # наприклад BROWSER = 'Firefox 3.6+ ; Google Chrome 5.0+'
  def valid_browser?
    logger.debug "check_browser: start"
    if (controller_name == "drivers")  && (action_name == "error")
     logger.debug "check_browser: we are on error"    
     return true
    end
    
    logger.debug "Your request is from #{request.user_agent.downcase}."

    legal_browser_sets = "#{BROWSERS}".downcase.split(';')
    legal_browser_sets.each do |legal_browser_set|
      # витягнути компоненти із (назву, номера версій) підходящого браузера
      legal_browser_parts = /(\w+)\s*(\d+).(\d+)\s*(\W?)/.match(legal_browser_set)
      logger.debug "legal_browser_parts:#{legal_browser_parts.inspect}"
      # витягуємо назву та версію користувацького браузера із запиту 
      user_regexp = Regexp.compile("(#{legal_browser_parts[1]})\\s*\/\\s*(\\d+).(\\d+)")
      user_browser_parts = user_regexp.match(request.user_agent.downcase)
      logger.debug "user_browser_parts: #{user_browser_parts.inspect}"
            
      if check_in(user_browser_parts, legal_browser_parts)      
        logger.debug "check_browser: end filter true"
        return true
      end
    end

    logger.debug "check_browser: end false"
    flash[:notice] = "Wrong browser."
    redirect_to(error_url) and return false   
  end 
end
