class Chatwork
  USERS = [
    {id: "89931124", login: "duykhanh21", cw_id: "728165"},
    {id: "", login: "NguyenHoangAnhDung", cw_id: "2002615"},
    {id: "", login: "quyenguyengoc", cw_id: "2110276"},
    {id: "", login: "Huyliver6793", cw_id: "2031140"},
    {id: "", login: "quynhqtvn", cw_id: "2031071"},
    {id: "", login: "vovanhai193", cw_id: "2031123"},
    {id: "", login: "linhnt", cw_id: "637915"},
    {id: "", login: "octoberstorm", cw_id: "637888"},
    {id: "", login: "RathanakSreang", cw_id: "1352084"},
    {id: "", login: "", cw_id: "1889879"},
    {id: "", login: "emily0604", cw_id: "1474365"}
  ]
  CW_URI = {
    host: "https://api.chatwork.com/v1/",
    port: ""
  }
  CW_TOKEN = '1bbe361446555e3ee1c6fcc2e39e92b4'
  ROOM_ID = 61743104

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
      "[info][title]New pull request created by #{picon(pr['user']['login'])}[/title]
      - Title: #{pr['title']}
      - Link: #{pr['html_url']}[/info]"
    end

    def new_comment comment, pr
      pic = []
      comment['body'].gsub(/@(\w+)/){|c| pic.push(c.gsub("@", ""))}
      if pic.empty?
        "[info][title][PR] #{pr['title']} #{to(pr['user']['login'])}[/title] #{picon(comment['user']['login'])}(commented)[code]#{comment['body']}[/code][hr] - Link: #{comment['html_url']}[/info]"
      else
        "[info][title][PR] #{pr['title']} #{to(pr['user']['login'])}[/title] #{picon(comment['user']['login'])}(commented)[code]#{comment['body']}[/code][hr] - Link: #{comment['html_url']}[hr] #{pic.map{|p| to(p)}.join()}[/info]"
      end
    end

    def send_message body
      post("rooms/#{ROOM_ID}/messages", body)
    end

    def post path, data
      url = "#{CW_URI[:host]}#{path}"
      res = RestClient.post url, {body: data}, {'X-ChatWorkToken' => CW_TOKEN}
      p res
    end
  end
end
