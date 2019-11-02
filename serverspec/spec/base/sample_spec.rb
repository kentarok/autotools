# frozen_string_literal: true

require 'spec_helper'

puts "\nRun serverspec to #{property['inventory_hostname']}"

property['group'].each do |attr|
  describe group(attr['name']) do
    it { should exist }
    it { should have_gid attr['gid'] }
  end
end

property['user'].each do |attr|
  describe user(attr['name']) do
    it { should exist }
    it { should have_uid attr['uid'] }
    it { should belong_to_group attr['group'] }
  end
end

property['service'].each do |attr|
  describe service(attr['name']) do
    attr['enabled']            ? it { should be_enabled } : it { should_not be_enabled }
    attr['state'] == 'started' ? it { should be_running } : it { should_not be_running }
  end
end
