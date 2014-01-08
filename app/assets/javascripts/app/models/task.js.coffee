class App.Task extends Spine.Model
  @configure 'Task', 'name', 'status', 'created_at', 'priority'
  @extend Spine.Model.Ajax
  @url: '/api/tasks'