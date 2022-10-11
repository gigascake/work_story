# Dask-Cluster Environment Setup Guide

- TargetServer_1 : CPU: Intel Xeon(Gold), GPU: A100x8, OS: RedHat7.5
- TargetServer_2 : CPU: AMD ThreadRipper, GPU: RTX3090x4, OS: Centos7

#### 목적 : GPU병렬처리를 xgboost와 pytorch에서 원활히 이용가능한 환경을 구축한다.

- 기테스트한 GPU병렬처리 방법의 문제점과 Dask-Cluster선택이유 : Python Ray for multiprocessing, Python Parallel, horovod를 테스트해보았다.
    기존에 GPU학습모델코드에 변환하기에는 horovod가 그나마 이식이 좋았으나, 코드의 가독성이 떨어지고,
	DataLoader 부분에서 의존적이라, 시계열데이터 미니배치학습에 문제점을 보였다. 아니면 내가 코드를 잘못짰을수도 있지만,
	그래서보다, 코드의 이식이 쉽고, 회사의 데이터분석가분이 xgboost에서 dask사용을 원하기에, 한번 셋팅해보았는데, 프로세스가 간편하고 기소스의 이식이 원활해보인다.
    GPU병렬처리 및, 모델링작업프로세스간소화를 위해 4개월동안 삽질했던것이 이 녀석으로 마무리 될거 같다.
	
### 1. 설치전 주의사항
* dask client, scheduler, worker의 버전을 맞춰야 한다.
- python 버전,
- distributed 버전,
- dask 버전,
- torch 버전,

### 2. 설치패키지 체크 히스토리 
- 1) conda 설치의 특성상, dependency 오류체크 프로세스로 인해 가상환경의 핵심패키지 버전을 명시하는게 중요하다.
- 2) 다음 공식사이트를 통해, 블로그질하며 삽질하던 과정을 줄일수 있고, GPU병렬처리 필수패키지를 설치할 수 있으나,전체설치시, 부분설치시에도 os모듈의 누락이 발생한다.
  (전체설치 명령어) $ conda create -n rapids-22.08 -c rapidsai -c nvidia -c conda-forge \
rapids=22.08 python=3.9 cudatoolkit=11.0 \
dask-sql dash graphistry pycaret xarray-spatial
 
#### add-on
*** 전체 add-on 설치시 xgboost dask가 정상동작을 안한다. 문제의 원인파악을 위해 하나씩 설치해서 테스트해본다. 
문제없음$ pip install dask-pytorch-ddp 
문제없음$ conda install -c rapidsai -c nvidia -c conda-forge skorch 
충돌남$ conda install -c rapidsai -c nvidia -c conda-forge cuml=22.08
충돌남$ conda install -c rapidsai -c nvidia -c conda-forge cugraph=22.08
문제없음$ conda install -c rapidsai -c nvidia -c conda-forge cuspatial=22.08
문제없음$ conda install -c rapidsai -c nvidia -c conda-forge cuxfilter=22.08
문제없음$ conda install -c rapidsai -c nvidia -c conda-forge cusignal=22.08
문제없음$ conda install -c rapidsai -c nvidia -c conda-forge cucim=22.08
문제없음$ conda install -c rapidsai -c nvidia -c conda-forge dask-sql
문제없음$ conda install -c rapidsai -c nvidia -c conda-forge xarray-spatial 
문제없음$ conda install -c rapidsai -c nvidia -c conda-forge pycaret 
문제없음$ conda install -c rapidsai -c nvidia -c conda-forge graphistry 
문제없음$ conda install -c rapidsai -c nvidia -c conda-forge dash

### 3. 최종정리된 설치 명령어

$ conda create -n dask_cuda -c rapidsai -c nvidia -c conda-forge dask-cuda=22.08.00=py39_g9a61ce5_0 dask-cudf=22.08.00=cuda_11_py39_gb71873c701_0 xgboost cudatoolkit=11.0 ipykernel skorch cuspatial=22.08 cuxfilter=22.08 cusignal=22.08 cucim=22.08 dask-sql xarray-spatial pycaret graphistry dash
$ pip install dask-pytorch-ddp

### 4. GPU병렬처리에서 bottolenec은 TCP통신이다. NVLINK프로토콜도 나은대안인데 성능하락은 피할 수 없다. 기서버에 NVlink가 없는지라 UCX프로토콜을 통해서 성능향상을 노린다.
- 근거자료 : https://www.dask.org/blog/experiments-in-high-performance-networking-with-ucx-and-dgx

$ conda install -c rapidsai -c nvidia -c conda-forge ucx ucx-py



