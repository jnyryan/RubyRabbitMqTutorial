#Ruby RabbitMq Tutorial

My first Ruby and AMQP project.
Simply put it pushed to a local RabbitMq-Server and pops from same

##Ubuntu Setup

	sudo apt-get install build-essential -y
	sudo apt-get install ruby rubygems ruby1.8-dev libzlib-ruby libyaml-ruby libdrb-ruby liberb-ruby rdoc zlib1g-dev libopenssl-ruby -y
	sudo apt-get install ruby-rspec-core -y
    
    sudo gem install json    
	sudo gem install mq
    sudo gem install eventmachine
    sudo gem install amqp
    sudo gem install rspec
    sudo gem install rspec-core
    sudo gem install rspec-mocks
    sudo gem install rspec-expectations
    sudo gem install activesupport 

##Windows 7 Setup
    Right now there is an error in eventmachine than prevents this working on Windows7, however once resolved it should work.
	   https://github.com/eventmachine/eventmachine/issues/319
     
    Run RubyInstaller from http://rubyinstaller.org/downloads
    gem install mq
    gem install eventmachine --pre
    gem install amqp --pre

    sudo gem install json    
    sudo gem install mq
    sudo gem install eventmachine
    sudo gem install amqp
    sudo gem install rspec
    sudo gem install rspec-core
    sudo gem install rspec-mocks
    sudo gem install rspec-expectations
    sudo gem install activesupport 

##Running the tests:
    rake
      or
    rspec spec --format nested
