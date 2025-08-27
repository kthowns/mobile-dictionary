#!/bin/bash

set -e  # 에러 발생 시 스크립트 종료

APP_NAME="mobidic-spring"
IMAGE_NAME="pni2399/mobidic-spring:1.0"
JAR_PATH="/home/ubuntu/mobidic-0.0.1-SNAPSHOT.jar"
JAR_TARGET_DIR="./spring"

echo "📦 Stopping & Removing old container..."
docker stop $APP_NAME || true
docker rm $APP_NAME || true

echo "🧹 Removing old image..."
docker rmi $IMAGE_NAME || true

echo "📁 Copying JAR to $JAR_TARGET_DIR..."
cp $JAR_PATH $JAR_TARGET_DIR/

echo "🔨 Building Docker image..."
cd $JAR_TARGET_DIR
docker build -t $IMAGE_NAME .

echo "🚀 Pushing to Docker Hub..."
docker push $IMAGE_NAME

echo "📡 Starting with docker-compose..."
cd ..
docker compose up -d

echo "✅ Running containers:"
docker ps
