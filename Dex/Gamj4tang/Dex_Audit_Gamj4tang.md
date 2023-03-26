# Gamj4tang

## unchecked-transfer
### 설명
transfer/transferFrom 반환값을 체크하지 않는 버그.
토큰은 전송 실패 시 revert되지 않고 false를 반환합니다.


swap 함수
- 160 Line : inputToken.transferFrom(msg.sender,address(this),inputAmount)
- 161 Line : outputToken.transfer(msg.sender,outputAmount)

addLiquidity 함수
- 78 Line : tokenX.transferFrom(msg.sender,address(this),tokenXAmount)
- 79 Line : tokenY.transferFrom(msg.sender,address(this),tokenYAmount)

removeLiquidity 함수
- 107 Line : tokenX.transfer(msg.sender,tokenXAmount)
- 108 Line : tokenY.transfer(msg.sender,tokenYAmount)

### 파급력
Impact : High

### 해결방안
SafeERC20을 사용하거나 transfer/transferFrom 반환값이 체크되어 있는지 확인한다.


## incorrect-equality
### 설명
공격자가 쉽게 조작할 수 있는 strict equalities를 사용한다.


addLiquidity 함수
- 54 Line : totalLiquidity == 0


_mul 함수
- 203 Line : a == 0
- 207 Line : require(bool,string)(c / a == b,SafeMath: multiplication overflow)

### 파급력
Impact : Medium

### 해결방안
계정의 토큰 보유량을 확인하기 위해서 strict equality를 사용하면 안된다.



## locked-ether
### 설명
ETH의 payable 함수를 통해 지급 기능이 있지만, 출금 기능이 없어서 ETH가 컨트랙트에 귀속된다.


receive()

### 파급력
Impact : Medium

### 해결방안
payable 속성을 제거하거나 withdraw 함수를 추가한다.





## tautology
### 설명
항진식을 포함하고 있다.


swap 함수
- 127 Line : require(bool,string)(tokenXAmount >= 0 || tokenYAmount >= 0,Amounts must be greater than zero.)

### 파급력
Impact : Medium

### 해결방안
값 유형 또는 비교식을 변경해서 잘못된 비교를 수정해야한다.



## reentrancy-benign
### 설명
이중 호출로 인한 재진입 버그.


addLiquidity 함수
- 78 Line : tokenX.transferFrom(msg.sender,address(this),tokenXAmount)
- 79 Line : tokenY.transferFrom(msg.sender,address(this),tokenYAmount)
- 81 Line : transfer(msg.sender,lpTokenCreated)


removeLiquidity 함수
- 107 Line : tokenX.transfer(msg.sender,tokenXAmount)
- 108 Line : tokenY.transfer(msg.sender,tokenYAmount)
- 110 Line : _burn(msg.sender,LPTokenAmount)

### 파급력
Impact : Low

### 해결방안
CEI(Check-effects-interactions) 패턴을 적용시킨다.


## unused-state
### 설명
사용하지 않는 상태변수가 선언되어 있다.


Dex.sol 파일
- 21 Line : Dex.TOKEN_DECIMALS


### 파급력
Impact : Informational


### 해결방안
사용하지 않는 상태변수를 삭제한다.
