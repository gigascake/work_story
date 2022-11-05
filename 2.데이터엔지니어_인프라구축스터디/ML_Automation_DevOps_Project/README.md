## ML_Automation_DevOps_Project

- 기존 DevOps 프로젝트는 너무 IT공학도 혹은 IT마케터 입장에서 DevOps가 초점을 맞추어 개발되어있다.
- 이로 인한 문제점은, UI에서 너무 잦은 마우스 클릭과 핸들링이 필요해, 데이터분석가와 데이터엔지니어의 입장에서
- 간단한 모듈 개발에는 유용해 보이나, 막상 소스의 규모가 커지게 되면, 노트북, 파이썬파일, 프로젝트관리 측면 등등/
- 관리포인트가 너무 많아진다.

### 그렇다면 해결책은?
- (1) 진정한 DevOps관점에서 데이터분석가와 데이터엔지니어의 역할분담이 명확해지려면, End-To-EndPoint를 최대한 줄이고,
- (2) 배포전 프로젝트관리 측면에서는 전체 프로젝트관리를 데이터분석가가 전부관리할수 있도록 하는 방안
- (3) 배포후 프로젝트관리 측면에서는 데이터엔지니어가 핸들링할 수 있도록 하는방안
- (4) 전체 리소스를 재활용할 수 있어야 한다.
- (5) 모델학습의 자동화/모델추론의 자동화/결과의 Report발행의 자동화
- 이렇게 5가지 방안이 마련되어야 한다.
 
- 본인은 이러한 방안에서 기 개발된 오픈소스프레임웤와 모듈을 최대한 리서치하여 가능성을 탐색하고, 탐색한 결과물에서 부족한 점을
파악한 후에, 부족한 부분에 대한 해결책을 모색하는 것이 목적이다.

### 문제해결을 위해 필요한 DevOps Feature
- 프로젝트관리 기능
- 모델관리 기능
- 워크플로우관리 기능
- JOB관리 기능
- 사용자 관리(데이터분석가와 데이터엔지니어의 구별)
- 배포 기능
- API 관리 기능

### 리서치 해결책 


### 전처리 자동화

#### 1. 입력데이터 형식을 Pandas 데이터프레임으로 일단 가정.
- 결측값 처리
- 이상치 처리
- 범주형 인코딩
- 날짜/시간 특징 추출
- 연마 단계
https://github.com/elisemercury/AutoClean
의 모든 기능을 테스트해보고 추가적으로 필요한 기능이 있으면, contributor로 활동하고, 없으면 최대한 기능을 활용해서 확장할수 있는지 여부체크.

##### AutoClean 누락부분
- (결측치처리)Deep Learning을 이용한 Imputation / Datawig


##### Pandas와 Dask.DataFrame 성능비교

테스트데이터셋(197428 rows × 16 columns)

- Pandas : 221.57005
'''
2022-10-18 04:12:00.353 | INFO     | __main__:handle:5 - Started handling of missing values...
2022-10-18 04:12:00.409 | INFO     | __main__:handle:10 - Found a total of 56061 missing value(s)
2022-10-18 04:12:00.476 | INFO     | __main__:handle:15 - Started handling of NUMERICAl missing values... Method: "AUTO"
2022-10-18 04:12:00.745 | WARNING  | __main__:_lin_regression_impute:175 - LINREG imputation failed for feature "market_id"
2022-10-18 04:12:00.786 | WARNING  | __main__:_lin_regression_impute:175 - LINREG imputation failed for feature "order_protocol"
2022-10-18 04:12:00.995 | WARNING  | __main__:_lin_regression_impute:175 - LINREG imputation failed for feature "estimated_store_to_consumer_driving_duration"
2022-10-18 04:12:05.083 | DEBUG    | __main__:_impute:99 - KNN imputation of 987 value(s) succeeded for feature "market_id"
2022-10-18 04:12:09.052 | DEBUG    | __main__:_impute:99 - KNN imputation of 995 value(s) succeeded for feature "order_protocol"
2022-10-18 04:13:12.718 | DEBUG    | __main__:_impute:99 - KNN imputation of 16262 value(s) succeeded for feature "total_onshift"
2022-10-18 04:14:16.376 | DEBUG    | __main__:_impute:99 - KNN imputation of 16262 value(s) succeeded for feature "total_busy"
2022-10-18 04:15:20.009 | DEBUG    | __main__:_impute:99 - KNN imputation of 16262 value(s) succeeded for feature "total_outstanding_orders"
2022-10-18 04:15:22.108 | DEBUG    | __main__:_impute:99 - KNN imputation of 526 value(s) succeeded for feature "estimated_store_to_consumer_driving_duration"
2022-10-18 04:15:22.109 | INFO     | __main__:handle:47 - Started handling of Categorical missing values... Method: "AUTO"
2022-10-18 04:15:23.090 | DEBUG    | __main__:_impute:126 - KNN imputation of 7 value(s) succeeded for feature "actual_delivery_time"
2022-10-18 04:15:41.924 | DEBUG    | __main__:_impute:126 - KNN imputation of 4760 value(s) succeeded for feature "store_primary_category"
2022-10-18 04:15:41.925 | INFO     | __main__:handle:73 - Completed handling of missing values in 221.57005 seconds
'''

- Dask.DataFrame 222.442516 
'''
2022-10-18 04:35:39.456 | INFO     | __main__:handle:5 - Started handling of missing values...
2022-10-18 04:35:39.762 | INFO     | __main__:handle:10 - Found a total of 56061 missing value(s)
2022-10-18 04:35:40.089 | INFO     | __main__:handle:15 - Started handling of NUMERICAl missing values... Method: "AUTO"
2022-10-18 04:35:40.352 | WARNING  | __main__:_lin_regression_impute:175 - LINREG imputation failed for feature "market_id"
2022-10-18 04:35:40.392 | WARNING  | __main__:_lin_regression_impute:175 - LINREG imputation failed for feature "order_protocol"
2022-10-18 04:35:40.591 | WARNING  | __main__:_lin_regression_impute:175 - LINREG imputation failed for feature "estimated_store_to_consumer_driving_duration"
2022-10-18 04:35:44.666 | DEBUG    | __main__:_impute:99 - KNN imputation of 987 value(s) succeeded for feature "market_id"
2022-10-18 04:35:48.633 | DEBUG    | __main__:_impute:99 - KNN imputation of 995 value(s) succeeded for feature "order_protocol"
2022-10-18 04:36:52.367 | DEBUG    | __main__:_impute:99 - KNN imputation of 16262 value(s) succeeded for feature "total_onshift"
2022-10-18 04:37:56.115 | DEBUG    | __main__:_impute:99 - KNN imputation of 16262 value(s) succeeded for feature "total_busy"
2022-10-18 04:38:59.929 | DEBUG    | __main__:_impute:99 - KNN imputation of 16262 value(s) succeeded for feature "total_outstanding_orders"
2022-10-18 04:39:02.031 | DEBUG    | __main__:_impute:99 - KNN imputation of 526 value(s) succeeded for feature "estimated_store_to_consumer_driving_duration"
2022-10-18 04:39:02.031 | INFO     | __main__:handle:47 - Started handling of Categorical missing values... Method: "AUTO"
2022-10-18 04:39:02.996 | DEBUG    | __main__:_impute:126 - KNN imputation of 7 value(s) succeeded for feature "actual_delivery_time"
2022-10-18 04:39:21.898 | DEBUG    | __main__:_impute:126 - KNN imputation of 4760 value(s) succeeded for feature "store_primary_category"
2022-10-18 04:39:21.899 | INFO     | __main__:handle:73 - Completed handling of missing values in 222.442516 seconds
'''


- Dask.DataFrame에 Pandas와의 호환성문제가 있어서 사용을 보류한다. Pandas와 호환성문제, map 관련 처리에서 오류가 존재함.

### 신규 패키지 테스트 
- multi_processing_benchmark.ipynb 파일에 정리되어있으며, 요약하면 다음과같다.
- run_prophet 수행시간 : 12m 23.92s
- multiprocessing 수행시간 : multiprocessing : 12m 44.41s
- concurrent.futures 수행시간 : concurrent futures : 12m 45.42s
- ray 수행시간 : Ray : 39s
#### 미친 수행속도 : 10일걸리던 125기가 데이터전처리 자동화작업이 10분만에 끝난다.
#### 결론 : Ray생태계를 확실히 파악해서 내것으로 만들자.

https://www.youtube.com/watch?v=cEF3ok1mSo0
https://docs.ray.io/en/master/ray-air/examples/index.html