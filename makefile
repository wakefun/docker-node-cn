### make REGISTRY=你的registry ###

# 镜像名称
IMAGE_NAME = node-cn
# 私有源地址
REGISTRY ?= docker.io/wakefun

# 获取所有需要构建的版本
VERSIONS = $(shell find . -type d -regex "./[0-9]*" -exec basename {} \;)
# Find the maximum version number
MAX_VERSION = $(shell echo $(VERSIONS) | tr " " "\n" | sort -nr | head -n 1)

.PHONY: all $(VERSIONS) latest

all: $(VERSIONS) latest

$(VERSIONS):
	docker build -t $(REGISTRY)/$(IMAGE_NAME):$@ -f ./$@/Dockerfile .
	docker push $(REGISTRY)/$(IMAGE_NAME):$@

latest: $(MAX_VERSION)
	docker tag $(REGISTRY)/$(IMAGE_NAME):$(MAX_VERSION) $(REGISTRY)/$(IMAGE_NAME):latest
	docker push $(REGISTRY)/$(IMAGE_NAME):latest
