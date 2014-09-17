module ContentGenerator
  def sof_content_processor
    @user_id = request["user_id"]

    #/users/{ids}
    @user_info = self.class.get("http://api.stackexchange.com/2.2/users/#{@user_id}?order=desc&sort=reputation&site=stackoverflow")

    #/users/{ids}/answers
    @user_answer = self.class.get("http://api.stackexchange.com/2.2/users/#{@user_id}/answers?order=desc&sort=activity&site=stackoverflow")
    @user_answer_count = @user_answer["items"].count
    @answer_collect = Array.new()
    if @user_answer["items"] != nil
      @user_answer["items"].each { |item| @answer_collect << "http://stackoverflow.com/q/#{item["answer_id"]}" }
    else
      @user_answer["items"] = nil
    end

    #/users/{ids}/questions
    @user_question = self.class.get("http://api.stackexchange.com/2.2/users/#{@user_id}/questions?order=desc&sort=activity&site=stackoverflow")
    @user_question_count = @user_question["items"].count
    @question_collect = Array.new()
    if @user_question["items"] != nil
      @user_question["items"].each { |item| @question_collect << "http://stackoverflow.com/q/#{item["question_id"]}" }
    else
      @user_question["items"] = nil
    end

    #/users/{id}/network-activity
    @user_network_activity = self.class.get("http://api.stackexchange.com/2.2/users/#{@user_info["items"][0]["account_id"]}/network-activity")
    @user_network_activity_count = @user_network_activity["items"].count

    #/users/{ids}/reputation-history
    @user_reputation_history = self.class.get("http://api.stackexchange.com/2.2/users/#{@user_id}/reputation-history?site=stackoverflow")
    @user_reputation_array = Array.new()
    if @user_reputation_history["items"] != nil
      @user_reputation_history["items"].each { |repu| @user_reputation_array << repu["reputation_change"] }
    else
      @user_reputation_history["items"] = nil
    end

    #/users/{ids}/tags
    @user_tags = self.class.get("http://api.stackexchange.com/2.2/users/#{@user_id}/tags?order=desc&sort=popular&site=stackoverflow")
    @user_tags_info_hash = Hash.new()
    if @user_tags["items"] != nil
      @user_tags["items"].each { |tag| @user_tags_info_hash["#{tag["name"]}"] = tag["count"] }
    else
      @user_tags["items"] = nil
    end

    #/users/{ids}/associated
    @user_association = self.class.get("http://api.stackexchange.com/2.2/users/#{@user_info["items"][0]["account_id"]}/associated")
    @user_association_hash = Hash.new()
    if @user_association["items"] != nil
      @user_association["items"].each { |asso| @user_association_hash["#{asso["site_name"]}"] = asso["reputation"] }
    else
      @user_association["items"] = nil
    end

    #/users/{ids}/timeline
    @user_timeline = self.class.get("http://api.stackexchange.com/2.2/users/#{@user_id}/timeline?site=stackoverflow")
    @user_timeline_count = @user_timeline["items"].count
  end
end