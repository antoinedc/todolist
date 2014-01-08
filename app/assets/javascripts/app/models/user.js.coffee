Task = App.Task
User = App.User

class App.User extends Spine.Model
  @configure 'User', 'username', 'api_key'
  @extend Spine.Model.Ajax
  @url: '/api/users/me'

  @login: (username, password, cb)=>
  	url = '/api/users/login'
  	params = {
  		username: username,
  		password: password
  	}
  	$.post url, params, (data)=>
  		res = data
  		if data.code > 0
  			@api_key = data.token
  		Task.deleteAll()
  		User.deleteAll()
  		if cb then cb(res) else console.log('Need a callback function to get the token')

  @register: (params, cb)=>
  	url = '/api/users'
  	$.post url, params, (data)=>
  		res = data
  		if data.code > 0
  			@api_key = data.token
  		Task.deleteAll()
  		User.deleteAll()
  		if cb then cb(res) else console.log('Need a callback function to get the token')