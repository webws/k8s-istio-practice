#设置变量 GATEWAY_UR=L 192.168.31.180:32468
# GATEWAY_URL=192.168.31.180:30080
# GATEWAY_URL=172.16.0.105:30477
GATEWAY_URL=172.16.0.105:32414
# 安装 istio
install-istio:
	curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.17.2 sh - && \
	@sudo cp ./istio-1.17.2/bin/istioctl /usr/local/bin/ && \
    istioctl install --set profile=demo
# 添加一个命名空间标签，部署应用程序时自动注入Envoy sidecar代理
label-namespace:
	kubectl label namespace default istio-injection=enabled
# 部署bookinfo应用
install-bookinfo:
	kubectl apply -f ./bookinfo.yaml 
# 部署bookinfo应用的网关
install-bookinfo-gateway:
	kubectl apply -f ./bookinfo-gateway.yaml
# 部署 检测工具
install-telemetry-addons:
	kubectl apply -f ./telemetry-addons 
# 查看kiali 进度 rollout
show-rollout:
	kubectl rollout status deployment/kiali -n istio-system
# 批量提交测试 http GATEWAY_URL请求, 使监控采样生效,读取Gateway的IP地址	
#q:怎么读取Gateway的IP地址
#A:通过kubectl get svc istio-ingressgateway -n istio-system -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
send-100-request:
	for i in `seq 1 100`; do curl -s -o /dev/null http://${GATEWAY_URL}/productpage; done
show-kiali:
	istioctl dashboard kiali
delete-istio:
	kubectl delete -f ./ && \
	kubectl delete -f ./telemetry-addons 



