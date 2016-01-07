class ChatController < ApplicationController

  #websocketサーバが最初に立ち上がった時に実行される
  def initialize_session
    logger.info("initialize chat controller")
    @redis = Redis.new(:host => "127.0.0.1", :port => 6379)
    controller_store[:redis] = @redis
  end

  #最初にjsから3001番にコネクションを張りにきたときに実行される
  #チャットのログをサーバ側に保存していればここでババーっと送れる
  def connect_user
    logger.debug("connected user")
    gid = session[:group_id]
    talks = controller_store[:redis].lrange gid, 0, 100
    talks.each do |message|
      msg = ActiveSupport::HashWithIndifferentAccess.new(eval(message))
      send_message :new_message, obj
    end
  end

  def new_message
    # logger.debug("Call new_message : #{message}")
    gid = message[:group_id]
    message[:time] = Time.now.strftime("%H時%M分").to_s
    
    controller_store[:redis].rpush gid, message
  end
end
