#设置变量 GATEWAY_UR=L 192.168.31.180:32468
GATEWAY_URL=192.168.31.180:30080
# 安装 istio
install-istio:
	curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.17.2 sh - && \
 	cd istio-1.17.2 && \
 	export PATH=$PWD/bin:$PATH && \
    istioctl install --set profile=demo
# 部署bookinfo应用
install-bookinfo:
	kubectl apply -f ./bookinfo.yaml 
# 部署bookinfo应用的网关
install-bookinfo-gateway:
	kubectl apply -f ./bookinfo-gateway.yaml
# 部署 检测工具
install-telemetry-addons:
	kubectl apply -f ./telemetry-addons 
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



