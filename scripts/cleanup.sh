#!/bin/bash
set -e

STACK_NAME="$1"

echo "🧹 Iniciando cleanup da stack $STACK_NAME..."

# Remover stack
if docker stack ls --format '{{.Name}}' | grep -q "^${STACK_NAME}$"; then
  echo ">> Removendo stack $STACK_NAME"
  docker stack rm $STACK_NAME
  # aguarda serviços sumirem
  sleep 10
else
  echo ">> Stack $STACK_NAME não encontrada"
fi

# Remover serviços órfãos
echo ">> Removendo serviços órfãos..."
for svc in $(docker service ls --format '{{.Name}}'); do
  if [[ $svc == ${STACK_NAME}_* ]]; then
    echo "   - Removendo serviço órfão $svc"
    docker service rm "$svc" || true
  fi
done

# Remover containers órfãos
echo ">> Removendo containers órfãos..."
docker container prune -f

# Remover volumes usados pela stack
echo ">> Removendo volumes da stack..."
for vol in vault; do
  if docker volume ls --format '{{.Name}}' | grep -q "^${vol}$"; then
    echo "   - Removendo volume $vol"
    docker volume rm "$vol" || true
  fi
done


echo "✅ Cleanup concluído!"
