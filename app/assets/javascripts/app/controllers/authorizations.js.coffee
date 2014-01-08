$ = Spine.$
User = App.User
Task = App.Task

class Index extends Spine.Controller

  events:
    'click .login': 'login'
    'click .register': 'register'

  constructor: ->
    super
    @active @render

  render: =>
    token = @get_token()
    if token
      @set_auth_header()
      @navigate('/tasks')
    else    
      @html @view('authorizations/index')

  login: =>
    username = $('#login_username').val()
    password = $('#login_password').val()
    return alert('All fields are mandatory.') if !username or !password
    User.login(username, password, (res)=>
      code = res.code
      if code > 0
        @html ''
        @set_token(res.token)
        @set_auth_header()
        User.fetch()
        Task.fetch()
      else
        alert(res.message)
    )

  register: ->
    username = $('#register_username').val()
    password = $('#register_password').val()
    password_confirmation = $('#register_password_confirmation').val()
    return alert('All fields are mandatory.') if !username or !password or !password_confirmation
    return alert('Passwords mismatch') if password != password_confirmation
    params = {
      username: username,
      password: password,
      password_confirmation: password_confirmation
    }
    User.register(params, (res)=>
      code = res.code
      if code > 0
        @html ''
        @set_token(res.token)
        @set_auth_header()
        User.fetch()
        Task.fetch()
      else
        alert(res.message)
    )

  set_token: (token)->
    window.localStorage.setItem('todolist:token', token)

  get_token: ->
    return window.localStorage.getItem('todolist:token')

  set_auth_header: (token)=>
    jQuery.ajaxSetup {headers:{"Authorization": "Token " + @get_token()}}

class App.Authorizations extends Spine.Stack
  controllers:
    index: Index
    
  routes:
    '/authenticate': 'index'
  
  default: 'index'
  className: 'stack authorizations'
