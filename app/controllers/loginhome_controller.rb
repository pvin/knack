class LoginhomeController < ApplicationController

  include HTTParty
  base_uri "http://api.stackoverflow.com/1.1"

  def getoption

  end

  def sof_consumer
    @firstname = request["firstName"]
    @response = self.class.get("/users/#{@firstname}")
    test = @response["users"][0]["display_name"]
    respond_to do |format|
      format.html
      format.pdf do
        pdf = Prawn::Document.new

        logopath = "public/pie-chart-1.png"
        pdf.image logopath, :width => 197, :height => 120

        pdf.fill_color "0066FF"
        pdf.font_size 42
        pdf.text_box "Knack Reports", :align => :right

        pdf.move_down 20
        pdf.font_size 14
        pdf.text "Below generated report for stack overflow user #{@response["users"][0]["display_name"]}"

        pdf.move_down 20
        to_show = [["UserId", "#{@response["users"][0]["user_id"]}"],
                   ["Desplay Name", "#{@response["users"][0]["display_name"]}"],
                   ["Reputation", "#{@response["users"][0]["reputation"]}"],
                   ["Location", "#{@response["users"][0]["location"]}"],
                   ["Question Count", "#{@response["users"][0]["question_count"]}"],
                   ["Answer Count", "#{@response["users"][0]["answer_count"]}"],
                   ["View Count", "#{@response["users"][0]["view_count"]}"],
                   ["Up Vote Count", "#{@response["users"][0]["up_vote_count"]}"],
                   ["Down Vote Count", "#{@response["users"][0]["down_vote_count"]}"],
                   ["User Gold Badge", "#{@response["users"][0]["badge_counts"]["gold"]}"],
                   ["User Silver Badge", "#{@response["users"][0]["badge_counts"]["silver"]}"],
                   ["User Bronze Badge", "#{@response["users"][0]["badge_counts"]["bronze"]}"]
        ]
        pdf.table(to_show) do |table|
          table.rows(1..2).width = 270
        end
        send_data pdf.render, type: "application/pdf", disposition: "inline"
      end
    end

  end

  def git_consumer
    @name = request["gitname"]
    @hash_values=Github.repos.list user: "#{@name}", repo:'-Contactform'
    puts '============================'
    puts     @hash_values.length
    puts '============================'
  end

  def blog_consumer
    @blog_id = request["blogid"]
    puts '++++++++++'
    puts @blog_id
    puts '++++++++++'
    response = HTTParty.get('https://www.googleapis.com/blogger/v3/blogs/3891960319537892971/posts?key=AIzaSyCmyA7TS_PMW-E42L4Fg75Lz5RZpaSpA5A')
    puts '-----------------'
    puts response.body
    puts '-----------------'

  end

end
