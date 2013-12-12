#! /usr/bin/env ruby

#
# This is a NewRelic agent which pushes OpenVPN information.
#

require "rubygems"
require "bundler/setup"
require "newrelic_plugin"

module NewRelicOpenvpnAgent
  class Agent < NewRelic::Plugin::Agent::Base
    agent_guid "com.kangacoders.openvpn"
    agent_version "0.0.1"
    agent_config_options :openvpn_status_path
    agent_human_labels("OpenVPN Agent") { ident }
    
    attr_reader :ident

    def poll_cycle
      [:total_users, :total_clients, :total_bytes_received, :total_bytes_sent, :average_bytes_received, :average_bytes_sent].each do |_type|
        name, unit, _output = metric(_type)
        report_metric name, unit, _output.call
      end
    end

    private

    def get_columns(_output, _c_index, _uniq = true, _total = true)
      result = _output.scan(/^([^,]+),(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}):\d+,(\d+),(\d+).+$/).map{|_x| _x[_c_index] }
      result = result.uniq if _uniq
      result = result.length if _total
      result
    end

    def metric(_type)
      metrics = {
        :total_users => ["Total/Users", "Users", lambda{get_columns(ovpn_cmd, 0) }],
        :total_clients => ["Total/Clients", "Clients", lambda{get_columns(ovpn_cmd, 1) }],
        :total_bytes_received => ["Total/Bytes/Received", "bytes", lambda{ get_columns(ovpn_cmd, 2, false, false).inject(0){|_t, _b| (_t + _b.to_i) } }],
        :total_bytes_sent => ["Total/Bytes/Sent", "bytes", lambda{ get_columns(ovpn_cmd, 3, false, false).inject(0){|_t, _b| (_t + _b.to_i) } }],
        :average_bytes_received => ["Average/Bytes/Received", "bytes", lambda{ x = get_columns(ovpn_cmd, 2, false, false); x.inject(0){|_t, _b| (_t + _b.to_i) } / x.length }],
        :average_bytes_sent => ["Average/Bytes/Sent", "bytes", lambda{ x = get_columns(ovpn_cmd, 3, false, false); x.inject(0){|_t, _b| (_t + _b.to_i) } / x.length }]
      }
      metrics[_type]
    end

    def ovpn_cmd
      `cat #{openvpn_status_path}`
    end

  end

  def self.run
    NewRelic::Plugin::Config.config.agents.keys.each do |_agent|
      NewRelic::Plugin::Setup.install_agent _agent, NewRelicOpenvpnAgent
    end

    NewRelic::Plugin::Run.setup_and_run
  end
end
