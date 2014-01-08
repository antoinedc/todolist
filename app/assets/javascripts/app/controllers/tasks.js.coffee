$ = Spine.$
Task = App.Task
User = App.User

class Index extends Spine.Controller

  events:
    'click .submit_new_task':    'create'
    'change .task input':    'update'
    'click [data-type=destroy]': 'destroy'
    'click .logout': 'logout'

  constructor: ->
    super
    Task.bind 'refresh change', @render
    if @get_token()
      User.fetch()
      Task.deleteAll()
      Task.fetch()
    
  get_token: ->
    return window.localStorage.getItem('todolist:token')

  render: =>
    desc = (a,b)-> a.priority < b.priority
    asc = (a,b)-> a.priority > b.priority

    user = User.first()
    tasks = Task.all().sort(desc)

    @html @view('tasks/index')(tasks: tasks, user: user)
    
  create: ->
    name = $.trim $('#new_task_name').val()
    priority = parseInt $.trim $('#new_task_priority').val()
    return alert('You need to specify a name.') unless name
    priority = 0 unless priority
    task = new Task
    task.name = name
    task.priority = priority
    task.status = false
    task.save()
    
  destroy: (e) ->
    task_id = $(e.target).parents('[data-id]').data('id')
    task = Task.find(task_id)
    task.destroy() if confirm('Sure?')

  update: (e)->
    $el = $(e.target).parents('[data-id]')
    task_id = $el.data('id')
    task = Task.find(task_id)
    name = $.trim $el.children('.task_name').val()
    priority = parseInt $.trim $el.children('.task_priority').val()
    status = $el.children('.task_status').is(':checked')
    return alert('You need to specify a name.') unless name
    priority = 0 unless priority
    task.name = name
    task.priority = priority
    task.status = status
    task.save()
  
  logout: (e)->
    window.localStorage.removeItem('todolist:token')
    jQuery.ajaxSetup {headers:{"Authorization": ""}}
    @html ''
    @navigate('/authenticate')

class App.Tasks extends Spine.Stack
  controllers:
    index: Index
    
  routes:
    '/tasks': 'index'
    
  default: 'index'
  className: 'stack tasks'
