class Chatwork
  # List all users in Chatwork notification room
  USERS = [
    {
      login: "dummy", # Github login username
      cw_id: "12345" # Chatwork ID
    }, {
      #...
    }
  ]

  class << self
    def picon user
      usr = USERS.select{|u| u[:login] == user}.first
      if usr.blank?
        ""
      else
        "[picon:#{usr[:cw_id]}]"
      end
    end

    def to user
      usr = USERS.select{|u| u[:login] == user}.first
      if usr.blank?
        ""
      else
        "[To:#{usr[:cw_id]}]"
      end
    end

    def new_pull pr
      "[info][title][NEW] Pull request created by #{picon(pr['user']['login'])}[/title] - Title: #{pr['title']} - Link: #{pr['html_url']}[/info]"
    end

    def new_comment comment, pr
      pic = []
      comment['body'].gsub(/@(\w+)/){|c| pic.push(c.gsub("@", ""))}
      if pic.empty?
        "[info][title][PR] #{pr['title']}[/title] #{picon(comment['user']['login'])}(commented)[code]#{comment['body']}[/code][hr]#{to(pr['user']['login'])} Link: #{comment['html_url']}[/info]"
      else
        "[info][title][PR] #{pr['title']}[/title] #{picon(comment['user']['login'])}(commented)[code]#{comment['body']}[/code][hr]#{to(pr['user']['login'])} Link: #{comment['html_url']}[hr] #{pic.map{|p| to(p)}.join()}[/info]"
      end
    end

    def send_message body
      post("rooms/#{Settings.ROOM_ID}/messages", body)
    end

    def post path, data
      url = "#{Settings.CW_URI[:host]}#{path}"
      res = RestClient.post url, {body: data}, {'X-ChatWorkToken' => Settings.CW_TOKEN}
      p res
    end
  end
end
