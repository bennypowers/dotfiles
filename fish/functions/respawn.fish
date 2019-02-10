function respawn
  rm -rf ~/web/magento/htdocs/*
	docker-machine rm magento -y 
  docker-machine create -d virtualbox magento
  eval (docker-machine env magento)

	set machine_ip (docker-machine ip magento)
  echo "$machine_ip magento.dev" >> ~/Library/Gas\ Mask/Local/Docker\ Machines.hst

  docker-compose up -d
  docker exec -it web setup_magento
end
