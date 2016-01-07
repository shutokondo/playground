# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class @ChatClass
  constructor: (url, useWebSocket) ->
    # これがソケットのディスパッチャー
    group_id = $('#group_id').text()
    @dispatcher = new WebSocketRails(url, useWebsocket)
    @channel = @dispatcher.subscribe(group_id)
    console.log(url)
    # イベントを監視
    @bindEvents()

  bindEvents: () =>
    # 送信ボタンが押されたらサーバーへメッセージを送信
    $('send').on('click'), @sendMessage

    # サーバーからnew_messageを受け取ったらreceiveMessageを実行
    @dispatcher.bind 'new_message', @recieveMessage
    @channel.bind 'new_message', @receiveMessage

  sendMessage: (event) =>
    # サーバ側にsend_messageのイベントを送信
    # オブジェクトでデータを指定
    user_name = $('#username').text()
    msg_body = $('#msgbody').val()
    group_id = $('#group_id').text()
    @dispatcher.trigger 'new_message', { name: user_name, body: msg_body, group_id: group_id }
    $('#msgbody').val('')

  reveiveMessage: (message) =>
    console.log(message)
    # 受け取ったデータをappend
    $('#chat').append "#{message.name}「#{message.body}」<br/>"

$ ->
  window.chatClass = new ChatClass($('#chat').data('uri'), true)