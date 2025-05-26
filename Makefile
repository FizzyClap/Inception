# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: roespici <roespici@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/04/14 05:25:01 by roespici          #+#    #+#              #
#    Updated: 2025/05/07 16:15:54 by roespici         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

include ./srcs/.env
export

DOCKER_COMPOSE = docker compose
DOMAIN_NAME = roespici.42.fr
DOCKER_COMPOSE_FILE = srcs/docker-compose.yml

# Couleurs
RED = \\033[31m
GREEN = \\033[32m
YELLOW = \\033[33m
NC = \\033[0m # No Color

# Cibles principales
all: build up

build:
	sudo systemctl restart docker
	@echo -e "$(YELLOW)🔧 Building Docker images...$(NC)"
	@mkdir $(VOLUME_MARIA) $(VOLUME_WORDPRESS)
	@chmod 777 $(VOLUME_MARIA) $(VOLUME_WORDPRESS)
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) build
	@echo -e "$(GREEN)✅ Docker images built successfully!$(NC)"

up: init-volumes
	@echo -e "$(YELLOW)🚀 Starting Docker containers...$(NC)"
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) up -d
	@echo -e "$(GREEN)🌐 Access your site at: http://$(DOMAIN_NAME)$(NC)"

down:
	@echo -e "$(YELLOW)🛑 Stopping Docker containers...$(NC)"
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) down
	@echo -e "$(GREEN)✅ Containers stopped successfully!$(NC)"

restart: down up

clean:
	@echo -e "$(YELLOW)🧹 Cleaning Docker environment (containers + volumes)...$(NC)"
	@sudo rm -rf $(VOLUME_MARIA) $(VOLUME_WORDPRESS)
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) down -v --rmi local
	@echo -e "$(GREEN)✅ Clean done.$(NC)"

fclean: clean
	@echo -e "$(YELLOW)🔥 Full clean (dangling volumes, images, networks)...$(NC)"
	@docker system prune -af --volumes
	@echo -e "$(GREEN)✅ Docker system fully cleaned.$(NC)"

re: fclean build up

init-volumes:
	@echo -e "$(YELLOW)📁 Checking required local directories...$(NC)"
	@mkdir -p ~/inception/data/html/wordpress
	@mkdir -p ~/inception/data/mariadb
	@echo -e "$(GREEN)✅ Local bind mount directories ready.$(NC)"

logs:
	@echo -e "$(YELLOW)📜 Showing logs... (Ctrl+C to quit)$(NC)"
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) logs -f

shell-wordpress:
	@echo -e "$(YELLOW)🔧 Accessing WordPress container shell...$(NC)"
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) exec wordpress /bin/sh

shell-mariadb:
	@echo -e "$(YELLOW)🔧 Accessing MariaDB container shell...$(NC)"
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) exec mariadb /bin/sh

shell-nginx:
	@echo -e "$(YELLOW)🔧 Accessing Nginx container shell...$(NC)"
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) exec nginx /bin/sh

help:
	@echo -e "$(YELLOW)🛠️ Available commands:$(NC)"
	@echo "  make build           - Build Docker images"
	@echo "  make up              - Start Docker containers"
	@echo "  make down            - Stop Docker containers"
	@echo "  make restart         - Restart Docker containers"
	@echo "  make clean           - Clean containers and volumes"
	@echo "  make fclean          - Full cleanup (containers, images, volumes, networks)"
	@echo "  make re              - Full rebuild and restart"
	@echo "  make logs            - Show logs of running containers"
	@echo "  make shell-wordpress - Access WordPress container shell"
	@echo "  make shell-mariadb   - Access MariaDB container shell"
	@echo "  make shell-nginx     - Access Nginx container shell"
	@echo "  make help            - Show this help message"

.PHONY: all build up down restart clean fclean re logs shell-wordpress shell-mariadb shell-nginx help
