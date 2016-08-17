# SimpleKeychainGroupData

>앱과 앱간의 데이터 공유를 위하여 키체인을 심플하게 제작하였습니다.

  - Swift 2.0 버전으로 작성됨
  - 프로토콜 익스텐션으로 모듈화
  - 키체인 쓰기, 읽기, 삭제, 조회 기능

>키체인의 오류의 관한 정의는 keychainExtension.swift에 정의: 그외에 오류가 발생했을 경우 Issue에 남겨주시면 다음업데이트때 반영하도록 노력하겠습니다.

## 주의 사항!
> 반드시 2개의 앱에는 2개의 엑세스 그룹 도메인이 있어야 작동이 됩니다.
> 2개의 도메인을 각 2개의 앱에 등록하셔야 오류가 발생하지 않습니다.

### 참고 사이트

작업을 하는 동안 참고한 사이트 들입니다.:

* [Apple Developer] - 에플 개발자 키체인 문서!
* [Ace Editor] - awesome web-based text editor
License None
----

**라이센스는 없습니다 그러니 마음껏 퍼다가 사용하세요!**

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)


   [Apple Developer]: <https://developer.apple.com/library/ios/documentation/Security/Reference/keychainservices/>
   [Githup-KeychainAccess]: <https://github.com/kishikawakatsumi/KeychainAccess>
