require 'redmine'

require_dependency 'time_tracker_hooks'

Redmine::Plugin.register :redmine_time_tracker do
  name 'Redmine Time Tracker plugin'
  author 'Jérémie Delaitre'
  description 'This is a plugin to track time in Redmine'
  version '0.5-dev'

  requires_redmine :version_or_higher => '1.1.0'

  settings :default => { 'refresh_rate' => '60', 'status_transitions' => {} }, :partial => 'settings/time_tracker'

  project_module :time_tracker_plugin do
    permission :view_others_time_trackers, :time_trackers => :index
    permission :delete_others_time_trackers, :time_trackers => :delete


    permission :use_time_tracker, {:time_trackers =>
        [:start,:resume,:suspend,:stop,:render_menu,:current,:apply_status_transition]
    }

    permission :manage_time_trackers_status_transition, {:time_trackers =>
        [:add_status_transition,:delete_status_transition]
    }
  end

  menu :account_menu, :time_tracker_menu, '',
    {
    :caption => '',
    :html => { :id => 'time-tracker-menu' },
    :first => true,
    :param => :project_id,
    :if => Proc.new {
      User.current.logged? and User.current.allowed_to?({:controller => 'time_trackers', :action => 'render_menu'},nil, :global => true)
    }
  }
  
end
