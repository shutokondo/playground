WebsocketRails::EventMap.describe do
  #「subscribeの引数にjsが何送ってきたら、どのコントローラーのアクションに紐付けるか」と書かれている
  # routes.rbのようなもの
  subscribe :client_connected, to: ChatController, with_method :connect_user
  subscribe :new_message, to: ChatController, with_method :new_message
end
