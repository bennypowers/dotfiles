function occ -d "Execute occ commands in the running nextcloud container"
  podman exec --user www-data -it nextcloud-aio-nextcloud php occ $argv
end
