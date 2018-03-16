module UsersHelper
     # date型を受け取って、年齢を返す。
    def figure_age(birthday)
        date_format = "%Y%m%d"
        (Date.today.strftime(date_format).to_i - birthday.strftime(date_format).to_i) / 10000
    end
end
