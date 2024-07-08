# 定义目录路径
DIRDG1 := /root/oradata/DG11
DIRDG2 := /root/oradata/DG21

# 目标
prepare_dir: check_dir_primary check_dir_standby

# 检查目录是否存在
check_dir_primary:
	@if [ ! -d "$(DIRDG1)" ]; then \
        echo "Directory $(DIRDG1) does not exist. Creating..."; \
        mkdir -p $(DIRDG1); \
		chmod 777 $(DIRDG1); \
    else \
        echo "Directory $(DIRDG1) exists. Clearing..."; \
        rm -rf $(DIRDG1)/*; \
    fi
check_dir_standby:
	@if [ ! -d "$(DIRDG2)" ]; then \
        echo "Directory $(DIRDG2) does not exist. Creating..."; \
        mkdir -p $(DIRDG2); \
		chmod 777 $(DIRDG2); \
    else \
        echo "Directory $(DIRDG2) exists. Clearing..."; \
        rm -rf $(DIRDG2)/*; \
    fi

docker_up:
	docker compose up -d
	
docker_configure_dg:
	docker exec -u oracle -itd DG11 /opt/oracle/runOracle.sh
	docker exec -u oracle -itd DG21 /opt/oracle/runOracle.sh

docker_watch:
	docker exec -u oracle -it DG11 tail -f /opt/oracle/diag/rdbms/*/*/trace/alert*.log


.PHONY: prepare_dir