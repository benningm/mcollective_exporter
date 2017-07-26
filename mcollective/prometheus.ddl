metadata :name => "prometheus",
         :description => "agent to scrape prometheus targets via mcollective",
         :author => "Markus Benning <ich@markusbenning.de",
         :license => "ASL2.0",
         :version => "1.0.0",
         :url => "https://markusbenning.de",
         :timeout => 20

requires :mcollective => "2.2.1"

action 'list', :description => 'list targets on host' do
    display :always

    output :targets,
        :description => 'Available targets to scrap on host',
        :display_as  => 'Targets',
        :default     => []
end

action 'get', :description => 'retrieve a promethus target' do
    display :always

    input :target,
          :prompt      => "Target",
          :description => "The target to retrieve",
          :type        => :string,
          :validation  => '^[a-zA-Z\-_\d]+$',
          :optional    => false,
          :maxlength   => 50

    output :content,
        :description => 'The document body',
        :display_as  => 'Content',
        :default     => ""

    output :code,
        :description => 'HTTP status code',
        :display_as  => 'Code',
        :default     => 500

    output :message,
        :description => 'HTTP status message',
        :display_as  => 'Message',
        :default     => "MCollective Agent plugin error"

end
