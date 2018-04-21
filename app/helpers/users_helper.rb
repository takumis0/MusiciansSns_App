module UsersHelper
     # date型を受け取って、年齢を返す。
    def figure_age(birthday)
        date_format = "%Y%m%d"
        (Date.today.strftime(date_format).to_i - birthday.strftime(date_format).to_i) / 10000
    end
    
    def make_yt_url(id)
      iframe = content_tag(
        :iframe,
        '', # empty body
        id: 'youtube_iframe',
        allow: "autoplay; encrypted-media",
        src: "https://www.youtube.com/embed/#{id}",
        frameborder: 0,
        allowfullscreen: true
      )
      content_tag(:div, iframe, id: 'youtube_block')
    end
    
    def make_video_id(url)
      devided_url = url.slice(/watch[\/?][\/v][\/=]([-\w]{11})/)
      v_id = devided_url.slice(8, 18)
    end
end
