# form supports your everyday form needs, updating values etc.
class Form extends Backbone.View
  
  _events:  
    'change input,textarea,select' : 'changed'
    'click .done' : 'done'
    'click .save' : 'save'
    'click .delete' : 'delete'
    'click .cancel' : 'cancel'
    'click label' : 'label_click'
    'submit form' : 'nosubmit'
    
  initialize: (options) ->
    @events = _.extend({}, @_events, @events)
    @init()
    this
  
  # overriden by superclasses
  init: =>
      
  render: (@template, @data={}, @model) ->
    
    # expose all the model attributes to the template
    if @model 
      @data.model = @model  
      @data = _.extend({}, @data, @model.attributes)
    
    @pre_render =>
      $(@el).html tmpl[@template](@data)
      @post_render()
    this
  
  # these may get overriden, or not
  pre_render: (callback) ->
    callback()
  
  post_render: ->
  
  
  #
  #  handles changes from the form inputs
  #
  changed: (e) ->
    e.stopPropagation()  
    input = $ e.target
    val = input.val()
  
    # deals with checkbox 0 values
    if input.attr('type') is 'checkbox'
      if input.is ':checked'
        val = 1
      else
        val = 0
    
    attribute = input.attr('name')
    @model.set attribute, val.toString()
    @trigger 'changed', e, @
    
  # 
  #  saves a new model
  #
  save: ->
    @collection.add(@model)
  
  #
  # triggers saved event
  #
  done: (silent=false) =>
    @trigger 'saved', @model unless silent and !_.isObject(silent)
    @cancel()
  
  #
  #  unrenders the view
  #
  cancel: (silent=false) =>
    @trigger 'canceled' unless silent
    $(@el).empty()
  
  #
  #  removes from the collection, controller should be listening for this!
  #
  delete: =>
    @done true
    @collection.remove @model
  
  #
  # clicking on a label clicks on an adjoining element
  #
  label_click: (e) ->
    input = $ e.target
    input.next().click()
    input.prev().click()
    
  #
  # prevents any form tags from being submited like we used to back in the good ol' days
  #  
  nosubmit: ->
    false  
  