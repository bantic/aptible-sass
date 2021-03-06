class App.Views.ContactEdit extends Backbone.View

  template: ->
    JST['dist/templates/edit_contact']

  events:
    'click .select-user'        : 'onSelectUser'
    'click .begin-edit-contact' : 'onEditStart'
    'keyup .contact-title'      : 'onTitleUpdate'

  defaults:
    idParam: 'approving_authority_id'
    titleParam: 'approving_authority_title'
    emailParam: 'approving_authority_email'
    nameParam: 'approving_authority_name'
    inputName: 'Approving Authority'

  initialize: (options) ->
    { @idParam, @titleParam, @emailParam, @nameParam, @inputName } = _.defaults options, @defaults
    @contacts = App.current_organization_users

    if @contacts.length is 1
      contact = @contacts.at(0)
      @model.set @idParam, contact.get('id')
      @model.set @nameParam, contact.get('name')
      @model.set @emailParam, contact.get('email')

  render: ->
    @$el.html(@template()(@renderParams()))
    @$alert = @$('.alert').hide()
    @$errorMessage = @$('.error-message')
    @onEditStart()

    @model.on "change:#{@nameParam}", @onNameChange, @
    @model.on "change:#{@titleParam}", @onTitleChange, @
    @model.on "change:#{@emailParam}", @onEmailChange, @

    @

  renderParams: ->
    {
      helpers: App.Helpers
      contacts: @contacts
      contactName: @model.get(@nameParam)
      contactTitle: @model.get(@titleParam)
      contactEmail: @model.get(@emailParam)
      contactId: @model.get(@idParam)
      inputName: @inputName
    }

  onNameChange: ->
    @$('.contact-name').text @model.get(@nameParam)

  onTitleChange: ->
    @$('.contact-title').val(@model.get(@titleParam)).attr('placeholder', "#{@model.get(@nameParam)}'s Title")

  onEmailChange: ->
    src = App.Helpers.gravatar_url @model.get(@emailParam), 48
    @$('.contact-gravatar').attr 'src', src

  onEditStart: ->
    @$el.addClass('editing')
    titleValue = $.trim @$('input.contact-title').val()
    @model.set(@titleParam, titleValue) if titleValue

  onSelectUser: (event) =>
    uid = $(event.target).data('user-id')
    contact = @contacts.get(uid)

    @model.set @nameParam, contact.get('name')
    @model.set @emailParam, contact.get('email')
    @model.set(@titleParam, '') unless @model.get(@idParam) is uid
    @model.set @idParam, uid

  onTitleUpdate: (event) =>
    val = $.trim $(event.target).val()
    @model.set @titleParam, val
