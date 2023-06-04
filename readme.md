### k8s istio 应用


1. 安装 istio
```
make install-istio
```
2. 部署 bookinfo 应用
```
make install-bookinfo
```
3. 部署网关和路由
```
make install-bookinfo-gateway
```
4. 修改 istio-ingressgateway 为 NodePort
执行以下命令 修改 istio-ingressgateway 为 NodePort,并且将 port: 80 映射为 port: 30080 
``` shell
kubectl edit svc istio-ingressgateway -n istio-system
```
5. 访问 bookinfo 服务
通过 k8s 节点的 ip 和 port 来访问 bookinfo 服务了,需要将ip,prot 替换成自己的
```
  http://192.168.31.180:30080/productpage
```

![](https://qiniu.taoluyuan.com/2023/blog20230604130140.png?imageMogr2/auto-orient/thumbnail/!70p/blur/9x0/quality/75)
6. 通过 监测工具监控网格
  * 安装 istio Telemetry Addons
  ```
  make install-telemetry-addons
  ```
  * 打开 kiali
  ```
  istioctl dashboard kiali
  ```

![](https://qiniu.taoluyuan.com/2023/blog20230604134656.png?imageMogr2/auto-orient/thumbnail/!70p/blur/9x0/quality/75)
