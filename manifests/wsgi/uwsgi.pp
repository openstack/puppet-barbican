#
# Copyright 2021 Thomas Goirand <zigo@debian.org>
#
# Author: Thomas Goirand <zigo@debian.org>
#
# == Class: barbican::wsgi::uwsgi
#
# Configure the UWSGI service for Barbican.
#
# == Parameters
#
# [*processes*]
#   (Optional) Number of processes.
#   Defaults to $facts['os_workers'].
#
# [*threads*]
#   (Optional) Number of threads.
#   Defaults to 32.
#
# [*listen_queue_size*]
#   (Optional) Socket listen queue size.
#   Defaults to 100
#
class barbican::wsgi::uwsgi (
  $processes         = $facts['os_workers'],
  $threads           = 32,
  $listen_queue_size = 100,
){

  include barbican::deps

  if $facts['os']['name'] != 'Debian'{
    warning('This class is only valid for Debian, as other operating systems are not using uwsgi by default.')
  }

  barbican_api_uwsgi_config {
    'uwsgi/processes': value => $processes;
    'uwsgi/threads':   value => $threads;
    'uwsgi/listen':    value => $listen_queue_size;
  }
}
