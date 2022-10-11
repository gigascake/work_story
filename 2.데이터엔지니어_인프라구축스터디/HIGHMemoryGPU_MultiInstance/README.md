## HIGH_Memory GPU의 Multi-Instance(MIG) 방법에 대하여 기술한다.


### 0. 대상 GPU
- 예) NVIDIA A100 80GB

### 1. 출처
- https://developer.nvidia.com/blog/getting-the-most-out-of-the-a100-gpu-with-multi-instance-gpu/

### 2. 목적 
- GPU하나당 다수의 사용자가 사용할 경우의 GPU성능저하 예방 및, GPU메모리 관리의 효율화
- 모델 추론프로세스의 GPU처리시, GPU 성능저하 예방
- GPU클라우드의 효율적인 자원관리

### 3. 환경구성을 위환 필요준비사항
- sudo권한 : /usr/bin/nvidia-smi
- 설정후 서버 리부팅 방지를 위해 : sudo systemctl stop dcgm nvsm 
- GPU인스턴스를 쉽게 사용하기 위해 : nvidia-docker2 설치. (일반 docker와 달리 docker컨테이너내에서 gpu사용가능)

#### 전제 조건
- MIG 모드에서 지원되는 GPU를 사용할 때 다음 전제 조건 및 최소 소프트웨어 버전이 권장됩니다.
- MIG는 여기 에 나열된 GPU 및 시스템에서만 지원됩니다 .
- CUDA 11 및 NVIDIA 드라이버 450.80.02 이상
- CUDA 11 지원 Linux 운영 체제 배포판
- 컨테이너를 실행하거나 Kubernetes를 사용하는 경우:
  NVIDIA 컨테이너 툴킷(엔비디아 도커2): v2.5.0 이상
  NVIDIA K8s 장치 플러그인: v0.7.0 이상
  NVIDIA GPU 기능 발견: v0.2.0 이상

- 다음 내용은 아래 문서를 참조하였습니다.
https://docs.nvidia.com/datacenter/tesla/mig-user-guide/index.html


#### Table 1. Supported GPU Products
|Product|Architecture|Microarchitecture|Compute|Capability|Memory Size|Max Number of Instances|
|-------|------------|-----------------|-------|----------|-----------|-----------------------|
|A100-SXM4|NVIDIA|Ampere|GA100|8.0|40GB|7|
|A100-SXM4|NVIDIA|Ampere|GA100|8.0|80GB|7|
|A100-PCIE|NVIDIA|Ampere|GA100|8.0|40GB|7|
|A100-PCIE|NVIDIA|Ampere|GA100|8.0|80GB|7|
|A30|NVIDIA|Ampere|GA100|8.0|24GB|4|

#### Table 2. GPU Instance Profiles on A100
|Profile Name|Fraction of Memory|Fraction of SMs|Hardware Units|L2 Cache Size|Number of Instances Available|
|------------|------------------|---------------|--------------|-------------|-----------------------------|
|MIG 1g.5gb|1/8|1/7|0|NVDECs|1/8|7|
|MIG 2g.10gb|2/8|2/7|1|NVDECs|2/8|3|
|MIG 3g.20gb|4/8|3/7|2|NVDECs|4/8|2|
|MIG 4g.20gb|4/8|4/7|2|NVDECs|4/8|1|
|MIG 7g.40gb|Full|7/7|5|NVDECs|Full|1|

#### Table 3. CUDA Concurrency Mechanisms
||Streams|MPS|MIG|
|---|----|---|---|
|Partition Type|Single Process|Logical|Physical|
|Max Partitions|Unlimited|48|7|
|SM Performance Isolation|No|Yes (by percentage, not partitioning)|Yes|
|Memory Protection|No|Yes|Yes|
|Memory Bandwidth QoS|No|No|Yes|
|Error Isolation|No|No|Yes|
|Cross-Partition Interop|Always|IPC|Limited IPC|
|Reconfigure|Dynamic|Process Launch|When Idle|

#### Table 4. Device names when using a single CI
|Memory|20gb|10gb|5gb|
|------|----|----|---|
|GPU Instance|3g|2g|1g|
|Compute Instance|3c|2c|1c|
|MIG Device|3g.20gb|2g.10gb|1g.5gb|
||GPCGPCGPC|GPCGPC|GPC|
	
#### Table 5. Device names when using multiple CIs
|Memory|20gb|20gb|
|------|----|----|
|GPU Instance|3g|3g|
|Compute Instance|1c|1c|1c|2c|1c|
|MIG Device|1c.3g.20gb|1c.3g.20gb|1c.3g.20gb|2c.3g.20gb|1c.3g.20gb|
||GPC|GPC|GPC|GPCGPC|GPC|
	
#### Table 6. GPU Instance Profiles on A30
|Profile Name|Fraction of Memory|Fraction of SMs|Hardware Units|L2 Cache Size|Number of Instances Available|
|------------|------------------|---------------|--------------|-------------|-----------------------------|
|MIG 1g.6gb|1/4|1/4|0|NVDECs /0 JPEG /0|OFA|1/4|4|
|MIG 1g.6gb+me|1/4|1/4|1|NVDEC /1 JPEG /1|OFA|1/4|1 (A single 1g profile can include media extensions)|
|MIG 2g.12gb|2/4|2/4|2|NVDECs /0 JPEG /0|OFA|2/4|2|
|MIG 4g.24gb|Full|4/4|4|NVDECs /1 JPEG /1|OFA|Full|1|


### 3. 수동관리 명령어 정리

#### 3-1. 장치확인(NV#이 포함된 항목이 표시되면, NVLINK연결됨)
- $ nvidia-smi topo -m

#### 3-2. 수동관리 명령어(root권한)

$ nvidia-smi -i <GPU ID> -mig 1



### 4. 자동관리

