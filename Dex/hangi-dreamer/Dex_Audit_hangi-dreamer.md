# hangi-dreamer

## unchecked-transfer
### 설명
transfer/transferFrom 반환값을 체크하지 않는 버그.
토큰은 전송 실패 시 revert되지 않고 false를 반환합니다.


swap 함수
- 121 Line : IERC20(_tokenX).transferFrom(msg.sender,address(this),tokenXAmount)
- 122 Line : IERC20(_tokenY).transfer(msg.sender,outputAmount)
- 128 Line : IERC20(_tokenY).transferFrom(msg.sender,address(this),tokenYAmount)
- 129 Line : IERC20(_tokenX).transfer(msg.sender,outputAmount)

addLiquidity 함수
- 92 Line : IERC20(_tokenX).transferFrom(msg.sender,address(this),tokenXAmount)
- 93 Line : IERC20(_tokenY).transferFrom(msg.sender,address(this),tokenYAmount)

transfer 함수
- 163 Line : lpt.transfer(address(to),lpAmount)


### 파급력
Impact : High

### 해결방안
SafeERC20을 사용하거나 transfer/transferFrom 반환값이 체크되어 있는지 확인한다.



## tautology
### 설명
항진식을 포함하고 있다.


removeLiquidity 함수
- 144 Line : require(bool)(minimumTokenXAmount >= 0)
- 146 Line : require(bool)(minimumTokenYAmount >= 0)

### 파급력
Impact : Medium

### 해결방안
값 유형 또는 비교식을 변경해서 잘못된 비교를 수정해야한다.


## unchecked-lowlevel
### 설명
저수준 호출의 반환값을 체크하지 않는 버그.


addLiquidity 함수
- 106 Line : address(this).call(abi.encodeWithSelector(this.transfer.selector,msg.sender,LPTokenAmount))


### 파급력
Impact : Medium


### 해결방안
저수준 호출의 반환값을 확인하거나 기록해야한다.




## unused-return
### 설명
외부 호출의 반환값은 로컬이나 상태 변수에 저장되지 않는 버그.


constructor 함수
- 64 Line : oracle.setPrice(_tokenX,1000000000000000000)
- 65 Line : oracle.setPrice(_tokenY,1000000000000000000)


### 파급력
Impact : Medium


### 해결방안
함수 호출의 모든 반환값이 사용되었는지 확인합니다.



## shadowing-local
### 설명
로컬 변수를 사용한 섀도잉 감지.


swap.K 함수
- 58 Line : Dex.K

### 파급력
Impact : Low

### 해결방안
다른 컴포넌트를 섀도잉하는 로컬 변수의 이름을 변경합니다.



## missing-zero-check
### 설명
누락된 제로 주소 유효성 검사를 감지한다.

constructor 함수
- 61 Line : _tokenX = tokenX
- 62 Line : _tokenY = tokenY

### 파급력
Impact : Low

### 해결방안
주소가 0이 아닌지 확인합니다.



## unused-state
### 설명
사용하지 않는 상태변수가 선언되어 있다.


Dex.sol 파일
- 58 Line : Dex.K


### 파급력
Impact : Informational


### 해결방안
사용하지 않는 상태변수를 삭제한다.
