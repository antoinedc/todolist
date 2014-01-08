$ = Spine.$
User = App.User

class Me extends Spine.Controller
  
  constructor: ->
    super
    User.fetch()

class App.Users extends Spine.Stack
  controllers:
    me:  Me
    
  routes:
    '/users/me': 'me'
    
  default: 'me'
  className: 'stack users'