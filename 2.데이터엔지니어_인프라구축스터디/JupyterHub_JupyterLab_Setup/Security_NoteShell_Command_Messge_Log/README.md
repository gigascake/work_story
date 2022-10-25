## Security_NoteShell_Command_Messge_Log

정보보안 ISSUE 문제를 해결하기 위해, 주피터노트북의 쉘 수행명령어시 !와 같은 execution command를 사용자별로 혹은 사용자로 구분처리하여, command 내용을 기록해야 한다.

- [2022-10-24] 이 과제를 해결하기 위해서, 기 구현되어 있는지, 구현되어 있지 않으면 해결책이 있는지 방안을 모색해본다.
   - 주피터 클라이언트의 커널과 메시지 통신방법 : https://jupyter-client.readthedocs.io/en/latest/messaging.html
   
   
   
[jupyterlab]

/home/hadoop/.ipython/profile_default/history.sqlite 
 
1. Type1 : %
ex) %ls

sqlite> select b.start, b.end, a.source, a.source_raw from history a, sessions b where a.session=b.session and source like 'get_ipython().run_line_magic%';


2. Type2 : !
ex) !java -version
sqlite> select b.start, b.end, a.source, a.source_raw from history a, sessions b where a.session=b.session and source like 'get_ipython().system%';
 


 
 
 