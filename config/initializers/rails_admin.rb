RailsAdmin.config do |config|
  ### Popular gems integration

  # config.authorize_with do |controller|
  #   unless current_frontend_user.try(:is_admin?)
  #     flash[:error] = 'У Вас недостаточно прав'
  #     redirect_to '/'
  #   end
  # end

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :frontend_user
  end
  config.current_user_method(&:current_frontend_user)

  config.main_app_name = ['Админка', 'управляй:)']

  config.actions do
    dashboard
    # do
    #   ga_key 'AIzaSyBzeEl70fUpA7Wf-qdnjHTlUP-CmvLXldY'
    #   ga_chart_id 'ga:YYYYYYYYY'
    #   ga_start_date '60daysAgo'
    #   ga_end_date '30daysAgo'
    #   ga_metrics 'ga:sessions,ga:pageviews'
    #   # admin_notices 'AdminNotice'
    # end
    index # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
    dropzone do
      only %w(Pоst)
    end
    nested_set do
      visible do
        %w( Category ).include? bindings[:abstract_model].model_name
      end
    end

  end

  config.model 'Ckeditor::Picture' do
    visible true
    label 'Картинка'
    label_plural 'Картинки'
    include_all_fields
    exclude_fields :type, :created_at, :updated_at
  end

  config.model 'Category' do
    object_label_method :title
    label 'Категория'
    label_plural 'Категории'
    navigation_icon 'icon-folder-open'

    field :has_nesting do
      visible false
    end

    field :parent do
      visible false
    end

    field :children do
      visible false
    end

    list do
      field :title
    end

    include_fields :title, :parent, :children
  end


  config.model 'Impression' do
    visible false
  end

  config.model 'Role' do
    parent 'User'
    label 'Роль'
    label_plural 'Роли'
    navigation_icon 'icon-folder-open'
    include_all_fields
    exclude_fields :created_at, :updated_at
  end

end
